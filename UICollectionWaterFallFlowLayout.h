//
//  UICollectionWaterFallFlowLayout.h
//  瀑布流Demo
//
//  Created by caikaixuan on 2018/6/20.
//  Copyright © 2018年 caikaixuantest. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UICollectionWaterFallFlowLayout;

@protocol UICollectionWaterFallFlowLayoutDelegate<NSObject>
@required
- (CGFloat)layout:(UICollectionWaterFallFlowLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;

@end

//UICollectionViewFlowLayout

@interface UICollectionWaterFallFlowLayout : UICollectionViewLayout

@property (nonatomic, assign) NSInteger columnCount;//列数
@property (nonatomic) UIEdgeInsets itemInset;//每个item的内间距
@property (nonatomic) CGFloat minimumLineSpacing;//每行的间距
@property (nonatomic) CGFloat minimumInteritemSpacing;//每列的间距

@property (nonatomic, weak) id<UICollectionWaterFallFlowLayoutDelegate> delegate;

@end
