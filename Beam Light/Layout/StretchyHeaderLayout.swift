//
//  StretchyHeaderLayout.swift
//  Beam Light
//
//  Created by Gerry Gao on 3/3/2022.
//

import UIKit

class StretchyHeaderLayout: UICollectionViewCompositionalLayout {
    
    var headerHeight: CGFloat?
    
    var keyWindow: UIWindow?
    
    init(section: NSCollectionLayoutSection, headerHeight: CGFloat) {
        super.init(section: section)
        self.headerHeight = headerHeight
        
        keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // Get layout attributes form collectionView
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        // Looping through all attributes
        layoutAttributes?.forEach({ attribute in

            // Find header attribute in the first section
            
            if attribute.representedElementKind == UICollectionView.elementKindSectionHeader && attribute.indexPath.section == 0 {

                guard let collectionView = collectionView else { return }
                
                let contentOffsetY = collectionView.contentOffset.y
                // If the collectionView scroll on the other direction, just return
                if contentOffsetY > 0 {
                    return
                }
                
                let width = collectionView.frame.width
                let height = headerHeight! - contentOffsetY
                
                let topInset = keyWindow?.safeAreaInsets.top ?? 0
                
                attribute.frame = CGRect.init(x: 0, y: contentOffsetY + topInset + 44, width: width, height: height - topInset - 44)
                
            }
        })
        
        
        return layoutAttributes
        
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

