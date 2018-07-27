//
//  ImageListController.h
//  Demo
//
//  Created by MrChen on 2018/3/19.
//  Copyright © 2018年 MrChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYViewController.h"
#import <Photos/Photos.h>

@interface ImageListController : HYViewController

// collectionView
@property (nonatomic, strong) UICollectionView *collectionView;

// 选择的照片组
@property(nonatomic,strong)NSMutableArray<UIImage *> *selectImages;

// PHAsset组
@property(nonatomic,strong)NSMutableArray<PHAsset *> *selectAssets;


// 打开相机回调
@property (nonatomic, copy) void (^openCameraBlock)(void);

// 打开相册回调
@property (nonatomic, copy) void (^openAlbumBlick)(void);

// 点击选择的照片回调
@property (nonatomic, copy) void (^imageDidSelectBlock)(NSIndexPath *indexPath);

@end
