//
//  FriendTableViewController.h
//  WeMap
//
//  Created by mac on 14-6-26.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    int             _seletedID;
    NSMutableArray  *_dataArray;
    
    UITableView     *_queryTableView;
    
}
@end
