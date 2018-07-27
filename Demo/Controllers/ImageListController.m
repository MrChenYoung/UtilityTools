//
//  ImageListController.m
//  Demo
//
//  Created by MrChen on 2018/3/19.
//  Copyright © 2018年 MrChen. All rights reserved.
//

#import "ImageListController.h"
#import "LxGridViewFlowLayout.h"
#import "UIView+Category.h"
#import "AppConstMacro.h"

@interface ImageListController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation ImageListController
#pragma mark - 懒加载
-(NSMutableArray *)selectImages{
    if(_selectImages == nil){
        _selectImages = [NSMutableArray new];
    }
    return _selectImages;
}

-(NSMutableArray *)selectAssets{
    if(_selectAssets == nil){
        _selectAssets = [NSMutableArray new];
    }
    return _selectAssets;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // create subviews
    [self createSubViews];
}

- (void)createSubViews
{
    // create collectionView
    LxGridViewFlowLayout *layout = [LxGridViewFlowLayout new];
    CGFloat margin = 4.0f;
    CGFloat itemW = (self.view.frame.size.width - 3 * margin - 12.0f * 2.0f) / 4.0f;
    layout.itemSize = CGSizeMake(itemW, itemW);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64.0f, self.view.frame.size.width, self.view.frame.size.height - 64 - 40) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.contentInset         = UIEdgeInsetsMake(10, 12, 10, 12);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_collectionView registerClass:[ImageGridCollectionViewCell class] forCellWithReuseIdentifier:@"ImageGridCollectionViewCell"];
    [self.view addSubview:_collectionView];
    
    // create tipview
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, _collectionView.viewMaxY, self.view.viewWidth, 40)];
    label.text = @"长按图片可重新排序";
    label.textColor = lightGray_color;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label];
}

// 添加照片
- (void)addImg
{
    __weak typeof(self) weakSelf = self;
    [self showImagePickActionSheet:^{
        if (weakSelf.openCameraBlock) {
            weakSelf.openCameraBlock();
        }
    } openAlbum:^{
        if (weakSelf.openAlbumBlick) {
            weakSelf.openAlbumBlick();
        }
    }];
}

// createActionsheet
- (void)showImagePickActionSheet:(void (^)(void))openCamera openAlbum:(void (^)(void))openAlbum
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择照片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 打开相机
        if (openCamera) {
            openCamera();
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        // 打开相册
        if (openAlbum) {
            openAlbum();
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.selectImages.count + 1;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageGridCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageGridCollectionViewCell" forIndexPath:indexPath];
    cell.imageView.image = nil;
    if(indexPath.row < _selectImages.count){
        cell.imageView.image = _selectImages[indexPath.row];
        
        UIButton *btn = [cell.contentView viewWithTag:800];
        if (btn) {
            [btn removeFromSuperview];
        }
    }else if (![cell.contentView viewWithTag:800]) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        btn.center = cell.contentView.center;
        [btn addTarget:self action:@selector(addImg) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"添加" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        btn.tag = 800;
        [cell.contentView addSubview:btn];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.row < self.selectImages.count){//图片预览
//        TZImagePickerController *imagePreview = [[TZImagePickerController alloc]initWithSelectedAssets:_selectAssets selectedPhotos:_selectImages index:indexPath.row];
//        imagePreview.maxImagesCount = self.selectImages.count;
//        [imagePreview setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets,BOOL stop){
//            //            [self.selectImages removeAllObjects];
//            //            self.selectImages = [photos mutableCopy];
//            //            [self.selectAssets removeAllObjects];
//            //            self.selectAssets = [assets mutableCopy];
//            //            [self.imageCollection reloadData];
//        }];
//        [self presentViewController:imagePreview animated:NO completion:nil];
//
//    }else{
//        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc]initWithMaxImagesCount:10.0 delegate:self];
//        imagePickerVc.allowPickingOriginalPhoto = NO;
//        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets,BOOL stop){
//            [self.selectImages removeAllObjects];
//            self.selectImages = [photos mutableCopy];
//
//            [self.selectAssets removeAllObjects];
//            self.selectAssets = [assets mutableCopy];
//            [self.imageCollection reloadData];
//        }];
//        [self presentViewController:imagePickerVc animated:YES completion:nil];
//    }
    
    if (self.imageDidSelectBlock) {
        self.imageDidSelectBlock(indexPath);
    }
}

#pragma mark - LxGridViewDataSource
/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _selectImages.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectImages.count && destinationIndexPath.item < _selectImages.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _selectImages[sourceIndexPath.item];
    [_selectImages removeObjectAtIndex:sourceIndexPath.item];
    [_selectImages insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectAssets[sourceIndexPath.item];
    [_selectAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectAssets insertObject:asset atIndex:destinationIndexPath.item];
    [_collectionView reloadData];
}

@end
