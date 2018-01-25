//
//  GBTabBar.m
//  Maintenance
//
//  Created by mac on 2017/8/6.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMTabBar.h"
#import <UIKit/UIKit.h>
#import "UIView+Extension.h"
#import "KMMArcView.h"

@interface KMMTabBar()<CAAnimationDelegate,UITabBarDelegate>

@property (nonatomic,strong) UIButton *addButton;//自定义圆形图片按钮

@property (nonatomic,strong) UILabel *titleLabel;//中间自定义文本
@property (nonatomic,strong) KMMArcView *view; //半圆View

@property(assign,nonatomic)int index;//UITabBar子view的索引

@property (nonatomic,strong) UIImageView *leftView;

@property (nonatomic,strong) UIImageView *middleView;

@property (nonatomic,strong) UIImageView *rightView;

@property (nonatomic,assign) BOOL isOpen;

@property (nonatomic,assign) BOOL isFinish;

@property (nonatomic,assign) NSInteger pointX;

@property (nonatomic,assign) NSInteger pointY;


@end


@implementation KMMTabBar

- (void)drawRect:(CGRect)rect {
    
    
    //中间的按钮宽度是UItabBar的高度，其他按钮的宽度就是，(self.width-self.height)/4.0
    
    CGFloat buttonW = (self.width-self.height)/4.0;
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, RGB(200, 200, 200).CGColor);
    
    
    CGContextSetLineWidth(context, SINGLE_LINE_WIDTH);
    CGContextBeginPath(context);
    CGFloat lineMargin =0;
    
    //1PX线，像素偏移
    CGFloat pixelAdjustOffset = 0;
    if (((int)(1 * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
        pixelAdjustOffset = SINGLE_LINE_ADJUST_OFFSET;
    }
    
    
    CGFloat yPos = lineMargin - pixelAdjustOffset;
    
    //第一段线
    CGContextMoveToPoint(context, 0, yPos);
    CGContextAddLineToPoint(context, buttonW*2+SINGLE_LINE_WIDTH*2, yPos);
    CGContextStrokePath(context);
    
    //第二段线
    
    CGContextMoveToPoint(context, buttonW*2+self.height-SINGLE_LINE_WIDTH*2, yPos);
    CGContextAddLineToPoint(context, self.bounds.size.width, yPos);
    
    CGContextSetStrokeColorWithColor(context, RGB(200, 200, 200).CGColor);
    CGContextStrokePath(context);
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if (SCREEN_HEIGHT == 812) {
            self.pointX = 45;
        }else {
            self.pointX = 22.5;
        }
        
        self.backgroundColor=[UIColor whiteColor];
        self.clipsToBounds=NO;//不裁剪子控件
        self.index=0;//初始化索引
        //        self.delegate = self;
        
    }
    return self;
}

