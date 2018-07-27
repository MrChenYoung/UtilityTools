//
//  ThirdImagePickerCtr.m
//  Demo
//
//  Created by MrChen on 2018/3/19.
//  Copyright © 2018年 MrChen. All rights reserved.
//

#import "ThirdImagePickerCtr.h"
#import "HYImagePickerManager.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "TZLocationManager.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ThirdImagePickerCtr ()<TZImagePickerControllerDelegate>

// 位置
@property (nonatomic, strong) CLLocation *myLocation;

// 是否允许裁剪照片
@property (nonatomic, assign) BOOL canCropImage;

// 照片是否按照修改时间升序排列
@property (nonatomic, assign) BOOL sortAscendingByModificationDate;

// 是否允许圆形裁剪框(YES表示圆形裁剪框，NO表示矩形裁剪框)
@property (nonatomic, assign) BOOL needCircleCrop;

// 裁剪框大小
@property (nonatomic, assign) CGFloat cropLength;

// 是否允许选择照片原图
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;

// 是否允许在选择照片界面拍照
@property (nonatomic, assign) BOOL allowTakePicture;

@end

@implementation ThirdImagePickerCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"第三方选择照片";
    
    // 允许裁剪
    self.canCropImage = YES;
    // 照片按照修改时间升序排列
    self.sortAscendingByModificationDate = YES;
    // 允许圆形裁剪框
    self.needCircleCrop = YES;
    // 裁剪框的大小
    self.cropLength = 180;
    // 允许选择照片原图
    self.isSelectOriginalPhoto = YES;
    // 允许在选择照片界面拍照
    self.allowTakePicture = NO;
    
    // block handle
    [self blockHandle];
}

// block handle
- (void)blockHandle
{
    __weak typeof(self) weakSelf = self;
    self.openCameraBlock = ^{
        // 打开相机
        [weakSelf openCamera];
    };
    
    self.openAlbumBlick = ^{
      // 打开相册
        TZImagePickerController *imagePickCtr = [[TZImagePickerController alloc]initWithMaxImagesCount:10 columnNumber:3 delegate:weakSelf pushPhotoPickerVc:YES];
        
        // 是否允许选择原图
        imagePickCtr.isSelectOriginalPhoto = weakSelf.isSelectOriginalPhoto;
        // 设置目前已经选中的图片数组
        imagePickCtr.selectedAssets = weakSelf.selectAssets;
        // 是否允许用户在相册页面点击拍照按钮
        imagePickCtr.allowTakePicture = weakSelf.allowTakePicture;
        [weakSelf presentViewController:imagePickCtr animated:YES completion:nil];
    };
    
    self.imageDidSelectBlock = ^(NSIndexPath *indexPath) {
        TZImagePickerController *imagePreview = [[TZImagePickerController alloc]initWithSelectedAssets:weakSelf.selectAssets selectedPhotos:weakSelf.selectImages index:indexPath.row];
            imagePreview.maxImagesCount = weakSelf.selectImages.count;
            [imagePreview setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets,BOOL stop){
                    [weakSelf.selectImages removeAllObjects];
                    weakSelf.selectImages = [photos mutableCopy];
                    [weakSelf.selectAssets removeAllObjects];
                    weakSelf.selectAssets = [assets mutableCopy];
                    [weakSelf.collectionView reloadData];
            }];
            [weakSelf presentViewController:imagePreview animated:NO completion:nil];
    };
}

// 打开相机
- (void)openCamera
{
    // 定位
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
        self.myLocation = locations.lastObject;
    } failureBlock:^(NSError *error) {
        self.myLocation = nil;
    }];
    
    HYImagePickerManager *imagePickerMgr = [HYImagePickerManager shareManager];
    imagePickerMgr.sourceType = UIImagePickerControllerSourceTypeCamera;
    [imagePickerMgr showAnimated:YES];
    
    imagePickerMgr.imagePickComplete = ^(UIImage *originImage, UIImage *editedImage, NSString *imageName) {
        [self takePictureComplete:originImage];
    };
}

- (void)takePictureComplete:(UIImage *)originImage
{
    TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    // 照片按照修改时间升序排列
    tzImagePickerVc.sortAscendingByModificationDate = self.sortAscendingByModificationDate;
    [tzImagePickerVc showProgressHUD];
    UIImage *image = originImage;
    
    // 保存图片，获取到asset
    [[TZImageManager manager] savePhotoWithImage:image location:self.myLocation completion:^(NSError *error){
        if (error) {
            [tzImagePickerVc hideProgressHUD];
            NSLog(@"图片保存失败 %@",error);
        } else {
            // 获取相册照片
            [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES needFetchAssets:YES completion:^(TZAlbumModel *model) {
                
                // 获取asset
                [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                    [tzImagePickerVc hideProgressHUD];
                    TZAssetModel *assetModel = [models firstObject];
                    if (tzImagePickerVc.sortAscendingByModificationDate) {
                        assetModel = [models lastObject];
                    }
                    
                    // 允许裁剪,去裁剪
                    if (self.canCropImage) {
                        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                            [self reloadImages:cropImage asset:asset];
                        }];
                        
                        // 裁剪框设置
                        imagePicker.needCircleCrop = self.needCircleCrop;
                        imagePicker.circleCropRadius = self.cropLength;
                        
                        [self presentViewController:imagePicker animated:YES completion:nil];
                    } else {
                        [self reloadImages:image asset:assetModel.asset];
                    }
                }];
            }];
        }
    }];
}

// 刷新数据
- (void)reloadImages:(UIImage *)newImage asset:(PHAsset *)asset
{
    [self.selectImages addObject:newImage];
    [self.selectAssets addObject:asset];
    [self.collectionView reloadData];
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
    self.selectImages = [NSMutableArray arrayWithArray:photos];
    self.selectAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [self.collectionView reloadData];
    
    // 打印图片名字
    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
        NSLog(@"图片名字:%@",fileName);
    }
}


@end
