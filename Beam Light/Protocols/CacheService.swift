//
//  CacheService.swift
//  Beam Light
//
//  Created by Gerry Gao on 3/3/2022.
//

import Foundation
import UIKit

protocol ImageCacheable {
    
    func cache(for url: URL, completion: @escaping (UIImage?) -> Void) -> Cancellable
    
}
