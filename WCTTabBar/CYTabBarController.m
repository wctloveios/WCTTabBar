//
//  CYTabBarController.m
//  蚁巢
//
//  Created by 张春雨 on 2016/11/17.
//  Copyright © 2016年 张春雨. All rights reserved.
//

#import "CYTabBarController.h"

//#import "TZImagePickerController.h"
//#import "TZImageManager.h"

//#import "KMMEditorViewController.h"
//#import "KMMWebUploadController.h"
//#import "KMMVideoPickerController.h"

//#import "JQFMDB.h"
//#import "UploadTable.h"



@interface CYTabBarController ()<CYTabBarDelegate>
/** center button of place ( -1:none center button >=0:contain center button) */
@property(assign , nonatomic) NSInteger centerPlace;
/** Whether center button to bulge */
@property(assign , nonatomic,getter=is_bulge) BOOL bulge;
/** items */
@property (nonatomic,strong) NSMutableArray <UITabBarItem *>*items;

@property (nonatomic,strong) NSMutableArray *picDataSource;

@property (nonatomic,strong) NSMutableArray *picAsset;

@property (nonatomic,strong) NSMutableArray *tempPicArray;

@property (nonatomic,strong) NSMutableArray *dynamicImgArray;

@end

@implementation CYTabBarController{int tabBarItemTag;BOOL firstInit;}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeControllerPage) name:@"STARTUPLOAD" object:nil];
    
    self.centerPlace = -1;
    
    _picDataSource = [NSMutableArray array];
    //    _picAsset = [NSMutableArray array];
    _tempPicArray = [NSMutableArray array];
    _dynamicImgArray = [NSMutableArray array];
    
    //Observer Device Orientation
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OrientationDidChange) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (void)changeControllerPage {

    if (self.selectedIndex !=0) {
        self.selectedIndex = 0;
    }
}

/**
 *  Initialize selected
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!firstInit)
    {
        firstInit = YES;
        NSInteger index = [CYTabBarConfig shared].selectIndex;
        if (index < 0) {
            self.selectedIndex = (self.centerPlace != -1 && self.items[self.centerPlace].tag != -1)
            ? self.centerPlace
            : 0;
        }else{
            self.selectedIndex = index;
        }
    }
}

/**
 *  Add other button for child’s controller
 */
- (void)addChildController:(id)Controller title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName{
    UIViewController *vc = [self findViewControllerWithobject:Controller];
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    
    vc.tabBarItem.tag = tabBarItemTag++;
    [self.items addObject:vc.tabBarItem];
    [self addChildViewController:Controller];
}

/**
 *  Add center button
 */
- (void)addCenterController:(id)Controller bulge:(BOOL)bulge title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName{
    _bulge = bulge;
    if (Controller) {
        [self addChildController:Controller title:title imageName:imageName selectedImageName:selectedImageName];
        self.centerPlace = tabBarItemTag-1;
    }else{
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:title
                                                          image:[UIImage imageNamed:imageName]
                                                  selectedImage:[UIImage imageNamed:selectedImageName]];
        item.tag = -1;
        [self.items addObject:item];
        self.centerPlace = tabBarItemTag;
    }
}

/**
 *  Device Orientation func
 */
- (void)OrientationDidChange{
    self.tabbar.frame = [self tabbarFrame];
}

- (CGRect)tabbarFrame{
    return CGRectMake(0, [UIScreen mainScreen].bounds.size.height-49,
                      [UIScreen mainScreen].bounds.size.width, 49);
}

/**
 *  getter
 */
