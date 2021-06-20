//
//  ToDoLayout.swift
//  ToDoList
//
//  Created by Софья Тимохина on 19.06.2021.
//

import UIKit

struct LayoutAttributes {
    let contentSize: CGSize
    let attributes: [IndexPath: UICollectionViewLayoutAttributes]
}

final class ToDoLayout: UICollectionViewLayout {
    var layoutAttributesCache = LayoutAttributes(
        contentSize: .zero,
        attributes: [:])
    override func prepare() {
        guard let collectionView = self.collectionView else { return }
        collectionView.layer.cornerRadius = 16
        layoutAttributesCache = layoutAttributes(
            for: collectionView,
            itemSize: CGSize(width: collectionView.bounds.width, height: 100))
    }
    override var collectionViewContentSize: CGSize {
        layoutAttributesCache.contentSize
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        layoutAttributesCache.attributes.values.filter({$0.frame.intersects(rect)})
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if let oldBounds = collectionView?.bounds, newBounds.size != oldBounds.size {
            return true
        }
        return super.shouldInvalidateLayout(forBoundsChange: newBounds)
    }
    private func layoutAttributes(for collectionView: UICollectionView, itemSize: CGSize) -> LayoutAttributes {
        let indexPaths = (0..<collectionView.numberOfSections).flatMap {section in
            (0..<collectionView.numberOfItems(inSection: section)).map { index in
                IndexPath(row: index, section: section)
            }
        }
        var resultAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
        var xxx = 0 as CGFloat
        for indexPath in indexPaths {
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = CGRect(x: 0, y: xxx, width: itemSize.width, height: itemSize.height)
            resultAttributes[indexPath] = attributes
            xxx += itemSize.height
        }
        let contentSize = CGSize(width: itemSize.width, height: xxx)
        return LayoutAttributes(contentSize: contentSize, attributes: resultAttributes)
    }
}
