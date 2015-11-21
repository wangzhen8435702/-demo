//
//  ViewController.m
//  截取图片
//
//  Created by wangzhen on 15-1-20.
//  Copyright (c) 2015年 wangzhen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    UIView* _markView;
    CGPoint startPoint;
    IBOutlet UIImageView *_imageV;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIPanGestureRecognizer* panGes=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panPic:)];
    [self.view addGestureRecognizer:panGes];
    
    _markView=[[UIView alloc]initWithFrame:CGRectZero];
    [_markView setBackgroundColor:[UIColor darkGrayColor]];
    _markView.alpha=.5;
    [self.view addSubview:_markView];
    

}
-(void)panPic:(UIPanGestureRecognizer*)pan{
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            startPoint=[pan locationInView:self.view];
            _markView=[[UIView alloc]initWithFrame:CGRectZero];
            [_markView setBackgroundColor:[UIColor darkGrayColor]];
            _markView.alpha=.5;
            [self.view addSubview:_markView];
            
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point=[ pan translationInView:self.view];
            [_markView setFrame:CGRectMake(startPoint.x, startPoint.y, point.x, point.y)];
        }
            break;
            
        case UIGestureRecognizerStateEnded:{
            [_markView removeFromSuperview];
            [self refPic];
        
        }break;
        default:
            break;
    }

}
-(void)refPic{
//    获取上下文
    UIGraphicsBeginImageContext(self.view.frame.size);
    CGContextRef context=UIGraphicsGetCurrentContext();

    
    CGContextSaveGState(context);
    
//    设置裁剪区域
    UIRectClip(_markView.frame);
    
//    把ImageView 添加到山下文中
    
    [_imageV.layer renderInContext:context];
    
//    获取上下文的图层，转化为UIImage
    UIImage* newImage=UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRestoreGState(context);
    
//    结束
    UIGraphicsEndImageContext();
    
//    保存图片到相册
    UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
    


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