- (void)changeState {
    
    if (!self.isFinish) {
        if (self.isOpen) {
            
            [UIView animateWithDuration:1 animations:^{
                self.addButton.imageView.transform = CGAffineTransformIdentity;
            }];
            
            
            //位置移动
            CGPoint FromePoint = CGPointMake(self.addButton.x, 0);
            FromePoint.x = FromePoint.x + self.pointX;
            FromePoint.y = FromePoint.y + 22.5;
            
            CGPoint ToPoint = [self calcCircleCoordinateWithCenter:CGPointMake(self.addButton.x, 0) andWithAngle:90 andWithRadius:100];
            ToPoint.x = ToPoint.x + self.pointX;
            ToPoint.y = ToPoint.y + 22.5;
            CAAnimationGroup *group1 = [self animationGroupMathWithPoint:FromePoint FromePoint:ToPoint startScale:1.0 endScale:0.5 startAplha:1.0 endAplha:0.0];
            //将上述两个动画编组
            [self.middleView.layer addAnimation:group1 forKey:@"middleView1"];
            
            CGPoint ToPoint2 = [self calcCircleCoordinateWithCenter:CGPointMake(self.addButton.x, 0) andWithAngle:45 andWithRadius:100];
            ToPoint2.x = ToPoint2.x + self.pointX;
            ToPoint2.y = ToPoint2.y + 22.5;
            CAAnimationGroup *group2 = [self animationGroupMathWithPoint:FromePoint FromePoint:ToPoint2 startScale:1.0 endScale:0.5 startAplha:1.0 endAplha:0.0];
            [self.rightView.layer addAnimation:group2 forKey:@"rightView1"];
            
            
            
            CGPoint ToPoint3 = [self calcCircleCoordinateWithCenter:CGPointMake(self.addButton.x, 0) andWithAngle:135 andWithRadius:100];
            ToPoint3.x = ToPoint3.x + self.pointX;
            ToPoint3.y = ToPoint3.y + 22.5;
            CAAnimationGroup *group3 = [self animationGroupMathWithPoint:FromePoint FromePoint:ToPoint3 startScale:1.0 endScale:0.5 startAplha:1.0 endAplha:0.0];
            [self.leftView.layer addAnimation:group3 forKey:@"leftView1"];
            
             CGRect ViewRect = CGRectMake((SCREEN_WIDTH/3)+(SCREEN_WIDTH/3)/2-22.5, -10, 45, 45);
            
//            self.middleView.frame = CGRectMake(self.addButton.x, 0, 45, 45);
//            self.leftView.frame = CGRectMake(self.addButton.x, 0, 45, 45);
//            self.rightView.frame = CGRectMake(self.addButton.x, 0, 45, 45);
            self.middleView.frame = ViewRect;
            self.leftView.frame = ViewRect;
            self.rightView.frame = ViewRect;
            
            self.isOpen = !self.isOpen;
        }
        
        
    }
}

-(UIButton *)addButton{
    
    
    if(!_addButton){
        
        UIButton *button=[[UIButton alloc] init];
        self.addButton = button;
        self.addButton.adjustsImageWhenHighlighted = NO;
        [self.addButton setBackgroundImage:[UIImage imageNamed:@"tab_摄影机图标背景"] forState:UIControlStateNormal];
        //  [self.addButton setImage:[UIImage imageNamed:@"tab_open"] forState:UIControlStateNormal];
        [self.addButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
        [self.addButton setImage:[UIImage imageNamed:@"icon-fb"] forState:UIControlStateNormal];
        
    }
    
    
    return _addButton;
}

//重写layoutSubviews，重新排布子View

-(void)layoutSubviews{
    
    self.index=0;
    [super layoutSubviews];
    
    // NSLog(@"%zd",self.subviews.count);
    
    CGFloat buttonW = (SCREEN_WIDTH - 45) * 0.5 ;//SCREEN_WIDTH * 0.2
    
    for (int i = 0; i < self.subviews.count; i ++) {
        UIView *view = self.subviews[i];
        
        
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
            CGRect rect=view.frame;
            rect.size.width=buttonW;
            
            rect.size.height=self.frame.size.height;
            rect.origin.y=0;
            
            if (SCREEN_HEIGHT == 812) {
                rect.size.height=49;
            }
            
            view.frame =rect;
            
            if (self.index == 0) {
                view.x = 0;
            }
            
            if (self.index == 2) {
                view.x = buttonW + 45;
            }
            
            //            if(self.index<2){
            //                view.x=self.index*buttonW;
            //
            //            }else if(self.index>=2){
            //
            //                view.x=self.index*buttonW +buttonW;
            //
            //            }
            self.index++;
            
        }
    }
    
    
    [self addSubview:self.leftView];
    
    
    [self addSubview:self.middleView];
    
   
    [self addSubview:self.rightView];
    
    NSInteger pointX = 0;
    if (SCREEN_HEIGHT == 812) {
        pointX = 22.5;
    }
    
    CGRect ViewRect = CGRectMake((SCREEN_WIDTH/3)+(SCREEN_WIDTH/3)/2-22.5, -10, 45, 45);
    
    // self.leftView.center = self.addButton.center;
    self.leftView.frame = ViewRect;
    
    //    self.middleView.center = self.addButton.center;
    self.middleView.frame = ViewRect;
    
    
    //    self.rightView.center = self.addButton.center;
    self.rightView.frame = ViewRect;
    
    
    
    //懒加载 等所有控件排布后，然后 设置自定义的view，这里注意顺序，先设置背景的半圆view的Frame，然后设置按钮的Frame，否则半圆view会挡住按钮。
    self.view.x=2 * (self.width-self.height)/4.0;
    self.addButton.width = self.height;
    self.addButton.height = 59;
    self.addButton.y = -10;
    self.addButton.x = 2 * (self.width-self.height)/4.0;
    [self addSubview:self.addButton];
    
}

