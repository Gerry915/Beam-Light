//
//  ImageService.swift
//  Beam Light
//
//  Created by Gerry Gao on 2/3/2022.
//

import UIKit

final class ImageService: ImageCacheable {
    
    // MARK: - Properties
    
    private let maximumCacheSizeInMemory: Int
    private let maximumCacheSizeOnDisk: Int
    private let cacheOnDiskQueue = DispatchQueue(label: "au.com.genggao.cacheOnDiskQueue", qos: .utility)
    private var imageCacheDirectory: URL {
        // Get the cache dir
        FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)[0]
        // append the image folder
            .appendingPathComponent("ImageCache")
    }
    // a property holding the caches
    private var cache: [CachedImage] = []
    
//    // Return type for hiding the implementation
//    private struct CacheRequest: Cancellable {
//        func cancel(){}
//    }
    
    
    init(maximumCacheSizeInMemory: Int, maximumCacheSizeOnDisk: Int) {
        // Set Maximum Cache Size
        self.maximumCacheSizeInMemory = maximumCacheSizeInMemory
        self.maximumCacheSizeOnDisk = maximumCacheSizeOnDisk
        
        // Create Image Cache Directory
        createImageCacheDirectory()
        
        // Update Cache on Disk
        updateCacheOnDisk()
    }
    
    func cache(for url: URL, completion: @escaping (UIImage?) -> Void) -> Cancellable {
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            // Helper
            let result: Result<Data, Error>? = {
                if let data = data {
                    // Success
                    return .success(data)
                } else if let error = error, (error as NSError).code != URLError.cancelled.rawValue {
                    // Failure
                    return .failure(error)
                } else {
                    // Cancelled
                    return nil
                }
            }()
            
            // Execute Handler on Main Thread
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
//                    print("Data Task Succeeded")
                    
                    // Execute Handler
                    completion(UIImage(data: data))
                    
                    // Cache Image
                    self?.cacheImage(data, for: url)
                case .failure:
                    print("Data Task Failed")
                    
                    // Execute Handler
                    completion(nil)
                case .none:
                    print("Data Task Cancelled")
                    
                    break
                }
            }
        }
        
        // Request Cached Image
        cachedImage(for: url) { image in
            if let image = image {
                // Execute Handler on Main Thread
                DispatchQueue.main.async {
                    // Execute Handler
                    completion(image)
                }
            } else {
                // Fetch Image
                dataTask.resume()
            }
        }
        
        return dataTask
    }
    
    // MARK: - Helper Methods
    
    private func cacheImage(_ data: Data, for url: URL, writeToDisk: Bool = true) {
        // Calculate Cache Size
        var cacheSize = cache.reduce(0) { result, cachedImage -> Int in
            result + cachedImage.data.count
        }
        
        while cacheSize > maximumCacheSizeInMemory {
            // Remove Oldest Cached Image
            let oldestCachedImage = cache.removeFirst()
            
            // Update Cache Size
            cacheSize -= oldestCachedImage.data.count
        }
        
        // Create Cached Image
        let cachedImage = CachedImage(url: url, data: data)
        
        // Cache Image
        cache.append(cachedImage)
        
        if writeToDisk {
            cacheOnDiskQueue.async {
                // Write Image to Disk
                self.writeImageToDisk(data, for: url)
            }
        }
    }
    
    private func cachedImage(for url: URL, completion: @escaping (UIImage?) -> Void) {
        if
            // Default to Cache in Memory
            let data = cache.first(where: { $0.url == url })?.data
        {
//            print("Using Cache in Memory")
            
            // Execute Handler
            completion(UIImage(data: data))
        }
        else
        {
            DispatchQueue.global(qos: .userInitiated).async {
                // Fall Back to Cache on Disk
                guard let data = try? Data(contentsOf: self.locationOnDisk(for: url)) else {
                    // Execute Handler
                    completion(nil)
                    
                    return
                }
                
//                print("Using Cache on Disk")
                
                // Cache Image in Memory
                self.cacheImage(data, for: url, writeToDisk: false)
                
                // Execute Handler
                completion(UIImage(data: data))
            }
        }
    }
    
    private func updateCacheOnDisk() {
        do {
            // Helpers
            let resourceKeys: [URLResourceKey] = [
                .creationDateKey,
                .totalFileAllocatedSizeKey
            ]
            
            // List Contents of Directory
            let contents = try FileManager.default.contentsOfDirectory(at: imageCacheDirectory,
                                                                       includingPropertiesForKeys: resourceKeys,
                                                                       options: [])
            
            // Map `URL` Objects to `File` Objects
            var files = try contents.compactMap { url -> File? in
                // Fetch Resource Values
                let resourceValues = try url.resourceValues(forKeys: Set(resourceKeys))
                
                guard
                    let createdAt = resourceValues.creationDate,
                    let size = resourceValues.totalFileAllocatedSize
                else {
                    return nil
                }
                
                return File(url: url, size: size, createdAt: createdAt)
            }
            // Sort by Created At
            .sorted { $0.createdAt < $1.createdAt }
            
            // Calculate Cache Size
            var cacheSize = files.reduce(0) { result, cachedImage -> Int in
                result + cachedImage.size
            }
            
//            print("\(files.count) Images Cached, Size on Disk \(cacheSize / .kilobyte) KB")
            
            while cacheSize > maximumCacheSizeOnDisk {
                if files.isEmpty {
                    break
                }
                
                // Remove Oldest Cached Image
                let oldestCachedImage = files.removeFirst()
                try FileManager.default.removeItem(at: oldestCachedImage.url)
                
                // Update Cache Size
                cacheSize -= oldestCachedImage.size
            }
        } catch {
            print("Unable to Update Cache on Disk \(error)")
        }
    }
    
    private func writeImageToDisk(_ data: Data, for url: URL) {
        do {
            // Write Image to Disk
            try data.write(to: locationOnDisk(for: url))
            
            // Update Cache on Disk
            updateCacheOnDisk()
        } catch {
            print("Unable to Write Image to Disk \(error)")
        }
    }
}

private extension ImageService {
    
    // MARK: - Extension -> Type
    
    private struct CachedImage {
        let url: URL
        let data: Data
    }
    
    private struct File {
        let url: URL
        let size: Int
        let createdAt: Date
    }
}

fileprivate extension ImageService {
    
    // MARK: - Extension -> Small helpers
    
    /// Create the directory for saving cache
    func createImageCacheDirectory() {
        do {
            try FileManager.default.createDirectory(at: imageCacheDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Unable to create image Cache Dir")
        }
    }
    
    /// Return the location on disk for giving image URL
    func locationOnDisk(for url: URL) -> URL {
        // Define Filename
        let fileName = Data(url.absoluteString.utf8).base64EncodedString()
        
        // Define Location on Disk
        return imageCacheDirectory.appendingPathComponent(fileName)
    }
}
