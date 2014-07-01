//
//  PostViewController.m
//  WeMap
//
//  Created by mac on 14-6-27.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "PostViewController.h"
#import <BmobSDK/BmobObject.h>
#import <BmobSDK/BmobUser.h>
#import <BmobSDK/BmobFile.h>

#import <BmobSDK/BmobGeoPoint.h>
#import <BmobSDK/BmobRelation.h>
#import "MBProgressHUD.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapCommonObj.h>


@interface PostViewController ()
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UITextField *textField;

@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UIButton *addressButton;

@property (strong, nonatomic) UIImageView *photoView;

@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) NSArray *pois;
@property (nonatomic, strong) AMapPOI *selectPOI;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PostViewController

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
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(postStory)];

    
    
    UIImageView *addressIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 74, 30, 30)];
    addressIcon.image = [UIImage imageNamed:@"AddressIcon"];
    [self.view addSubview:addressIcon];
    
    self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 74, 250, 30)];
    _addressLabel.font = [UIFont systemFontOfSize:16.f];
    _addressLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.addressLabel];
    
    self.addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addressButton.frame = CGRectMake(40, 74, 250, 30);
    _addressButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    _addressButton.titleLabel.textAlignment = NSTextAlignmentLeft;
//    [_addressButton setTitle:@"" forState:UIControlStateNormal];
//    [_addressButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_addressButton addTarget:self action:@selector(selectAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addressButton];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 124, 300, 30)];
    self.textField.placeholder = @"说点什么";

    [self.view addSubview:_textField];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 120, 300, 100)];
    self.textView.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.font = [UIFont systemFontOfSize:16.f];
    self.textView.delegate = self;
    self.textView.text = @"";
    self.textView.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:self.textView];
    
    
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraButton.frame = CGRectMake(10, 240, 25, 19);
    [cameraButton setImage:[UIImage imageNamed:@"Camera"] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(openImagePicker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraButton];
    
//    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkKeyboard)];
//    [self.view addGestureRecognizer:gesture];
    
    
    self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 230, 50, 50)];
    _photoView.clipsToBounds = YES;
    _photoView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_photoView];
    
    
    
    [self initCatIcon];
    
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:self];
    
    [self searchReGeocode];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 110, 300, self.view.frame.size.height - 174) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    self.tableView.layer.borderWidth = 2;
    [self.tableView setHidden:YES];
    [self.view addSubview:self.tableView];
    
    // 进入页面，直接焦点
//    [self.textView becomeFirstResponder];
}

- (void)checkKeyboard
{
    [self.textView resignFirstResponder];
}

- (void)initCatIcon
{
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(10, 290, 300, 100)];
    borderView.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    borderView.layer.borderWidth = 1;
    
    CGRect frame = CGRectMake(24, 10, 35, 35);
    for (int i=1; i<=4; i++) {
        if (i>1) {
            frame.origin.x += 70;
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"CatIcon00%d", i] ] forState:UIControlStateNormal];
//        button addTarget:self action:@selector(<#selector#>) forControlEvents:<#(UIControlEvents)#>
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
//        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"CatIcon00%d", i]];
        [borderView addSubview:button];
    }
    
    frame = CGRectMake(24, 55, 35, 35);
    for (int i=5; i<=8; i++) {
        if (i>5) {
            frame.origin.x += 70;
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"CatIcon00%d", i]];
        [borderView addSubview:imageView];
    }
    
    
    [self.view addSubview:borderView];
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