- (CYTabBar *)tabbar{
    if (self.items.count && !_tabbar) {
        _tabbar = [[CYTabBar alloc]initWithFrame:[self tabbarFrame]];
        _tabbar.delegate = self;
        _tabbar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tab-_白色透明背景渐变"]];
        [_tabbar setValue:self forKey:@"controller"];
        [_tabbar setValue:[NSNumber numberWithBool:self.bulge] forKey:@"bulge"];
        [_tabbar setValue:[NSNumber numberWithInteger:self.centerPlace] forKey:@"centerPlace"];
        _tabbar.items = self.items;
        
        //remove tabBar
        for (UIView *loop in self.tabBar.subviews) {
            [loop removeFromSuperview];
        }
        self.tabBar.hidden = YES;
        [self.tabBar removeFromSuperview];
    }
    return _tabbar;
}
- (NSMutableArray <UITabBarItem *>*)items{
    if(!_items){
        _items = [NSMutableArray array];
    }
    return _items;
}

- (void)InitializeTabbar{
    [_tabbar setValue:[NSNumber numberWithBool:self.bulge] forKey:@"bulge"];
    [_tabbar setValue:[NSNumber numberWithInteger:self.centerPlace] forKey:@"centerPlace"];
    _tabbar.items = self.items;
}


/**
 *  Update current select controller
 */
- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    if (selectedIndex >= self.viewControllers.count){
        @throw [NSException exceptionWithName:@"selectedTabbarError"
                                       reason:@"No controller can be used,Because of index beyond the viewControllers,Please check the configuration of tabbar."
                                     userInfo:nil];
    }
    [super setSelectedIndex:selectedIndex];
    UIViewController *viewController = [self findViewControllerWithobject:self.viewControllers[selectedIndex]];
    [self.tabbar removeFromSuperview];
    [viewController.view addSubview:self.tabbar];
    viewController.extendedLayoutIncludesOpaqueBars = YES;
    [self.tabbar setValue:[NSNumber numberWithInteger:selectedIndex] forKeyPath:@"selectButtoIndex"];
}



/**
 *  Catch viewController
 */
- (UIViewController *)findViewControllerWithobject:(id)object{
    while ([object isKindOfClass:[UITabBarController class]] || [object isKindOfClass:[UINavigationController class]]){
        object = ((UITabBarController *)object).viewControllers.firstObject;
    }
    return object;
}

/**
 *  hidden tabbar and do animated
 */
- (void)setCYTabBarHidden:(BOOL)hidden animated:(BOOL)animated{
    NSTimeInterval time = animated ? 0.3 : 0.0;
    if (hidden) {
        self.tabbar.hidden = NO;
        [UIView animateWithDuration:time animations:^{
            self.tabbar.transform = CGAffineTransformIdentity;
        }];
    }else{
        CGFloat h = self.tabbar.frame.size.height;
        [UIView animateWithDuration:time-0.1 animations:^{
            self.tabbar.transform = CGAffineTransformMakeTranslation(0,h);
        }completion:^(BOOL finished) {
            self.tabbar.hidden = YES;
        }];
    }
}

- (void)setCYTabBarHidden:(BOOL)hidden{

//    if (hidden) {
//        self.tabbar.hidden = YES;
//        
//    }else{
//        self.tabBar.hidden = YES;
//    }
  //  self.tabBar.hidden = hidden;
    if (hidden) {
        self.tabbar.hidden = NO;
       
            self.tabbar.frame = CGRectMake(0, SCREEN_HEIGHT +50, SCREEN_WIDTH, 49);
        
    }else{
        self.tabbar.frame = CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49);
    }
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