- (UIImageView *)leftView {
    
    if (!_leftView) {
        _leftView = [[UIImageView alloc]init];
        _leftView.clipsToBounds = YES;
        _leftView.image = [UIImage imageNamed:@"icon-tp"];
        _leftView.layer.cornerRadius = 22.5;
        //            self.leftView.backgroundColor = [UIColor redColor];
        _leftView.userInteractionEnabled = YES;
        _leftView.tag = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
        [_leftView addGestureRecognizer:tap];
    }
    
    return _leftView;
    
}

- (UIImageView *)middleView {
    
    if (!_middleView) {
        _middleView = [[UIImageView alloc]init];
        _middleView.clipsToBounds = YES;
        _middleView.image = [UIImage imageNamed:@"icon-spp"];
        _middleView.layer.cornerRadius = 22.5;
        //            self.middleView.backgroundColor = [UIColor purpleColor];
        _middleView.userInteractionEnabled = YES;
        _middleView.tag = 1;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
        [_middleView addGestureRecognizer:tap2];
    }
    return _middleView;
}

- (UIImageView *)rightView {
    
    if (!_rightView) {
        _rightView = [[UIImageView alloc]init];
        _rightView.clipsToBounds = YES;
        _rightView.image = [UIImage imageNamed:@"icon-dn"];
        _rightView.layer.cornerRadius = 22.5;
        //            self.rightView.backgroundColor = [UIColor orangeColor];
        _rightView.userInteractionEnabled = YES;
        _rightView.tag = 2;
        
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
        [_rightView addGestureRecognizer:tap3];
    }
    return _rightView;
}

- (void)clickAction:(UITapGestureRecognizer *)taper {
    
    if ([self.tabbarDelegate respondsToSelector:@selector(tabbar:clickWithTag:)]) {
        [self.tabbarDelegate tabbar:self clickWithTag:taper.view.tag];
    }
    
}



-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    if(frame.origin.y>=[UIScreen mainScreen].bounds.size.height){
        
        [self.view setHidden:YES];
        
        [self.addButton setHidden:YES];
    }else{
        [self.view setHidden:NO];
        [self.addButton setHidden:NO];
        
    }
}

