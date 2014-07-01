//
//  StoryDetailViewController.m
//  WeMap
//
//  Created by mac on 14-6-28.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "StoryDetailViewController.h"

#import <BmobSDK/BmobUser.h>
#import <BmobSDK/BmobQuery.h>
#import <BmobSDK/BmobFile.h>

#import "UIImageView+AFNetworking.h"



#import "UserTableViewCell.h"

@interface StoryDetailViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BmobUser *User;
@property (nonatomic, strong) BmobObject *story;
@property (nonatomic, strong) NSString *photoUrl;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSArray *likes;

@end

@implementation StoryDetailViewController

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
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"我在";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
//    UIImageView *avatarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"demoFace.jpg"]];
//    avatarView.frame = CGRectMake(10, 10, 100, 100);
//    [self.view addSubview:avatarView];
    
    /*
     东方来客：王府井？失恋33天？
     肖肖说：对！梦幻的北京小夜晚，哈哈哈哈
     东方来客：我豆瓣花姐威武！曾经跑到三里屯就为了去看那块从没亮过的霓虹灯！
     */
    
    if ([self.storyId isEqualToString:@"28787ba940"]) {
//        self.comments = @[
//                          @{@"name":@"东方来客", @"txt":@"王府井？失恋33天？"},
//                          @{@"name":@"肖肖", @"txt":@"对！梦幻的北京小夜晚，哈哈哈哈"},
//                          @{@"name":@"东方来客", @"txt":@"我豆瓣花姐威武！曾经跑到三里屯就为了去看那块从没亮过的霓虹灯！"}, ];
        self.comments = @[@"", @"东方来客：王府井？失恋33天？", @"肖肖回复东方来客：对！梦幻的北京小夜晚，哈哈哈哈", @"东方来客：我豆瓣花姐威武！曾经跑到三里屯就为了去看那块从没亮过的霓虹灯！"];
        
    }
    
    
    
    
    // 初始化用户列表，
    // Demo直接拉去全部数据，
    // 真实环境，读取好友信息+自己信息
//    self.users = [NSMutableDictionary dictionary];
    
    NSLog(@"%@", self.storyId);
    
    BmobQuery *storyQuery = [BmobQuery queryWithClassName:@"Story"];
    [storyQuery getObjectInBackgroundWithId:self.storyId block:^(BmobObject *object, NSError *error) {
        if (error == nil) {
            
            self.story = object;
            NSLog(@"%@", [object objectForKey:@"txt"]);
            
            NSString *uid = [object objectForKey:@"uid"];
            BmobQuery *uQuery = [BmobQuery queryWithClassName:@"_User"];
            [uQuery getObjectInBackgroundWithId:uid block:^(BmobObject *object, NSError *error) {
                self.User = (BmobUser *)object;
                BmobFile *file = (BmobFile*)[self.User objectForKey:@"avatar"];
                if (file) {
                    self.avatarUrl = file.url;
                    NSLog(@"%@", file.url);
                }
                [self.tableView reloadData];
            }];
//            
//            BmobQuery *bquery = [BmobQuery queryWithClassName:@"Comment"];
//            bquery.limit = 2000;
//            [bquery whereKey:@"storyId" equalTo:self.storyId];
//            [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//                NSLog(@"%@, %@", array, error);
//                if (error == nil) {
//                    self.comments = array;
//                    [self.tableView reloadData];
//                }
//            }];
            
            BmobFile *file = (BmobFile*)[self.story objectForKey:@"photo"];
            NSLog(@"%@, %@", file, file.url);
            if (file) {
                self.photoUrl = file.url;
                [self.tableView reloadData];
            }
        }
    }];
    
    

    //    [fQuery whereKey:@"objectId" equalTo:@"8464eab14b"]; // 8464eab14b c257d813ea
    
    
    
    
    
    
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
//        return [self.friends count];
//    }
//    if (section == 1) {
//        return [self.phones count];
//    }
    if (self.comments.count == 0) {
        return 1;
    }
    return self.comments.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 用户信息
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"Cell0";
        UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([self.storyId isEqualToString:@"28787ba940"]) {
                UIImageView *xxView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 408, 18, 18)];
                xxView.image = [UIImage imageNamed:@"likeIcon.png"];
                [cell addSubview:xxView];
                UILabel *xxLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 405, 200, 25)];
                xxLabel.text = @"东方来客、独孤求败";
                xxLabel.textColor = UIColorFromRGB(0x15467D);
                [cell addSubview:xxLabel];
                
                UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(10, 435, 300, 1)];
                bView.backgroundColor = UIColorFromRGB(0xdddddd);
                [cell addSubview:bView];
            }
        }
        
        cell.usernameLabel.text = [self.User objectForKey:@"nickname"];
        cell.addressLabel.text = [self.story objectForKey:@"address"];
        NSString *timeStr = [self shortDatetime:self.story.createdAt];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@", timeStr];
        cell.textView.text = [self.story objectForKey:@"txt"];
        if (self.photoUrl) {
            [cell.photoView setImageWithURL:[NSURL URLWithString:self.photoUrl]];
        }
        if (self.avatarUrl) {
            [cell.avatarView setImageWithURL:[NSURL URLWithString:self.avatarUrl]];
        } else {
//            [cell.avatarView setImage:[UIImage imageNamed:@"demoFace.jpg"]];
        }
        
        
        

        return cell;
    }
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    

    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];

    [paragraphStyle setLineSpacing:4.0f];
    [paragraphStyle setAlignment:NSTextAlignmentJustified];
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont boldSystemFontOfSize:16.f], NSParagraphStyleAttributeName: paragraphStyle};
    
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[self.comments objectAtIndex:indexPath.row] attributes:attributes];
    
    NSDictionary *redAttributes = @{ NSFontAttributeName: [UIFont boldSystemFontOfSize:16.f], NSForegroundColorAttributeName:UIColorFromRGB(0x15467D), NSParagraphStyleAttributeName: paragraphStyle};
    int n = 0;
    if (indexPath.row == 1 || indexPath.row == 3) {
        n = 4;
        [attributedString addAttributes:redAttributes range:NSMakeRange(0,n)];
    } else {
        n = 2;
        [attributedString addAttributes:redAttributes range:NSMakeRange(0,2)];
        [attributedString addAttributes:redAttributes range:NSMakeRange(4,4)];
    }
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.attributedText = attributedString;
    
    
    
    
//    if (indexPath.section == 0) {
//        BmobUser *user = [self.friends objectAtIndex:indexPath.row];
//        cell.textLabel.text = [user objectForKey:@"nickname"];
//        cell.detailTextLabel.text = @"";
//        cell.imageView.image = nil;
//    } else if (indexPath.section == 1) {
//        
//        NSDictionary *dic = [self.phones objectAtIndex:indexPath.row];
//        cell.textLabel.text = [dic objectForKey:@"name"];
//        cell.detailTextLabel.text = @"邀请";
//        if ([dic objectForKey:@"avatar"]) {
//            cell.imageView.image = [dic objectForKey:@"avatar"];
//        }
//    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];

    return label;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 450;
    }
    
