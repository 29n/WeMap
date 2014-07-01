//
//  CusAnnotationView.m
//  MAMapKit_static_demo
//
//  Created by songjian on 13-10-16.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "CusAnnotationView.h"
#import "CustomCalloutView.h"
#import "MyPointAnnotation.h"

#define kWidth  90.f
#define kHeight 28.f

#define kHoriMargin 40.f
#define kVertMargin -10.f

#define kPortraitWidth  10.f
#define kPortraitHeight 28.f

#define kCalloutWidth   200.0
#define kCalloutHeight  200.0

@interface CusAnnotationView ()

@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation CusAnnotationView

@synthesize calloutView;
@synthesize portraitImageView   = _portraitImageView;
@synthesize nameLabel           = _nameLabel;

#pragma mark - Handle Action

- (void)btnAction
{
    CLLocationCoordinate2D coorinate = [self.annotation coordinate];
    
    NSLog(@"coordinate = {%f, %f}", coorinate.latitude, coorinate.longitude);
}

#pragma mark - Override

- (NSString *)name
{
    return self.nameLabel.text;
}

- (void)setName:(NSString *)name
{
    self.nameLabel.text = name;
}

- (UIImage *)portrait
{
    return self.portraitImageView.image;
}

- (void)setPortrait:(UIImage *)portrait
{
    self.portraitImageView.image = portrait;
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    if (self.selected == selected)
//    {
//        return;
//    }
    
    if (selected)
    {
        
        if (self.mapDelegate && [self.mapDelegate respondsToSelector:@selector(openStory:)]) {
            MyPointAnnotation *ann = (MyPointAnnotation *)self.annotation;
            [self.mapDelegate openStory:ann.storyId];
        }
        if (self.calloutView == nil)
        {
            /* Construct custom callout. */
//            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
//            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
//                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
//            
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            btn.frame = CGRectMake(10, 10, 40, 40);
//            [btn setTitle:@"Test" forState:UIControlStateNormal];
//            [btn setBackgroundColor:[UIColor whiteColor]];
//            [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//            [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
//            
//            [self.calloutView addSubview:btn];
//            
//            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 30)];
//            name.backgroundColor = [UIColor clearColor];
//            name.textColor = [UIColor whiteColor];
//            name.text = @"Hello Amap!";
//            [self.calloutView addSubview:name];
           
        }
        
//        [self addSubview:self.calloutView];
        
        
        
        
        NSLog(@"点击剪头");
    }
    else
    {
//        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits, 
     even if they actually lie within one of the receiver’s subviews. 
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
        
//        self.backgroundColor = [UIColor grayColor];
        
        /* Create portrait image view and add to view hierarchy. */
        self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kHoriMargin, kVertMargin, kPortraitWidth, kPortraitHeight)];
//        self.portraitImageView.image = [UIImage imageNamed:@"Pin"];
        [self addSubview:self.portraitImageView];
        
        /* Create name label. */
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitWidth + kHoriMargin,
                                                                   kVertMargin,
                                                                   kWidth - kPortraitWidth - kHoriMargin,
                                                                   kHeight - 2 * kVertMargin)];
        self.nameLabel.backgroundColor  = [UIColor clearColor];
        self.nameLabel.textAlignment    = NSTextAlignmentCenter;
        self.nameLabel.textColor        = [UIColor whiteColor];
        self.nameLabel.font             = [UIFont systemFontOfSize:15.f];
        [self addSubview:self.nameLabel];
    }
    
    return self;
}

@end