#pragma mark - CYTabBarDelegate
- (void)tabbar:(CYTabBar *)tabbar clickWithTag:(NSInteger)tag {
    
    switch (tag) {
        case 0: {
//          [self getPhotosFromLocal];
        }
            break;
        case 1: {
            
//            NSArray *arr =  [[JQFMDB shareDatabase] jq_lookupTable:@"upLoadTable" dicOrModel:[UploadTable new] whereFormat:@""];
//            if (arr.count >= 5) {
//                [self showText:@"最多只能上传五个视频课程"];
//                return;
//            }
////            NSLog(@"%@",arr);
//
//
//            KMMVideoPickerController *VideoPickerVC = [[KMMVideoPickerController alloc]init];
//            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:VideoPickerVC];
//          //  [self.navigationController pushViewController:VideoPickerVC animated:YES];
//            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 2: {
//            KMMWebUploadController *webViewVC = [[KMMWebUploadController alloc]init];
//            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:webViewVC];
//            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
    
}


/*
#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = [[info objectForKey:UIImagePickerControllerEditedImage] copy];
    
    [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error) {
        if (!error) {
            [_tempPicArray removeAllObjects];
            [_tempPicArray addObject:image];
            [self requestUpdateImages];
        }
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 从本地相册获取图片
- (void)getPhotosFromLocal
{
    WEAK_SELF(self);
    TZImagePickerController *tzImagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:(9) delegate:self];
    tzImagePickerVC.allowPickingVideo = NO;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [tzImagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        STRONG_SELF(self);
        //        [_picAsset removeAllObjects];
        //        [_picDataSource removeAllObjects];
        //        [_picAsset addObjectsFromArray:assets];
        [_tempPicArray removeAllObjects];
        if (photos.count > 0) {
            for (UIImage *image in photos) {
                //对图片进行压缩处理
                if (!isSelectOriginalPhoto) {
                    UIImage *imageCompress = [Tools compressImageWithImage:image ScalePercent:0.05];
                    [_tempPicArray addObject:imageCompress];
                } else {
                    [_tempPicArray addObject:image];
                }
            }
            
            [self requestUpdateImages];
        }
        
    }];
    
    [self presentViewController:tzImagePickerVC animated:YES completion:nil];
    
}

#pragma mark - 从相机中获取图片
- (void)getPhotosFromCamera
{
    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];//相机权限
    
    switch (AVstatus) {
        case AVAuthorizationStatusAuthorized:
            DDLogDebug(@"Authorized");
            break;
        case AVAuthorizationStatusDenied:
        {
            DDLogDebug(@"Denied");
            //提示开启相机
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"相机权限已关闭" message:@"请到设置->隐私->相机开启权限" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
                
                return ;
            }];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:okAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
            break;
        case AVAuthorizationStatusNotDetermined:
            DDLogDebug(@"not Determined");
            break;
        case AVAuthorizationStatusRestricted:
            DDLogDebug(@"Restricted");
            break;
        default:
            break;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        NSLog(@"模拟器中无法打开相机，请在真机中使用");
    }
}

#pragma mark - NET

#pragma mark - 批量上传图片
- (void)requestUpdateImages
{
    WEAK_SELF(self);
    [HTTPTool requestUploadImageToBATWithParams:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // 将本地的文件上传至服务器
        for (int i = 0; i < [_tempPicArray count]; i++) {
            UIImage *image = [_tempPicArray objectAtIndex:i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
            [formData appendPartWithFileData:imageData
                                        name:[NSString stringWithFormat:@"dynamic_picture%d",i]
                                    fileName:[NSString stringWithFormat:@"dynamic_picture%d.jpg",i]
                                    mimeType:@"multipart/form-data"];
        }
    } success:^(NSArray *imageArray) {
        STRONG_SELF(self);
        [self dismissProgress];
        
        DDLogDebug(@"imageArray %@",imageArray);
        [_picDataSource addObjectsFromArray:_tempPicArray];
        [_dynamicImgArray addObjectsFromArray:[BATImage mj_objectArrayWithKeyValuesArray:imageArray]];
        
        NSMutableArray *dynamicImg = [[NSMutableArray alloc] init];
        
        for (BATImage *batImage in _dynamicImgArray) {
            [dynamicImg addObject:batImage.url];
        }
        [_dynamicImgArray removeAllObjects];
        
        KMMEditorViewController *lmVC = [KMMEditorViewController new];
        lmVC.title = @"编辑课程";
        lmVC.isCanEdit = YES;
        lmVC.imageArr = dynamicImg;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:lmVC];
        [self presentViewController:nav animated:YES completion:nil];
        
        
        
    } failure:^(NSError *error) {
        
    } fractionCompleted:^(double count) {
        
        [self showProgres:count];
        
    }];
    
}
 */
@end
