//
//  HomeViewController.h
//  WeMap
//
//  Created by mac on 14-6-26.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import <MAMapKit/MAMapKit.h>
#import "CusAnnotationView.h"


@interface HomeViewController : UIViewController <MAMapViewDelegate, CusAnnotationViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@end
