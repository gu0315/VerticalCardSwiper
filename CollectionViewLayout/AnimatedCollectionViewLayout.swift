//
//  AnimatedCollectionViewLayout.swift
//  CollectionViewLayout
//
//  Created by 顾钱想 on 2023/7/22.
//

import UIKit

class AnimatedCollectionViewLayout: UICollectionViewFlowLayout {
    
    var visibleNextCardHeight: CGFloat = 100
    
    let zoomFactor: CGFloat = 0.8 // 调整缩放的程度，根据需要进行调整
    
    var numberOfItems: Int {
        guard let item = collectionView?.numberOfItems(inSection: 0) else {
            return 0
        }
        return item
    }
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    override init() {
        super.init()
        self.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - visibleNextCardHeight)
        self.minimumLineSpacing = 16
        self.scrollDirection = .vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepare() {
        super.prepare()
        self.cache.removeAll(keepingCapacity: true)
    }
    
    private func setAttributes() {
        if self.numberOfItems == 0 {
            return
        }
        for item in 0..<self.numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            cache.append(attribute)
        }
        
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    /// 滚动时停下的偏移量
    /// - Parameters:
    ///   - proposedContentOffset: 将要停止的点
    ///   - velocity: 滚动速度
    /// - Returns: 滚动停止的点
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard
            let collectionView = self.collectionView
        else {
            let latestOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
            return latestOffset
        }
        let pageHeight = self.itemSize.height + self.minimumLineSpacing
        let offset = collectionView.contentOffset.y + collectionView.contentInset.top
        let approximatePage = offset / pageHeight
        let currentPage = velocity.y == 0.0 ? round(approximatePage) : (velocity.y < 0.0 ? floor(approximatePage) : ceil(approximatePage))
        let targetYOffset = currentPage * pageHeight - collectionView.contentInset.top
        return CGPoint(x: proposedContentOffset.x, y: targetYOffset)
    }
    
    
    /// 检索指定矩形中所有单元格和视图
    /// - Parameter rect: 包含目标视图的矩形
    /// - Returns: 布局信息的 UICollectionViewLayoutAttributes 对象数组
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        let y = collectionView.bounds.minY - self.itemSize.height
        let newRect = CGRect(x: 0, y: y < 0 ? 0 : y, width: collectionView.bounds.maxX, height: collectionView.bounds.maxY)
        let items = NSArray(array: super.layoutAttributesForElements(in: newRect)!, copyItems: true)
        // 可见矩阵, 当前屏幕的Rect
        let visiableRect = CGRectMake(collectionView.contentOffset.x, collectionView.contentOffset.y, collectionView.frame.width, collectionView.frame.height)
        for object in items {
            if let attributes = object as? UICollectionViewLayoutAttributes {
                // 不在可见区域的attributes不变化
                if !CGRectIntersectsRect(visiableRect, attributes.frame) {continue}
                self.updateCellAttributes(attributes)
            }
        }
        return items as? [UICollectionViewLayoutAttributes]
    }
    
    
    internal override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if self.collectionView?.numberOfItems(inSection: 0) == 0 { return nil }
        if let attr = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes {
            self.updateCellAttributes(attr)
            return attr
        }
        return nil
    }
    
    func updateCellAttributes(_ attributes: UICollectionViewLayoutAttributes) {
        guard let collectionView = collectionView else { return }
        let originalCenter = attributes.center
        let frame = attributes.frame
        let distance = abs(collectionView.contentOffset.y + collectionView.contentInset.top - frame.origin.y)
        let scale = min(max(1 - distance/(collectionView.bounds.height), zoomFactor), 1)
        attributes.transform = CGAffineTransformMakeScale(scale, scale)
  
        // 计算缩放后的偏移量
        let offsetY = attributes.bounds.height * (scale - 1) / 2
        // 调整视图位置，以抵消缩放后的向下偏移
        attributes.center = CGPoint(x: originalCenter.x, y: originalCenter.y + offsetY)
    }
}
