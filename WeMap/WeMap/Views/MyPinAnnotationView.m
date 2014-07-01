//
//  MyPinAnnotationView.m
//  WeMap
//
//  Created by mac on 14-6-29.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "MyPinAnnotationView.h"

@implementation MyPinAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (id)initWithAnnotation:(id <MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

@end
