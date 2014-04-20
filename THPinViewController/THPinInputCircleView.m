//
//  THPinInputCircleView.m
//  THPinViewController
//
//  Created by Thomas Heß on 14.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

#import "THPinInputCircleView.h"

@implementation THPinInputCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.cornerRadius = [self.class diameter] / 2.0f;
        self.layer.borderWidth = 1.0f;
        
        [self tintColorDidChange];
    }
    return self;
}

- (void)tintColorDidChange
{
    self.layer.borderColor = [self.tintColor CGColor];
}

- (void)setFilled:(BOOL)filled
{
    self.backgroundColor = (filled) ? self.tintColor : [UIColor whiteColor];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(12.0f, 12.0f);
}

+ (CGFloat)diameter
{
    return 12.0f;
}

@end