- (void)postStory
{
    NSString *txt = self.textView.text;
    if ([txt isEqualToString:@""]) {
        return;
    }
    
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
//    NSLog(@"txt: %@, location: %@", txt, self.userLocation.location);
    
    AMapGeoPoint *mapPoint = self.selectPOI.location;
    
    BmobUser *user = [BmobUser getCurrentUser];
    BmobGeoPoint *point = [[BmobGeoPoint alloc] initWithLongitude:mapPoint.longitude WithLatitude:mapPoint.latitude];
    BmobObject *story = [BmobObject objectWithClassName:@"Story"];
    
    //新建relation对象
    BmobRelation *relation = [[BmobRelation alloc] init];
    //relation添加id为25fb9b4a61的用户
    [relation addObject:[BmobUser objectWithoutDatatWithClassName:nil objectId:user.objectId]];
    
    [story addRelation:relation forKey:@"user"];
    [story setObject:user.objectId forKey:@"uid"];
    [story setObject:txt forKey:@"txt"];
    [story setObject:point forKey:@"point"];
    [story setObject:_addressLabel.text forKey:@"address"];
    
    if (self.photoView.image) {
        BmobFile *bFile = [[BmobFile alloc] initWithFileName:@"avatar.png" withFileData:UIImagePNGRepresentation(self.photoView.image)];
        [bFile saveInBackground:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                [story setObject:bFile forKey:@"photo"];
                [story saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
                    [HUD removeFromSuperViewOnHide];
                    HUD.customView = [[UILabel alloc] init];
                    HUD.mode = MBProgressHUDModeCustomView;
                    if (isSuccessful) {
                        
                        HUD.labelText = @"发布成功";
                        self.textView.text = @"";
                        
                    } else {
                        HUD.labelText = @"发布失败";
                    }
                    [HUD hide:YES afterDelay:1];
                    NSLog(@"%@", isSuccessful ? @"Y" : @"N");
                    NSLog(@"%@", error);
                    [self.navigationItem.rightBarButtonItem setEnabled:YES];
                }];
            }
        }];
    } else {
        [story saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
            [HUD removeFromSuperViewOnHide];
            HUD.customView = [[UILabel alloc] init];
            HUD.mode = MBProgressHUDModeCustomView;
            if (isSuccessful) {
                
                HUD.labelText = @"发布成功";
                self.textView.text = @"";
                
            } else {
                HUD.labelText = @"发布失败";
            }
            [HUD hide:YES afterDelay:1];
            NSLog(@"%@", isSuccessful ? @"Y" : @"N");
            NSLog(@"%@", error);
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
        }];
    }
    
    
    
    
    
    
    
    
}

- (void)searchReGeocode
{
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    CLLocationCoordinate2D coordinate = self.userLocation.location.coordinate;
    
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeoRequest.radius = 10000;
    regeoRequest.requireExtension = YES;
    [self.search AMapReGoecodeSearch: regeoRequest];
}


- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
    NSLog(@"ReGeo: %@", result);
    if (response.regeocode) {
        NSLog(@"%@", response.regeocode.formattedAddress);
        NSLog(@"%@", response.regeocode.addressComponent);
        
        if ([response.regeocode.pois count] > 0) {
            self.pois = [NSArray arrayWithArray:response.regeocode.pois];
            AMapPOI *POI = [self.pois objectAtIndex:0];
            self.selectPOI = POI;
            _addressLabel.text = POI.name;
            
//            for (AMapPOI *POI in response.regeocode.pois) {
//                
//                NSLog(@"%@, %@", POI.name, POI.location);
//            }
        }
        
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
//    NSLog(@"---%@", textView.text);
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        _textField.text = @"";
    } else if([_textField.text isEqualToString:@""]) {
        _textField.text = @" ";
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
//    NSLog(@"%@", textView.text);
    
    
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

- (void)selectAddress
{
    [self.textView resignFirstResponder];
    
    
    if (self.tableView.hidden == NO) {
        self.tableView.hidden = YES;
    } else if (self.tableView.hidden == YES) {
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }
    
}

- (void)openImagePicker
{
    [self.textView resignFirstResponder];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"选取照片" otherButtonTitles:@"拍摄照片", nil] ;
    actionSheet.tag = 144;
    [actionSheet showInView:self.view];

    
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:NSLocalizedString(@"选取照片", nil)]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
        return;
    } else if ([title isEqualToString:NSLocalizedString(@"拍摄照片", nil)]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
        return;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self.photoView setImage:image];
//        [self updateAvatar:image];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pois.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    AMapPOI *POI = [self.pois objectAtIndex:indexPath.row];
    cell.textLabel.text = POI.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMapPOI *POI = [self.pois objectAtIndex:indexPath.row];
    self.selectPOI = POI;
    _addressLabel.text = POI.name;
    [self.tableView setHidden:YES];
}

@end
