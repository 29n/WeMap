//
//  main.m
//  WeMap
//
//  Created by mac on 14-6-25.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobSDK/Bmob.h>
#import "AppDelegate.h"

int main(int argc, char * argv[])
{
    //应用key是3124f50157a5df138aba77a85e1d8909。可更换为您的应用的key
    [Bmob registerWithAppKey:@"f58504a90424ca43d3e9fbdee12e5bee"];
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
