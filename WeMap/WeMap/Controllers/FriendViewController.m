//
//  FriendViewController.m
//  WeMap
//
//  Created by mac on 14-6-26.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "FriendViewController.h"

#import <BmobSDK/BmobObject.h>//"BmobObject.h"
#import  <BmobSDK/BmobQuery.h>//"BmobQuery.h"
#import "MBProgressHUD.h"
#import  <BmobSDK/BmobUser.h>//"BmobUser.h"
#import <BmobSDK/BmobFile.h>//"BmobFile.h"
#import <BmobSDK/BmobRelation.h>//"BmobFile.h"

#import "MineViewController.h"
#import <AddressBook/AddressBook.h>
#import "EGOCache.h"


@interface FriendViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSArray *phones;


@end

@implementation FriendViewController



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
    self.title = @"好友";
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
//                                                                             style:UIBarButtonItemStylePlain
//                                                                            target:self
//                                                                            action:@selector(presentLeftMenuViewController:)];
    
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStyleDone target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    
    
//    [self testData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self readFriends];
    [self GetUserAddressBook];
}

- (void)readFriends
{
    BmobUser *user = [BmobUser getCurrentUser];

    NSLog(@"%@", user.objectId);
    
    //* --- 添加好友
//    BmobQuery *bQuery = [BmobQuery queryForUser];
//    [bQuery getObjectInBackgroundWithId:@"8464eab14b" block:^(BmobObject *object, NSError *error) {
//        NSLog(@"%@", object.objectId);
//        if (error == nil) {
//            BmobRelation *relation = [BmobRelation relation];
//            [relation addObject:object];
//            [user addRelation:relation forKey:@"friend"];
//            [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//                NSLog(@"error: %@", error);
//            }];
//        }
//    }];
    
    
    
    
    BmobQuery *fQuery = [BmobQuery queryForUser];
//    [fQuery whereKey:@"objectId" equalTo:@"8464eab14b"]; // 8464eab14b c257d813ea

    [fQuery whereObjectKey:@"friend" relatedTo:user];
    fQuery.cachePolicy = kBmobCachePolicyCacheThenNetwork;
    
    
    
    
    [fQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSLog(@"%@", array);
        if (error == nil) {
            NSMutableArray *arr = [NSMutableArray array];
            for (BmobObject *obj in array) {
                
                [arr addObject:obj];
                
                
                NSLog(@"%@", [obj objectForKey:@"nickname"]);
                
//                BmobRelation *relation = [BmobRelation relation];
//                [relation addObject:obj];
//                
//                [user addRelation:relation forKey:@"friend"];
//                [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//                    NSLog(@"%@", error);
//                }];
//                NSLog(@"%@ -- %@", obj.objectId, [obj objectForKey:@"nickname"]);
            }
            self.friends = [NSArray arrayWithArray:arr];
            [self.tableView reloadData];
            
            
        }
    }];
    
    
    
//    NSLog(@"%@", user.objectId);
//    BmobQuery *fQuery = [BmobQuery queryWithClassName:@"UserRelation"];
//    [fQuery whereKey:@"uid" equalTo:user.objectId];
//    NSLog(@"----%@", user.objectId);
//    BmobQuery *query = [BmobQuery queryForUser];
//    [query whereKey:@"objectId" matchesQuery:fQuery];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//        NSLog(@"%@", array);
//    }];
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


- (void)testData
{
    
    
    [self testUser];
    
    // 1. 用户注册，测试
//    [self addNewUser];
    
    // 2. 测试用户登录
//    [self loginUser];
    
}

- (void)newStory
{
    BmobUser *user = [BmobUser getCurrentUser];
    if (!user || !user.objectId) {
        NSLog(@"无效用户，。。。重新登录");
    }
    
//    BmobObject  *story = [BmobObject objectWithClassName:@"Story"];
    
}

- (void)testUser
{
    BmobUser *user = [BmobUser getCurrentUser];
    NSLog(@"%@ -- %@ -- %@", user.createdAt, user.objectId, [user objectForKey:@"username"]);
}

- (void)addNewUser
{
    // 1. 添加用户
//    BmobUser *user = [[BmobUser alloc] init];
    BmobUser *user = [BmobUser getCurrentUser];
    [user setUserName:@"13810575388"];
    [user setPassword:@"000000"];
    [user signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"添加成功");
        } else {
            if (error.code == 202) {
                NSLog(@"帐号已经被注册");
            }
            NSLog(@"%@", error);
        }
    }];
}