//    NSString *msg = [self.comments objectAtIndex:indexPath.row];
    if (indexPath.row == 3 || indexPath.row == 2) {
        return 50;
    }
    return 28;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
//    label.text = @"BBB";
//    return label;
//}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)shortDatetime:(NSDate *)date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSDate *tmpDate = date;
    
    NSDate *now = [NSDate date];
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |
    NSDayCalendarUnit | NSHourCalendarUnit |
    NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *compInfo = [sysCalendar components:unitFlags
                                                fromDate:tmpDate
                                                  toDate:now
                                                 options:0];
    //    NSDateComponents *compInfo1 = [sysCalendar components:unitFlags fromDate:[NSDate date]];
    //    int nowTheHour = [compInfo1 hour];
    NSInteger year = [compInfo year];
    NSInteger month = [compInfo month];
    NSInteger day = [compInfo day];
    NSInteger hour = [compInfo hour];
    NSInteger min = [compInfo minute];
    //    NSInteger sec = [compInfo second];
    //    NSLog(@"%@, %d, %d, %d, %d, %d, %d", now, year, month, day, hour, min, sec);
    
    [dateFormat setDateFormat: @"yyyy"];
    NSString *currentYear = [dateFormat stringFromDate:now];
    NSString *dateYear = [dateFormat stringFromDate:tmpDate];
    if (year > 0 || [dateYear compare:currentYear options:NSNumericSearch] != NSOrderedSame) {
        [dateFormat setDateFormat: @"yyyy-MM-dd"];
        return dateYear;
    }
    if (month > 0 || day > 2) {
        //        [dateFormat setDateFormat: @"M月d日 H:mm"];
        [dateFormat setDateFormat: @"MM-dd"];
        return [dateFormat stringFromDate:tmpDate];
    }
    
    if (day == 2) {
        [dateFormat setDateFormat: @"前天"];
        return [dateFormat stringFromDate:tmpDate];
    }
    
    if (day == 1) {
        [dateFormat setDateFormat: @"昨天"];
        return [dateFormat stringFromDate:tmpDate];
    }
    
    if (hour > 0) {
        return [NSString stringWithFormat:@"%d小时前", hour];
    }
    
    if (min > 0) {
        return [NSString stringWithFormat:@"%d分钟前", min];
    }
    
    return @"刚刚";
    
}


@end
