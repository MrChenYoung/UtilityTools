//
//  ImageCompressCtr.m
//  Demo
//
//  Created by MrChen on 2018/3/21.
//  Copyright © 2018年 MrChen. All rights reserved.
//

#import "ImageCompressCtr.h"
#import "UIView+Category.h"
#import "UIImage+Category.h"
#import "AppConstMacro.h"
#import "HYImagePickerManager.h"

@interface ImageCompressCtr ()<UIActionSheetDelegate>

// 选择图片按钮
@property (nonatomic, weak) UIButton *chooseImgBtn;

@end

@implementation ImageCompressCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图片压缩";
    
    // create subviews
    [self createSubviews];
    
    // 照片选择完成
    [HYImagePickerManager shareManager].getImageName = YES;
    [HYImagePickerManager shareManager].imagePickComplete = ^(UIImage *originImage, UIImage *editedImage, NSString *imageName) {
        [self updateImageData:originImage imageName:imageName];
    };
}

// create subviews
- (void)createSubviews
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, self.view.viewWidth - 20, 40)];
    btn.viewCenterY = self.view.viewCenterY;
    btn.backgroundColor  = RgbColor(0, 150, 255);
    [btn addTarget:self action:@selector(choosePic) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.textColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:@"选择照片" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    self.chooseImgBtn = btn;
    
    UIView *originPicView = [self createImageInfoViews];
    originPicView.tag = 3000;
    originPicView.viewY = 20 + 64;
    [self.view addSubview:originPicView];
    
    UIView *compressPicView = [self createImageInfoViews];
    compressPicView.tag = 4000;
    compressPicView.viewY = originPicView.viewMaxY + 10;
    [self.view addSubview:compressPicView];
    
    self.chooseImgBtn.viewY = compressPicView.viewMaxY + 10;
}

// 选择照片
- (void)choosePic
{
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    [action showInView:self.view];
}

// createSubviews
- (UIView *)createImageInfoViews
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.viewWidth, 200)];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, bgView.viewHeight, bgView.viewHeight)];
    [bgView addSubview:imageV];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imageV.viewMaxX + 10, 10, bgView.viewWidth - imageV.viewMaxX - 10, bgView.viewHeight - 20)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    label.numberOfLines = 0;
    [bgView addSubview:label];
    
    return bgView;
}

// 设置照片
- (void)updateImageData:(UIImage *)originImage imageName:(NSString *)imageName
{
    UIView *originView = [self.view viewWithTag:3000];
    [self setImagesWithBgView:originView image:originImage imageName:imageName];
    
    UIView *compressView = [self.view viewWithTag:4000];
    UIImage *compressImage = [originImage imageCompressWithLengthLimit:5024];
    [self setImagesWithBgView:compressView image:compressImage imageName:imageName];
}

- (void)setImagesWithBgView:(UIView *)bgView image:(UIImage *)image imageName:(NSString *)imageName
{
    CGFloat spaceSize = image.spaceSize/1024.0 > 1 ? image.spaceSize/1024.0 : image.spaceSize;
    NSString *unit = image.spaceSize/1024.0 > 1 ? @"Mb" : @"kb";
    
    for (UIView *subView in bgView.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [(UIImageView *)subView setImage:image];
        }else if ([subView isKindOfClass:[UILabel class]]) {
            NSString *preTex = bgView.tag == 3000 ? @"压缩前:" : @"压缩后:";
            [(UILabel *)subView setText:[NSString stringWithFormat:@"%@\n图片尺寸\n%@\n图片占用存储\n %.f%@",preTex,NSStringFromCGSize(image.size),spaceSize,unit]];
        }
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    HYImagePickerManager *imagePick = [HYImagePickerManager shareManager];
    
    switch (buttonIndex) {
        case 0:
            // 相机
            imagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case 1:
            // 相册
            imagePick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
            
        default:
            break;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imagePick showAnimated:YES];
    });
}

@end
