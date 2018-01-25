//
//  CYTabBar.m
//  蚁巢
//
//  Created by 张春雨 on 2016/11/17.
//  Copyright © 2016年 张春雨. All rights reserved.
//

#import "CYTabBar.h"
#import "CYButton.h"

@interface CYTabBar ()<CAAnimationDelegate>
/** selctButton */
@property (weak , nonatomic) CYButton *selButton;
/** center button of place (kvc will setting) */
@property(assign , nonatomic) NSInteger centerPlace;
/** Whether center button to bulge (kvc will setting) */
@property(assign , nonatomic,getter=is_bulge) BOOL bulge;
/** tabBarController (kvc will setting) */
@property (weak , nonatomic) UITabBarController *controller;
/** border */
@property (nonatomic,weak) CAShapeLayer *border;

@property (nonatomic,strong) UIImageView *leftView;

@property (nonatomic,strong) UIImageView *middleView;

@property (nonatomic,strong) UIImageView *rightView;

@property (nonatomic,assign) BOOL isOpen;

@property (nonatomic,assign) BOOL isFinish;

@end

@implementation CYTabBar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.btnArr = [NSMutableArray array];
        if ([CYTabBarConfig shared].haveBorder) {
            self.border.fillColor = [CYTabBarConfig shared].bordergColor.CGColor;
        }
      //  self.backgroundColor = [CYTabBarConfig shared].backgroundColor;
        
        [[CYTabBarConfig shared]addObserver:self forKeyPath:@"textColor" options:NSKeyValueObservingOptionNew context:nil];
        [[CYTabBarConfig shared]addObserver:self forKeyPath:@"selectedTextColor" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

/**
 *  Set items
 */
- (void)setItems:(NSArray<UITabBarItem *> *)items{
    _items = items;
    for (int i=0; i<items.count; i++)
    {
        UITabBarItem *item = items[i];
        UIButton *btn = nil;
        if (-1 != self.centerPlace && i == self.centerPlace)
        {
            self.centerBtn = [CYCenterButton buttonWithType:UIButtonTypeCustom];
            self.centerBtn.adjustsImageWhenHighlighted = NO;
            self.centerBtn.bulge = self.is_bulge;
            btn = self.centerBtn;
            if (item.tag == -1)
            {
                [btn addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                [btn addTarget:self action:@selector(controlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        else
        {
            
            self.leftView = [[UIImageView alloc]init];
            self.leftView.clipsToBounds = YES;
            self.leftView.image = [UIImage imageNamed:@"icon-tp"];
            self.leftView.layer.cornerRadius = 22.5;
//            self.leftView.backgroundColor = [UIColor redColor];
            self.leftView.userInteractionEnabled = YES;
            self.leftView.tag = 0;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
            [self.leftView addGestureRecognizer:tap];
            [self addSubview:self.leftView];
            
            self.middleView = [[UIImageView alloc]init];
            self.middleView.clipsToBounds = YES;
            self.middleView.image = [UIImage imageNamed:@"icon-spp"];
            self.middleView.layer.cornerRadius = 22.5;
//            self.middleView.backgroundColor = [UIColor purpleColor];
            self.middleView.userInteractionEnabled = YES;
            self.middleView.tag = 1;
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
            [self.middleView addGestureRecognizer:tap2];
            [self addSubview:self.middleView];
            
            self.rightView = [[UIImageView alloc]init];
            self.rightView.clipsToBounds = YES;
            self.rightView.image = [UIImage imageNamed:@"icon-dn"];
            self.rightView.layer.cornerRadius = 22.5;
//            self.rightView.backgroundColor = [UIColor orangeColor];
            self.rightView.userInteractionEnabled = YES;
            self.rightView.tag = 2;
            
            UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
            [self.rightView addGestureRecognizer:tap3];
            [self addSubview:self.rightView];
            
            btn = [CYButton buttonWithType:UIButtonTypeCustom];
            //Add Observer
            [item addObserver:self forKeyPath:@"badgeValue"
                      options:NSKeyValueObservingOptionNew
                      context:(__bridge void * _Nullable)(btn)];
            [item addObserver:self forKeyPath:@"badgeColor"
                      options:NSKeyValueObservingOptionNew
                      context:(__bridge void * _Nullable)(btn)];
            
            [self.btnArr addObject:(CYButton *)btn];
            [btn addTarget:self action:@selector(controlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        //Set image
        [btn setImage:item.image forState:UIControlStateNormal];
        [btn setImage:item.selectedImage forState:UIControlStateSelected];
        btn.adjustsImageWhenHighlighted = NO;
        
        //Set title
        [btn setTitle:item.title forState:UIControlStateNormal];
        btn.tag = item.tag;
        [self addSubview:btn];
    }
}

- (void)clickAction:(UITapGestureRecognizer *)taper {
    
    if ([self.delegate respondsToSelector:@selector(tabbar:clickWithTag:)]) {
        [self.delegate tabbar:self clickWithTag:taper.view.tag];
    }
}

/**
 *  getter
 */
- (CAShapeLayer *)border{
    if (!_border) {
        CAShapeLayer *border = [CAShapeLayer layer];
        border.path = [UIBezierPath bezierPathWithRect:
                       CGRectMake(0,0,self.bounds.size.width,[CYTabBarConfig shared].borderHeight)].CGPath;
        [self.layer insertSublayer:border atIndex:0];
        _border = border;
    }
    return _border;
}


/**
 *  layout
 */
- (void)layoutSubviews{
    [super layoutSubviews];
    int count = (int)(self.centerBtn ? self.btnArr.count+1 : self.btnArr.count);
    int mid = count/2;
    CGRect rect = CGRectMake(0, 0, self.bounds.size.width/count,self.bounds.size.height);
    int j = 0;
    
    for (int i=0; i<count; i++)
    {
        if (i == mid && self.centerBtn!= nil)
        {
            CGFloat h = self.items[self.centerPlace].title ? 10.f : 0;
            self.centerBtn.frame = self.is_bulge
            ? CGRectMake(rect.origin.x,
                         -BULGEH-h ,
                         rect.size.width,
                         rect.size.height+h)
            : rect;
            
            self.centerBtn.frame = CGRectMake((SCREEN_WIDTH - 49)/2, -12, 49, self.bounds.size.height + 10);
            
            self.leftView.center = self.centerBtn.center;
            self.leftView.frame = CGRectMake(self.centerBtn.x, 0, 45, 45);
            
            self.middleView.center = self.centerBtn.center;
            self.middleView.frame = CGRectMake(self.centerBtn.x, 0, 45, 45);
            
            
            self.rightView.center = self.centerBtn.center;
            self.rightView.frame = CGRectMake(self.centerBtn.x, 0, 45, 45);
            
        }
        else
        {
            self.btnArr[j++].frame = rect;
        }
        rect.origin.x += rect.size.width;
    }
    _border.path = [UIBezierPath bezierPathWithRect:CGRectMake(0,0,
                                                                   self.bounds.size.width,
                                                                   [CYTabBarConfig shared].borderHeight)].CGPath;
}

/**
 *  Pass events for center button
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect rect = self.centerBtn.frame;
    if (CGRectContainsPoint(rect, point))
        return self.centerBtn;
    
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


/**
 *  Control button click
 */
- (void)controlBtnClick:(CYButton *)button{
    if ([self.delegate respondsToSelector:@selector(tabBar:willSelectIndex:)]) {
        if (![self.delegate tabBar:self willSelectIndex:button.tag]) {
            return;
        }
    }
    self.controller.selectedIndex = button.tag;
}

/**
 *  Updata select button UI (kvc will setting)
 */
- (void)setSelectButtoIndex:(NSUInteger)index{
    if (index == self.centerBtn.tag) {
         self.selButton = (CYButton *)self.centerBtn;
    }else{
        for (CYButton *loop in self.btnArr){
            if (loop.tag == index){
                self.selButton = loop;
                break;
            }
        }
    }
    
    if (!self.isFinish) {
        if (self.isOpen) {
            
            [UIView animateWithDuration:1 animations:^{
                self.centerBtn.imageView.transform = CGAffineTransformIdentity;
            }];
            
            
            //位置移动
            CGPoint FromePoint = CGPointMake(self.centerBtn.x, 0);
            FromePoint.x = FromePoint.x + 22.5;
            FromePoint.y = FromePoint.y + 22.5;
            
            CGPoint ToPoint = [self calcCircleCoordinateWithCenter:CGPointMake(self.centerBtn.x, 0) andWithAngle:90 andWithRadius:100];
            ToPoint.x = ToPoint.x + 22.5;
            ToPoint.y = ToPoint.y + 22.5;
            CAAnimationGroup *group1 = [self animationGroupMathWithPoint:FromePoint FromePoint:ToPoint startScale:1.0 endScale:0.5 startAplha:1.0 endAplha:0.0];
            //将上述两个动画编组
            [self.middleView.layer addAnimation:group1 forKey:@"middleView1"];
            
            CGPoint ToPoint2 = [self calcCircleCoordinateWithCenter:CGPointMake(self.centerBtn.x, 0) andWithAngle:45 andWithRadius:100];
            ToPoint2.x = ToPoint2.x + 22.5;
            ToPoint2.y = ToPoint2.y + 22.5;
            CAAnimationGroup *group2 = [self animationGroupMathWithPoint:FromePoint FromePoint:ToPoint2 startScale:1.0 endScale:0.5 startAplha:1.0 endAplha:0.0];
            [self.rightView.layer addAnimation:group2 forKey:@"rightView1"];
            
            
            
            CGPoint ToPoint3 = [self calcCircleCoordinateWithCenter:CGPointMake(self.centerBtn.x, 0) andWithAngle:135 andWithRadius:100];
            ToPoint3.x = ToPoint3.x + 22.5;
            ToPoint3.y = ToPoint3.y + 22.5;
            CAAnimationGroup *group3 = [self animationGroupMathWithPoint:FromePoint FromePoint:ToPoint3 startScale:1.0 endScale:0.5 startAplha:1.0 endAplha:0.0];
            [self.leftView.layer addAnimation:group3 forKey:@"leftView1"];
            
            self.middleView.frame = CGRectMake(self.centerBtn.x, 0, 45, 45);
            self.leftView.frame = CGRectMake(self.centerBtn.x, 0, 45, 45);
            self.rightView.frame = CGRectMake(self.centerBtn.x, 0, 45, 45);
            
             self.isOpen = !self.isOpen;
        }
        
       
    }
    
    
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectIndex:)]) {
        [self.delegate tabBar:self didSelectIndex:index];
    }
}

/**
 *  Switch select button to highlight
 */
- (void)setSelButton:(CYButton *)selButton{
    _selButton.selected = NO;
    _selButton = selButton;
    _selButton.selected = YES;
}


/**
 *  Center button click
 */
- (void)centerBtnClick:(CYCenterButton *)button{
    
    if (!self.isFinish) {
        if (!self.isOpen) {
            [UIView animateWithDuration:1 animations:^{
                button.imageView.transform = CGAffineTransformMakeRotation(M_PI);
            }];
            
            
            CGPoint point = [self calcCircleCoordinateWithCenter:CGPointMake(self.centerBtn.x, 0) andWithAngle:90 andWithRadius:100];
            point.x = point.x + 22.5;
            point.y = point.y + 22.5;
            CAAnimationGroup *group1 = [self animationGroupMathWithPoint:point FromePoint:self.middleView.layer.position startScale:0.5 endScale:1 startAplha:0.0 endAplha:1.0];
            //将上述两个动画编组
            [self.middleView.layer addAnimation:group1 forKey:@"middleView"];
            
            
            
            CGPoint point2 = [self calcCircleCoordinateWithCenter:CGPointMake(self.centerBtn.x, 0) andWithAngle:45 andWithRadius:100];
            point2.x = point2.x + 22.5;
            point2.y = point2.y + 22.5;
            
            CAAnimationGroup *group2 = [self animationGroupMathWithPoint:point2 FromePoint:self.rightView.layer.position startScale:0.5 endScale:1.0 startAplha:0.0 endAplha:1.0];
            //将上述两个动画编组
            [self.rightView.layer addAnimation:group2 forKey:@"rightView"];
            
            
            CGPoint point3 = [self calcCircleCoordinateWithCenter:CGPointMake(self.centerBtn.x, 0) andWithAngle:135 andWithRadius:100];
            
            point3.x = point3.x + 22.5;
            point3.y = point3.y + 22.5;
            
            CAAnimationGroup *group3 = [self animationGroupMathWithPoint:point3 FromePoint:self.leftView.layer.position startScale:0.5 endScale:1.0 startAplha:0.0 endAplha:1.0];
            //将上述两个动画编组
            [self.leftView.layer addAnimation:group3 forKey:@"leftView"];
            
            self.isOpen = !self.isOpen;
        }else {
            [UIView animateWithDuration:1 animations:^{
                button.imageView.transform = CGAffineTransformIdentity;
            }];
            
            
            
            //位置移动
            CGPoint FromePoint = CGPointMake(self.centerBtn.x, 0);
            FromePoint.x = FromePoint.x + 22.5;
            FromePoint.y = FromePoint.y + 22.5;
            
            CGPoint ToPoint = [self calcCircleCoordinateWithCenter:CGPointMake(self.centerBtn.x, 0) andWithAngle:90 andWithRadius:100];
            ToPoint.x = ToPoint.x + 22.5;
            ToPoint.y = ToPoint.y + 22.5;
            CAAnimationGroup *group1 = [self animationGroupMathWithPoint:FromePoint FromePoint:ToPoint startScale:1.0 endScale:0.5 startAplha:1.0 endAplha:0.0];
            //将上述两个动画编组
            [self.middleView.layer addAnimation:group1 forKey:@"middleView1"];
            
            CGPoint ToPoint2 = [self calcCircleCoordinateWithCenter:CGPointMake(self.centerBtn.x, 0) andWithAngle:45 andWithRadius:100];
            ToPoint2.x = ToPoint2.x + 22.5;
            ToPoint2.y = ToPoint2.y + 22.5;
            CAAnimationGroup *group2 = [self animationGroupMathWithPoint:FromePoint FromePoint:ToPoint2 startScale:1.0 endScale:0.5 startAplha:1.0 endAplha:0.0];
            [self.rightView.layer addAnimation:group2 forKey:@"rightView1"];
            
            
            
            CGPoint ToPoint3 = [self calcCircleCoordinateWithCenter:CGPointMake(self.centerBtn.x, 0) andWithAngle:135 andWithRadius:100];
            ToPoint3.x = ToPoint3.x + 22.5;
            ToPoint3.y = ToPoint3.y + 22.5;
            CAAnimationGroup *group3 = [self animationGroupMathWithPoint:FromePoint FromePoint:ToPoint3 startScale:1.0 endScale:0.5 startAplha:1.0 endAplha:0.0];
            [self.leftView.layer addAnimation:group3 forKey:@"leftView1"];
            
            self.middleView.frame = CGRectMake(self.centerBtn.x, 0, 45, 45);
            self.leftView.frame = CGRectMake(self.centerBtn.x, 0, 45, 45);
            self.rightView.frame = CGRectMake(self.centerBtn.x, 0, 45, 45);
            
            
            self.isOpen = !self.isOpen;
        }
    }
    self.isFinish = YES;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {

    self.isFinish = NO;

    if (flag) {
        if ([self.middleView.layer animationForKey:@"middleView"] == anim) {
           
            CGPoint FromePoint = [self calcCircleCoordinateWithCenter:CGPointMake(self.centerBtn.x, 0) andWithAngle:90 andWithRadius:100];
            self.middleView.frame = CGRectMake(FromePoint.x, FromePoint.y, 45, 45);
        }
        
        if ([self.leftView.layer animationForKey:@"leftView"] == anim) {
           
            CGPoint FromePoint = [self calcCircleCoordinateWithCenter:CGPointMake(self.centerBtn.x, 0) andWithAngle:135 andWithRadius:100];
            self.leftView.frame = CGRectMake(FromePoint.x, FromePoint.y, 45, 45);
        }
        
        if ([self.rightView.layer animationForKey:@"rightView"] == anim) {
           
            CGPoint FromePoint = [self calcCircleCoordinateWithCenter:CGPointMake(self.centerBtn.x, 0) andWithAngle:45 andWithRadius:100];
            self.rightView.frame = CGRectMake(FromePoint.x, FromePoint.y, 45, 45);
        }

    }
    
}

/**
 *  Observe the attribute value change
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"badgeValue"] || [keyPath isEqualToString:@"badgeColor"]){
        CYButton *btn = (__bridge CYButton *)(context);
        btn.item = (UITabBarItem*)object;
    }
    else if ([object isEqual:[CYTabBarConfig shared]]){
        if([keyPath isEqualToString:@"textColor"] ||[keyPath isEqualToString:@"selectedTextColor"]){
            UIColor *color = change[@"new"];
            UIControlState state = [keyPath isEqualToString:@"textColor"]? UIControlStateNormal: UIControlStateSelected;
            for (UIButton *loop in self.btnArr){
                [loop setTitleColor:color forState:state];
            }
        }
    }
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


/**
 *  Remove observer
 */
- (void)dealloc{
    for (int i=0; i<self.btnArr.count; i++) {
        int index = ({
            int n = 0;
            if (-1 != _centerPlace)
                n = _centerPlace > i ? 0 : 1;
            i+n;});
        [self.items[index] removeObserver:self
                               forKeyPath:@"badgeValue"
                                  context:(__bridge void * _Nullable)(self.btnArr[i])];
        [self.items[index] removeObserver:self
                               forKeyPath:@"badgeColor"
                                  context:(__bridge void * _Nullable)(self.btnArr[i])];
    }
    [[CYTabBarConfig shared]removeObserver:self forKeyPath:@"textColor" context:nil];
    [[CYTabBarConfig shared]removeObserver:self forKeyPath:@"selectedTextColor" context:nil];
}

-(CGPoint) calcCircleCoordinateWithCenter:(CGPoint) center  andWithAngle : (CGFloat) angle andWithRadius: (CGFloat) radius{
    CGFloat x2 = radius*cosf(angle*M_PI/180);
    CGFloat y2 = radius*sinf(angle*M_PI/180);
    return CGPointMake(center.x+x2, center.y-y2);
}

@end
