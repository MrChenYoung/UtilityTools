//
//  OriginalImagePickerCtr.m
//  Demo
//
//  Created by MrChen on 2018/3/19.
//  Copyright © 2018年 MrChen. All rights reserved.
//

#import "OriginalImagePickerCtr.h"
#import "HYImagePickerManager.h"

@interface OriginalImagePickerCtr ()

@end

@implementation OriginalImagePickerCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统选择照片";
    
    // block handle
    [self blockHandle];
}

// block handle
- (void)blockHandle
{
    __weak typeof(self) weakSelf = self;
    HYImagePickerManager *imagePickerMgr = [HYImagePickerManager shareManager];
    // 获取照片名字
    imagePickerMgr.getImageName = YES;
    // 照片可编辑
//    imagePickerMgr.canEdite = YES;
    self.openCameraBlock = ^{
        // 打开相机
        imagePickerMgr.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 开启人脸识别
        [imagePickerMgr showAnimated:YES];
    };
    
    self.openAlbumBlick = ^{
        // 打开相册
        imagePickerMgr.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [imagePickerMgr showAnimated:YES];
    };
    
    // 选择照片完成
    imagePickerMgr.imagePickComplete = ^(UIImage *originImage, UIImage *editedImage, NSString *imageName) {
        
        // 原图片
        if (originImage) {
            [weakSelf.selectImages addObject:originImage];
        }
        
        // 编辑后图片
        if (editedImage) {
            [weakSelf.selectImages addObject:editedImage];
        }
        
        NSLog(@"照片名为:%@",imageName);
        
        [weakSelf.collectionView reloadData];
    };
}


@end
