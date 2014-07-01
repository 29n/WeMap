//
//  HomeViewController.m
//  WeMap
//
//  Created by mac on 14-6-26.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "HomeViewController.h"
#import "PostViewController.h"
#import <BmobSDK/BmobUser.h>
#import <BmobSDK/BmobQuery.h>
#import "CusAnnotationView.h"
#import "MyPinAnnotationView.h"
#import "MyPointAnnotation.h"
#import "StoryViewController.h"
#import "StoryDetailViewController.h"


@interface HomeViewController ()

@property(nonatomic, strong) NSMutableArray *annotations;
/*!
 @brief 位置信息
 */
@property (nonatomic, strong) CLLocation *currentLocation;

@property (nonatomic, strong) NSMutableDictionary *users;
@end

@implementation HomeViewController

- (void)dealloc
{
    self.mapView.delegate = nil;
    [self.mapView removeFromSuperview];
    self.mapView = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"WeMap";
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
//    
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStyleDone target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.leftBarButtonItem = leftBar;

    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
//                                                                             style:UIBarButtonItemStylePlain
//                                                                            target:self
//                                                                            action:@selector(presentLeftMenuViewController:)];
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Right"
    //                                                                             style:UIBarButtonItemStylePlain
    //                                                                            target:self
    //                                                                            action:@selector(presentRightMenuViewController:)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.image = [UIImage imageNamed:@"Balloon"];
    [self.view addSubview:imageView];
    
    
    
    [MAMapServices sharedServices].apiKey = @"90caf3bb3f2a36140fa369061e4e92c0";
    
//    self.currentLocation = [[CLLocation alloc] init];
    [self initMapView];
    
    
    UIButton *postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [postBtn setImage:[UIImage imageNamed:@"PostBtn.png"] forState:UIControlStateNormal];
    [postBtn addTarget:self action:@selector(postStory) forControlEvents:UIControlEventTouchUpInside];
    
    postBtn.frame = CGRectMake(self.view.frame.size.width - 60, self.view.frame.size.height - 60, 57, 58);
    [self.view insertSubview:postBtn aboveSubview:self.mapView];
    
    // 指定登录用户
    [BmobUser logInWithUsernameInBackground:@"13810575387" password:@"000000" block:^(BmobUser *user, NSError *error) {
        NSLog(@"%@ -- %@ -- %@", user.createdAt, user.objectId, [user objectForKey:@"username"]);
        
        NSLog(@"%@, %@", user, error);
    }];
    
    
    // 初始化用户列表，
    // Demo直接拉去全部数据，
    // 真实环境，读取好友信息+自己信息
    self.users = [NSMutableDictionary dictionary];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"_User"];
    bquery.limit = 2000;
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSLog(@"%@, %@", array, error);
        if (error == nil) {
            for (BmobObject *obj in array) {
                [self.users setObject:obj forKey:obj.objectId];
            }
            NSLog(@"%@", _users);
        }
    }];
    
    
    
    [self performSelector:@selector(showPoints) withObject:nil afterDelay:1];

    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark - Initialization

- (void)initMapView
{
    CGRect frame = self.view.frame;
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, 320, frame.size.height-64)];
    [self closeScale];
    self.mapView.delegate = self;
    self.mapView.distanceFilter = 10.f;
    [self.view addSubview:self.mapView];
    
    self.mapView.rotateEnabled = NO;
    self.mapView.rotateCameraEnabled = NO;
    self.mapView.zoomEnabled = YES;
//    self.mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
    self.mapView.showsUserLocation = YES;
    
    
    
//    [self initAnnotations];
}


-(void)closeScale
{
    self.mapView.showsScale= NO;         //关闭比例尺
}

// 定位更新时的回调函数
-(void)mapView:(MAMapView*)mapView didUpdateUserLocation:(MAUserLocation*)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if (updatingLocation) {
        NSLog(@"%@", userLocation.location);
        self.currentLocation = userLocation.location;
        if (self.currentLocation) {
            NSLog(@"%@", self.currentLocation);
        }
    }
    
    
}

// 定位获取失败时的回调函数
-(void)mapView:(MAMapView*)mapView didFailToLocateUserWithError:(NSError*)error
{
    
}


- (void)initAnnotations
{
    self.annotations = [NSMutableArray array];
    //定义一个标注，放到annotations数组
    MAPointAnnotation *red = [[MAPointAnnotation alloc] init];
    red.coordinate = CLLocationCoordinate2DMake(39.911447, 116.406026);
    red.title  = @"Red";
    [self.annotations insertObject:red atIndex: 0];
    //定义第二个标注，放到annotations数组
    MAPointAnnotation *green = [[MAPointAnnotation alloc] init];
    green.coordinate = CLLocationCoordinate2DMake(39.909698, 116.296248);
    green.title  = @"Green";
    //定义第三标注，放到annotations数组
    [self.annotations insertObject:green atIndex:1];
    MAPointAnnotation *purple = [[MAPointAnnotation alloc] init];
    purple.coordinate = CLLocationCoordinate2DMake(40.045837, 116.460577);
    purple.title  = @"Purple";
    [self.annotations insertObject:purple atIndex:2];
    //添加annotations数组中的标注到地图上
    [self.mapView addAnnotations: self.annotations];
}

-(MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"point00ReuseIndetifier";
        CusAnnotationView *annotationView = (CusAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CusAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            annotationView.mapDelegate = self;
            annotationView.canShowCallout = NO;
            int value = (arc4random() % 7) + 1;
            annotationView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Pin00%d", value]];

            
        }
        return annotationView;
    }
    return nil;
}



