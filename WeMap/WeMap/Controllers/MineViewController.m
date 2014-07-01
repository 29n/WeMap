//
//  MineViewController.m
//  WeMap
//
//  Created by mac on 14-6-26.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "MineViewController.h"
#import <BmobSDK/BmobUser.h>
#import <BmobSDK/BmobQuery.h>
#import <BmobSDK/BmobFile.h>
#import "UIImageView+AFNetworking.h"


#import "MyPointAnnotation.h"
#import "StoryDetailViewController.h"


@interface MineViewController ()
@property(nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) BmobUser *User;
@property (nonatomic, strong) UILabel *usernameLabel;


@end

@implementation MineViewController

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
    self.title = @"个人主页";
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
//                                                                             style:UIBarButtonItemStylePlain
//                                                                            target:self
//                                                                            action:@selector(presentLeftMenuViewController:)];
    
    if (!self.uid) {
        UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStyleDone target:self action:@selector(presentLeftMenuViewController:)];
        self.navigationItem.leftBarButtonItem = leftBar;
    }
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *avatarView = [[UIImageView alloc] init];
    avatarView.frame = CGRectMake(20, 84, 50, 50);
    avatarView.layer.masksToBounds = YES;
    avatarView.layer.cornerRadius = 25;
    [self.view addSubview:avatarView];
    
    self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 90, 100, 20)];
    _usernameLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:_usernameLabel];
    
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 48, 100, 20)];
    timeLabel.font = [UIFont systemFontOfSize:12.f];
    timeLabel.text = @"16小时前";
    [self.view addSubview:timeLabel];
    
    UILabel *txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 48, 100, 20)];
    txtLabel.font = [UIFont systemFontOfSize:12.f];
    txtLabel.text = @"16小时前";
    [self.view addSubview:txtLabel];
    
    
    
    if (!_uid) {
        self.User = [BmobUser getCurrentUser];
        self.uid = self.User.objectId;
        self.usernameLabel.text = [self.User objectForKey:@"nickname"];
        
        BmobFile *file = (BmobFile*)[self.User objectForKey:@"avatar"];
        if (file) {
            [avatarView setImageWithURL:[NSURL URLWithString:file.url]];
        }
        
        [self initMapView];
        [self loadPoints];
    } else {
        
        BmobQuery *bquery = [BmobQuery queryWithClassName:@"_User"];
        [bquery getObjectInBackgroundWithId:_uid block:^(BmobObject *object, NSError *error) {
            BmobUser *tmpU = (BmobUser *)object;
            BmobFile *file = (BmobFile*)[tmpU objectForKey:@"avatar"];
            if (file) {
                [avatarView setImageWithURL:[NSURL URLWithString:file.url]];
            }
            NSLog(@"%@", [tmpU objectForKey:@"nickname"]);
            self.User = tmpU;
            self.usernameLabel.text = [self.User objectForKey:@"nickname"];
            [self initMapView];
            [self loadPoints];
        }];
        
    }
    
    
}

-(void)closeScale
{
    self.mapView.showsScale= NO;         //关闭比例尺
}

#pragma mark - Initialization

- (void)initMapView
{
    CGRect frame = self.view.frame;
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 160, 320, frame.size.height-160)];
    [self closeScale];
    self.mapView.delegate = self;
    self.mapView.distanceFilter = 10.f;
    [self.view addSubview:self.mapView];
    
    self.mapView.rotateEnabled = NO;
    self.mapView.rotateCameraEnabled = NO;
    self.mapView.zoomEnabled = YES;

    //    self.mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
//    self.mapView.showsUserLocation = YES;
    
    
    
    //    [self initAnnotations];
}

- (void)showPoints
{
    //    BmobObject *story = [BmobObject objectWithClassName:@"Story"];

    
    
    


    
}

- (void)loadPoints
{
    [self.mapView removeAnnotations:self.annotations];
    
    self.annotations = [NSMutableArray array];
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Story"];
    [bquery includeKey:@"user"];
    bquery.limit = 200;
    [bquery whereKey:@"uid" equalTo:_uid];
    [bquery orderByDescending:@"createdAt"];
    //    [bquery whereKeyExists:@"user"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error == nil) {
            for (BmobObject *obj in array) {
                //打印playerName
                MyPointAnnotation *ann = [[MyPointAnnotation alloc] init];
                BmobGeoPoint *point = [obj objectForKey:@"point"];
                if (point) {
                    ann.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude);
                    ann.storyId = obj.objectId;
                    ann.title = [self.User objectForKey:@"nickname"];
                    ann.subtitle = [obj objectForKey:@"txt"];
                    [self.annotations addObject:ann];
                }
            }
            [self.mapView addAnnotations: self.annotations];
        }
        
    }];
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

//-(MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id)annotation
//{
//    if ([annotation isKindOfClass:[MAPointAnnotation class]])
//    {
//        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
//        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
//        if (annotationView == nil)
//        {
//            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
//            //            annotationView.leftCalloutAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//            //            annotationView.leftCalloutAccessoryView.backgroundColor = [UIColor redColor];
//            //            annotationView.rightCalloutAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//            //            annotationView.rightCalloutAccessoryView.backgroundColor = [UIColor lightGrayColor];
//            //            annotationView.centerOffset = CGPointMake(30, 0);
//            annotationView.canShowCallout= YES;      //设置气泡可以弹出，默认为NO
//            //            annotationView.animatesDrop = YES;       //设置标注动画显示，默认为NO
//            //            annotationView.draggable = YES;           //设置标注可以拖动，默认为NO
//            
//            //            annotationView.image = [UIImage imageNamed:@"Pin"];
//            //            annotationView.layer.masksToBounds = YES;
//            //            annotationView.layer.cornerRadius = 25;
//            
//            
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];  //设置气泡右侧按钮
////            [button addTarget:self action:@selector(arrowClick) forControlEvents:UIControlEventTouchUpInside];
//            annotationView.rightCalloutAccessoryView=button;
//            
//            //            [annotationView setUserInteractionEnabled:YES];
//            //
//            //            UIControl *view = [[UIControl alloc] initWithFrame:CGRectMake(18, -4, 50, 26)];
//            //            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Arrow"]];
//            //            imageView.frame = CGRectMake(10, 0, 12, 21);
//            //            [view addSubview:imageView];
//            //            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 50, 26)];
//            //            //            label.textAlignment = NSTextAlignmentCenter;
//            //            label.userInteractionEnabled = NO;
//            //            // 21 126 251
//            //            label.backgroundColor = UIColorFromRGB(0x67A2E3);
//            //            label.textColor = [UIColor whiteColor];
//            //            label.text = @"测试几句";
//            //            label.font = [UIFont boldSystemFontOfSize:14.0f];
//            //            [label sizeToFit];
//            //            CGRect frame = label.frame;
//            //            frame.size.width = frame.size.width + 4;
//            //            frame.size.height = frame.size.height + 4;
//            //            label.frame = frame;
//            //            [view addSubview:label];
//            //            [view addTarget:self action:@selector(arrowClick) forControlEvents:UIControlEventTouchUpInside];
//            //            [annotationView addSubview:view];
//            
//        }
//        
//        annotationView.pinColor = [self.annotations indexOfObject:annotation];
//        return annotationView;
//    }
//    return nil;
//}

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

- (void)openStory:(NSString *)storyId
{
    StoryDetailViewController *storyVC = [[StoryDetailViewController alloc] init];
    storyVC.storyId = storyId;
    [self.navigationController pushViewController:storyVC animated:YES];
    
}


@end
