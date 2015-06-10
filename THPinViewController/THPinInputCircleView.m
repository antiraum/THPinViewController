//
//  THPinInputCircleView.m
//  THPinViewController
//
//  Created by Thomas Heß on 14.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

#import "THPinInputCircleView.h"

@implementation THPinInputCircleView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.layer.cornerRadius = [[self class] diameter] / 2.0f;
        self.layer.borderWidth = 1.0f;
        
        [self tintColorDidChange];
    }
    return self;
}

- (void)tintColorDidChange
{
    self.layer.borderColor = self.tintColor.CGColor;
}

- (void)setFilled:(BOOL)filled
{
    self.backgroundColor = (filled) ? self.tintColor : [UIColor clearColor];
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake([[self class] diameter], [[self class] diameter]);
}

+ (CGFloat)diameter
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 16.0f : 12.5f;
}

@end