- (void)addClick
{
    
    if (!self.isFinish) {
        if (!self.isOpen) {
            [UIView animateWithDuration:1 animations:^{
                self.addButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
            }];
            
            
            CGPoint point = [self calcCircleCoordinateWithCenter:CGPointMake(self.addButton.x, 0) andWithAngle:90 andWithRadius:100];
            point.x = point.x + self.pointX;
            point.y = point.y + 22.5;
            CAAnimationGroup *group1 = [self animationGroupMathWithPoint:point FromePoint:self.middleView.layer.position startScale:0.5 endScale:1 startAplha:0.0 endAplha:1.0];
            //将上述两个动画编组
            [self.middleView.layer addAnimation:group1 forKey:@"middleView"];
            
            
            
            CGPoint point2 = [self calcCircleCoordinateWithCenter:CGPointMake(self.addButton.x, 0) andWithAngle:45 andWithRadius:100];
            point2.x = point2.x + self.pointX;
            point2.y = point2.y + 22.5;
            
            CAAnimationGroup *group2 = [self animationGroupMathWithPoint:point2 FromePoint:self.rightView.layer.position startScale:0.5 endScale:1.0 startAplha:0.0 endAplha:1.0];
            //将上述两个动画编组
            [self.rightView.layer addAnimation:group2 forKey:@"rightView"];
            
            
            CGPoint point3 = [self calcCircleCoordinateWithCenter:CGPointMake(self.addButton.x, 0) andWithAngle:135 andWithRadius:100];
            
            point3.x = point3.x + self.pointX;
            point3.y = point3.y + 22.5;
            
            CAAnimationGroup *group3 = [self animationGroupMathWithPoint:point3 FromePoint:self.leftView.layer.position startScale:0.5 endScale:1.0 startAplha:0.0 endAplha:1.0];
            //将上述两个动画编组
            [self.leftView.layer addAnimation:group3 forKey:@"leftView"];
            
            self.isOpen = !self.isOpen;
        }else {
            [UIView animateWithDuration:1 animations:^{
                self.addButton.imageView.transform = CGAffineTransformIdentity;
            }];
            
            
            
            //位置移动
            CGPoint FromePoint = CGPointMake(self.addButton.x, 0);
            FromePoint.x = FromePoint.x + self.pointX;
            FromePoint.y = FromePoint.y + 22.5;
            
            CGPoint ToPoint = [self calcCircleCoordinateWithCenter:CGPointMake(self.addButton.x, 0) andWithAngle:90 andWithRadius:100];
            ToPoint.x = ToPoint.x + self.pointX;
            ToPoint.y = ToPoint.y + 22.5;
            CAAnimationGroup *group1 = [self animationGroupMathWithPoint:FromePoint FromePoint:ToPoint startScale:1.0 endScale:0.5 startAplha:1.0 endAplha:0.0];
            //将上述两个动画编组
            [self.middleView.layer addAnimation:group1 forKey:@"middleView1"];
            
            CGPoint ToPoint2 = [self calcCircleCoordinateWithCenter:CGPointMake(self.addButton.x, 0) andWithAngle:45 andWithRadius:100];
            ToPoint2.x = ToPoint2.x + self.pointX;
            ToPoint2.y = ToPoint2.y + 22.5;
            CAAnimationGroup *group2 = [self animationGroupMathWithPoint:FromePoint FromePoint:ToPoint2 startScale:1.0 endScale:0.5 startAplha:1.0 endAplha:0.0];
            [self.rightView.layer addAnimation:group2 forKey:@"rightView1"];
            
            
            
            CGPoint ToPoint3 = [self calcCircleCoordinateWithCenter:CGPointMake(self.addButton.x, 0) andWithAngle:135 andWithRadius:100];
            ToPoint3.x = ToPoint3.x + self.pointX;
            ToPoint3.y = ToPoint3.y + 22.5;
            CAAnimationGroup *group3 = [self animationGroupMathWithPoint:FromePoint FromePoint:ToPoint3 startScale:1.0 endScale:0.5 startAplha:1.0 endAplha:0.0];
            [self.leftView.layer addAnimation:group3 forKey:@"leftView1"];
            
            CGRect ViewRect = CGRectMake((SCREEN_WIDTH/3)+(SCREEN_WIDTH/3)/2-22.5, -10, 45, 45);
//            self.middleView.frame = CGRectMake(self.addButton.x, 0, 45, 45);
//            self.leftView.frame = CGRectMake(self.addButton.x, 0, 45, 45);
//            self.rightView.frame = CGRectMake(self.addButton.x, 0, 45, 45);
            self.middleView.frame = ViewRect;
            self.leftView.frame = ViewRect;
            self.rightView.frame = ViewRect;
            
            
            self.isOpen = !self.isOpen;
        }
    }
    self.isFinish = YES;
   
}


-(CGPoint) calcCircleCoordinateWithCenter:(CGPoint) center  andWithAngle : (CGFloat) angle andWithRadius: (CGFloat) radius{
    CGFloat x2 = radius*cosf(angle*M_PI/180);
    CGFloat y2 = radius*sinf(angle*M_PI/180);
    return CGPointMake(center.x+x2, center.y-y2);
}

