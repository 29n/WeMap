//
//  PostViewController.h
//  WeMap
//
//  Created by mac on 14-6-27.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface PostViewController : UIViewController<UITextViewDelegate, AMapSearchDelegate, AMapSearchDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

/*!
 @brief 当前的位置数据
 */
@property (nonatomic, strong) MAUserLocation *userLocation;

@end
