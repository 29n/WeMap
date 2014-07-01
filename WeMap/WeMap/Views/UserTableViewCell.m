//
//  UserTableViewCell.m
//  WeMap
//
//  Created by mac on 14-6-29.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "UserTableViewCell.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@implementation UserTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.avatarView = [[UIImageView alloc] init];
        _avatarView.frame = CGRectMake(20, 20, 50, 50);
        _avatarView.layer.masksToBounds = YES;
        _avatarView.layer.cornerRadius = 25;
        [self addSubview:_avatarView];
        
        _usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 25, 100, 20)];
        _usernameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        _usernameLabel.text = @"";
        [self addSubview:_usernameLabel];
        
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 25, 220, 20)];
        _timeLabel.font = [UIFont systemFontOfSize:14.f];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.text = @"";
        [self addSubview:_timeLabel];
        
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, 200, 20)];
        _addressLabel.font = [UIFont systemFontOfSize:14.f];
        _addressLabel.text = @"";
        [self addSubview:_addressLabel];
        
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 100, 280, 30)];
        _textView.text = @"";
        _textView.font = [UIFont boldSystemFontOfSize:16.f];
        [self addSubview:_textView];
        
        
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 140, 280, 200)];
        _photoView.clipsToBounds = YES;
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_photoView];
        
        UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [likeButton setImage:[UIImage imageNamed:@"likeIcon.png"] forState:UIControlStateNormal];
        likeButton.frame = CGRectMake(160, 360, 24, 22);
        [likeButton addTarget:self action:@selector(like) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:likeButton];
        UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [commentButton setImage:[UIImage imageNamed:@"writeComment.png"] forState:UIControlStateNormal];
        [commentButton addTarget:self action:@selector(writeComment) forControlEvents:UIControlEventTouchUpInside];
        commentButton.frame = CGRectMake(210, 360, 24, 22);
        [self addSubview:commentButton];
        UIButton *favButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [favButton setImage:[UIImage imageNamed:@"favIcon.png"] forState:UIControlStateNormal];
        [favButton addTarget:self action:@selector(fav) forControlEvents:UIControlEventTouchUpInside];
        favButton.frame = CGRectMake(255, 360, 24, 22);
        [self addSubview:favButton];
        
        
        UIImageView *borderView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 370, 300, 25)];
        borderView.image = [UIImage imageNamed:@"DetailBorder.png"];
        [self addSubview:borderView];
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fav
{
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
}

- (void)writeComment
{
    
}

- (void)like
{
    
}

@end