//
//-(MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id)annotation
//{
//    if ([annotation isKindOfClass:[MAPointAnnotation class]])
//    {
//        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
//        MyPinAnnotationView *annotationView = (MyPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
//        if (annotationView == nil)
//        {
//            annotationView = [[MyPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
////            annotationView.leftCalloutAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
////            annotationView.leftCalloutAccessoryView.backgroundColor = [UIColor redColor];
////            annotationView.rightCalloutAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
////            annotationView.rightCalloutAccessoryView.backgroundColor = [UIColor lightGrayColor];
////            annotationView.centerOffset = CGPointMake(30, 0);
//            annotationView.canShowCallout= YES;      //设置气泡可以弹出，默认为NO
////            annotationView.animatesDrop = YES;       //设置标注动画显示，默认为NO
//            //            annotationView.draggable = YES;           //设置标注可以拖动，默认为NO
//            
//            int value = (arc4random() % 13) + 1;
//            annotationView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Pin00%d", value]];
////            annotationView.layer.masksToBounds = YES;
////            annotationView.layer.cornerRadius = 25;
//
//            
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];  //设置气泡右侧按钮
//            [button addTarget:self action:@selector(arrowClick) forControlEvents:UIControlEventTouchUpInside];
//            annotationView.rightCalloutAccessoryView=button;
//            
////            [annotationView setUserInteractionEnabled:YES];
////            
////            UIControl *view = [[UIControl alloc] initWithFrame:CGRectMake(18, -4, 50, 26)];
////            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Arrow"]];
////            imageView.frame = CGRectMake(10, 0, 12, 21);
////            [view addSubview:imageView];
////            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 50, 26)];
////            //            label.textAlignment = NSTextAlignmentCenter;
////            label.userInteractionEnabled = NO;
////            // 21 126 251
////            label.backgroundColor = UIColorFromRGB(0x67A2E3);
////            label.textColor = [UIColor whiteColor];
////            label.text = @"测试几句";
////            label.font = [UIFont boldSystemFontOfSize:14.0f];
////            [label sizeToFit];
////            CGRect frame = label.frame;
////            frame.size.width = frame.size.width + 4;
////            frame.size.height = frame.size.height + 4;
////            label.frame = frame;
////            [view addSubview:label];
////            [view addTarget:self action:@selector(arrowClick) forControlEvents:UIControlEventTouchUpInside];
////            [annotationView addSubview:view];
//            
//        }
//        
////        annotationView.pinColor = [self.annotations indexOfObject:annotation];
//        return annotationView;
//    }
//    return nil;
//}
//
- (void)arrowClick
{
    
    NSLog(@"arrowClick");
}

- (void)openStory:(NSString *)storyId
{
    StoryDetailViewController *storyVC = [[StoryDetailViewController alloc] init];
    storyVC.storyId = storyId;
    [self.navigationController pushViewController:storyVC animated:YES];
    
}

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    MyPointAnnotation *annotation = view.annotation;
    NSLog(@"%@", annotation.storyId);
    
    
    StoryDetailViewController *storyVC = [[StoryDetailViewController alloc] init];
    storyVC.storyId = annotation.storyId;
    [self.navigationController pushViewController:storyVC animated:YES];
    
//    StoryViewController *storyVC = [[StoryViewController alloc] init];
//    [self.navigationController pushViewController:storyVC animated:YES];

    
//    id<MAAnnotation> annotation = view.annotation;
    
//    if ([annotation isKindOfClass:[POIAnnotation class]])
//    {
//        POIAnnotation *poiAnnotation = (POIAnnotation*)annotation;
//        
//        PoiDetailViewController *detail = [[PoiDetailViewController alloc] init];
//        detail.poi = poiAnnotation.poi;
//        
//        /* 进入POI详情页面. */
//        [self.navigationController pushViewController:detail animated:YES];
//    }
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    
}

- (void)postStory
{
    NSLog(@"开始书写故事");
    
    // 判断的手机的定位功能是否开启
    // 开启定位:设置 > 隐私 > 位置 > 定位服务
    if ([CLLocationManager locationServicesEnabled]) {
        // 启动位置更新
        // 开启位置更新需要与服务器进行轮询所以会比较耗电，在不需要时用stopUpdatingLocation方法关闭;
//        [self.locationManager startUpdatingLocation];
//        self.mapView.showsUserLocation = YES;
    }
    else {
        NSLog(@"请开启定位功能！");
    }
    
    
    
    
    PostViewController *vc = [[PostViewController alloc] init];
    vc.userLocation = self.mapView.userLocation;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)showPoints
{
//    BmobObject *story = [BmobObject objectWithClassName:@"Story"];
    
    
    [self.mapView removeAnnotations:self.annotations];
    
    self.annotations = [NSMutableArray array];
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Story"];
    [bquery includeKey:@"user"];
    bquery.limit = 200;
    [bquery orderByDescending:@"createdAt"];
//    [bquery whereKeyExists:@"user"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            //打印playerName
            NSLog(@"obj.point = %@", [obj objectForKey:@"point"]);
            BmobObject *u =  [obj objectForKey:@"user"];
            
            NSLog(@"username: %@", u);
            
            MyPointAnnotation *ann = [[MyPointAnnotation alloc] init];
            BmobGeoPoint *point = [obj objectForKey:@"point"];
            if (point) {
                ann.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude);
                ann.storyId = obj.objectId;
                NSString *uid = [obj objectForKey:@"uid"];
                BmobObject *tmpUser = [self.users objectForKey:uid];
                if (tmpUser) {
                    ann.title = [tmpUser objectForKey:@"nickname"];
                } else {
                    ann.title = [obj objectForKey:@"uid"];
                }
                ann.subtitle = [obj objectForKey:@"txt"];

                [self.annotations addObject:ann];
            }
        }
        [self.mapView addAnnotations: self.annotations];
    }];
    
}



@end