- (CAAnimationGroup *)animationGroupMathWithPoint:(CGPoint)point FromePoint:(CGPoint)fromPoint startScale:(CGFloat)startScale endScale:(CGFloat)endScale startAplha:(CGFloat)startAplha endAplha:(CGFloat)endAplha{
    
    
    //透明度变化
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    // opacityAnimation.duration = 0.8;
    opacityAnimation.fromValue = [NSNumber numberWithFloat:startAplha];
    opacityAnimation.toValue = [NSNumber numberWithFloat:endAplha];
    //位置移动
    
    CABasicAnimation *animation  = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue =  [NSValue valueWithCGPoint:fromPoint];
    animation.toValue = [NSValue valueWithCGPoint:point];
    //旋转动画
    CABasicAnimation* rotationAnimation =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//"z"还可以是“x”“y”，表示沿z轴旋转
    rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
    // rotationAnimation.duration = 0.0;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; //缓入缓出
    
    
    //缩放动画
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:startScale];
    scaleAnimation.toValue = [NSNumber numberWithFloat:endScale];
    //  scaleAnimation.duration = 2.0f;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 0.8f;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    animationGroup.delegate = self;
    //   animationGroup.autoreverses = NO;   //是否重播，原动画的倒播
    animationGroup.repeatCount = 0;//HUGE_VALF;     //HUGE_VALF,源自math.h
    [animationGroup setAnimations:[NSArray arrayWithObjects:animation,rotationAnimation, scaleAnimation, opacityAnimation, nil]];
    
    return animationGroup;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect rect = self.addButton.frame;
    if (CGRectContainsPoint(rect, point))
        return self.addButton;
    
    CGRect rect1 = self.leftView.frame;
    if (CGRectContainsPoint(rect1, point))
        return self.leftView;
    
    CGRect rect2 = self.middleView.frame;
    if (CGRectContainsPoint(rect2, point))
        return self.middleView;
    
    CGRect rect3 = self.rightView.frame;
    if (CGRectContainsPoint(rect3, point))
        return self.rightView;
    
    return [super hitTest:point withEvent:event];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    self.isFinish = NO;
    
    if (flag) {
        
        NSInteger pointX = 0;
        if (SCREEN_HEIGHT == 812) {
            pointX = 22.5;
        }
        
        if ([self.middleView.layer animationForKey:@"middleView"] == anim) {
            
            CGPoint FromePoint = [self calcCircleCoordinateWithCenter:CGPointMake(self.addButton.x, 0) andWithAngle:90 andWithRadius:100];
            self.middleView.frame = CGRectMake(FromePoint.x + pointX, FromePoint.y, 45, 45);
        }
        
        if ([self.leftView.layer animationForKey:@"leftView"] == anim) {
            
            CGPoint FromePoint = [self calcCircleCoordinateWithCenter:CGPointMake(self.addButton.x, 0) andWithAngle:135 andWithRadius:100];
            self.leftView.frame = CGRectMake(FromePoint.x + pointX, FromePoint.y, 45, 45);
        }
        
        if ([self.rightView.layer animationForKey:@"rightView"] == anim) {
            
            CGPoint FromePoint = [self calcCircleCoordinateWithCenter:CGPointMake(self.addButton.x, 0) andWithAngle:45 andWithRadius:100];
            self.rightView.frame = CGRectMake(FromePoint.x + pointX, FromePoint.y, 45, 45);
        }
        
    }
    
}

-(UIView *)view{
    
    
    if(!_view){
        
        CGFloat buttonW = (self.width-self.height)/4.0;
        
        
        KMMArcView *view = [[KMMArcView alloc]initWithFrame:CGRectMake(buttonW*2, -self.height*0.5f, self.height, self.height)];
        
        
        view.backgroundColor=[UIColor whiteColor];
        
        view.layer.masksToBounds=YES;
        view.layer.cornerRadius=self.height*0.5f;
        
        
        _view=view;
        
        [self addSubview:view];
        
        
        
    }
    
    
    return _view;
    
}

-(UILabel *)titleLabel{
    
    if(!_titleLabel){
        
        
        UILabel *titleLabel=[[UILabel alloc] init];
        
        titleLabel.text=@"开门";
        titleLabel.textColor=[UIColor blackColor];
        
        titleLabel.font=[UIFont systemFontOfSize:12.0];
        [titleLabel sizeToFit];
        
        _titleLabel = titleLabel;
        
        [self addSubview:titleLabel];
    }
    
    
    return _titleLabel;
}

@end
