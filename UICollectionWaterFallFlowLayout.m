//
//  UICollectionWaterFallFlowLayout.m
//  瀑布流Demo
//
//  Created by caikaixuan on 2018/6/20.
//  Copyright © 2018年 caikaixuantest. All rights reserved.
//

#import "UICollectionWaterFallFlowLayout.h"

@interface UICollectionWaterFallFlowLayout()

/** 存放所有的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArr;

/** 存放所有列的当前高度 */
@property (nonatomic, strong) NSMutableArray *columnHeights;

/** 内容的高度 */
@property (nonatomic, assign) CGFloat contentHeight;


@end

@implementation UICollectionWaterFallFlowLayout

- (instancetype)init{
    if (self = [super init]) {
        self.columnCount = 2;
        self.itemInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.minimumLineSpacing = 10;
        self.minimumInteritemSpacing = 10;
    }
    return self;
}

- (NSMutableArray *)attrsArr{
    if (!_attrsArr) {
        _attrsArr=[NSMutableArray array];
    }
    return _attrsArr;
}

- (NSMutableArray *)columnHeights{
    if (!_columnHeights) {
        _columnHeights=[NSMutableArray array];
    }
    return _columnHeights;
}

- (void)prepareLayout{
    [super prepareLayout];
    
    self.columnHeights = 0;
    [self.columnHeights removeAllObjects];
    [self.attrsArr removeAllObjects];
    
    for (NSInteger i=0; i<self.columnCount; i++) {
        [self.columnHeights addObject:@(self.itemInset.top)];
    }
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (int i = 0; i < count; i++) {
        
        // 创建位置
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        // 获取indexPath位置上cell对应的布局属性
        UICollectionViewLayoutAttributes * attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [self.attrsArr addObject:attrs];
    }
    
    
}

/**
 * 返回indexPath位置cell对应的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // 创建布局属性
    UICollectionViewLayoutAttributes * attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //collectionView的宽度
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    
    // 设置布局属性的frame
    
    CGFloat cellW = (collectionViewW - self.itemInset.left - self.itemInset.right - (self.columnCount - 1) * self.minimumLineSpacing) / self.columnCount;
    CGFloat cellH = [self.delegate layout:self heightForItemAtIndexPath:indexPath itemWidth:cellW];
    
    
    // 找出最短的那一列
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    
    for (int i = 1; i < self.columnCount; i++) {
        
        // 取得第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    
    CGFloat cellX = self.itemInset.left + destColumn * (cellW + self.minimumLineSpacing);
    CGFloat cellY = minColumnHeight;
    if (cellY != self.itemInset.top) {
        
        cellY += self.minimumInteritemSpacing;
    }
    
    attrs.frame = CGRectMake(cellX, cellY, cellW, cellH);
    
    // 更新最短那一列的高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    // 记录内容的高度 - 即最长那一列的高度
    CGFloat maxColumnHeight = [self.columnHeights[destColumn] doubleValue];
    if (self.contentHeight < maxColumnHeight) {
        self.contentHeight = maxColumnHeight;
    }
    
    return attrs;
}

/**
 * 决定cell的高度
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    return self.attrsArr;
}

/**
 * 内容的高度
 */
- (CGSize)collectionViewContentSize{
    
    return CGSizeMake(0, self.contentHeight + self.itemInset.bottom);
}

@end