- (void)loginUser
{
    [BmobUser logInWithUsernameInBackground:@"13810575388" password:@"000000" block:^(BmobUser *user, NSError *error) {
        NSLog(@"%@ -- %@ -- %@", user.createdAt, user.objectId, [user objectForKey:@"username"]);
        
        NSLog(@"%@, %@", user, error);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.friends count];
    }
    if (section == 1) {
        return [self.phones count];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        BmobUser *user = [self.friends objectAtIndex:indexPath.row];
        cell.textLabel.text = [user objectForKey:@"nickname"];
        cell.detailTextLabel.text = @"";
        cell.imageView.image = nil;
    } else if (indexPath.section == 1) {
        
        NSDictionary *dic = [self.phones objectAtIndex:indexPath.row];
        cell.textLabel.text = [dic objectForKey:@"name"];
        cell.detailTextLabel.text = @"邀请";
        if ([dic objectForKey:@"avatar"]) {
            cell.imageView.image = [dic objectForKey:@"avatar"];
        }
    }
    
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
//    
//    label.font = [UIFont systemFontOfSize:12.f];
//    NSString *txt;
//    if (section == 0) {
//        txt = @"好友";
//    } else if (section ==1) {
//        txt = @"通讯录";
//    }
//    label.text = txt;
//    return label;
//    
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"好友";
    }
    if (section == 1) {
        return @"通讯录";
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
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
    if (indexPath.section == 0) {
        BmobUser *user = [self.friends objectAtIndex:indexPath.row];
        MineViewController *viewController = [[MineViewController alloc] init];
        viewController.uid = user.objectId;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


//获取通讯录
-(void)GetUserAddressBook
{
    id cachePhones = [[EGOCache globalCache] objectForKey:kUserPhones];
    if (cachePhones) {
        self.phones = [NSArray arrayWithArray:cachePhones];
        [self.tableView reloadData];
        return;
    }
    self.phones = [NSArray array];
    
    //获取通讯录权限
    ABAddressBookRef ab = NULL;
    // ABAddressBookCreateWithOptions is iOS 6 and up.
    if (&ABAddressBookCreateWithOptions) {
        CFErrorRef error = nil;
        ab = ABAddressBookCreateWithOptions(NULL, &error);
        
        if (error) { NSLog(@"%@", error); }
    }
    //    if (ab == NULL) {
    //        ab = ABAddressBookCreate();
    //    }
    if (ab) {
        // ABAddressBookRequestAccessWithCompletion is iOS 6 and up. 适配IOS6以上版本
        if (&ABAddressBookRequestAccessWithCompletion) {
            ABAddressBookRequestAccessWithCompletion(ab,
                                                     ^(bool granted, CFErrorRef error) {
                                                         if (granted) {
                                                             // constructInThread: will CFRelease ab.
                                                             [NSThread detachNewThreadSelector:@selector(constructInThread:)
                                                                                      toTarget:self
                                                                                    withObject:CFBridgingRelease(ab)];
                                                         } else {
                                                             //                                                             CFRelease(ab);
                                                             // Ignore the error
                                                         }
                                                     });
        } else {
            // constructInThread: will CFRelease ab.
            [NSThread detachNewThreadSelector:@selector(constructInThread:)
                                     toTarget:self
                                   withObject:CFBridgingRelease(ab)];
        }
    }
}
//获取到addressbook的权限
-(void)constructInThread:(ABAddressBookRef) ab
{
    NSLog(@"we got the access right");
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(ab);
    NSMutableArray* contactArray = [[NSMutableArray alloc] init];
    // {@"name"}
    for(int i = 0; i < CFArrayGetCount(results); i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
        //姓
        NSString *firstName = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        //姓音标
        //        NSString *firstNamePhonetic = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty));
        //名
        NSString *lastname = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
        
        UIImage *img = CFBridgingRelease(ABRecordCopyValue(person, kABPersonImageFormatThumbnail));
        
        
        //读取电话多值
        NSString* phoneString = @"";
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            //获取电话Label
            //            NSString * personPhoneLabel = (NSString*)CFBridgingRelease(ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k)));
            //获取該Label下的电话值
            NSString * personPhone = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phone, k));
            phoneString = [phoneString stringByAppendingFormat:@",%@",personPhone];
            personPhone = nil;
            
        }
        CFRelease(phone);
                //构造字典
//        NSDictionary* dic = @{@"first_name": firstName?firstName:[NSNull null],
//                              @"last_name": lastname?lastname:[NSNull null],
//                              @"home_phone": phoneString?phoneString:[NSNull null],
//                              @"email": emailString?emailString:[NSNull null],
//                              @"company": Organization?Organization:[NSNull null],
//                              @"nick_name": nickname?nickname:[NSNull null],
//                              @"department": department?department:[NSNull null],
//                              @"birthday": [NSNumber numberWithDouble:birthdayString],
//                              @"blog_index": urlString?urlString:[NSNull null]
//                              };
        NSString *username = nil;
        if (firstName && lastname) {
            username = [NSString stringWithFormat:@"%@%@", firstName, lastname];
        } else if (lastname) {
            username = lastname;
        } else if (firstName) {
            username = firstName;
        }
        if (username != nil) {
            NSDictionary *dic = @{@"name":username};
            [contactArray addObject:dic];
        }
        
        
        phoneString = nil;
    }
    CFRelease(results);
    self.phones = [NSArray arrayWithArray:contactArray];
    [[EGOCache globalCache] setObject:self.phones forKey:kUserPhones];
    contactArray = nil;
    [self.tableView reloadData];
}


@end
