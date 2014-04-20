//
//  THPinNumPadView.m
//  THPinViewControllerExample
//
//  Created by Thomas Heß on 20.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

#import "THPinNumPadView.h"
#import "THPinCircleButton.h"

@interface THPinNumPadView ()

@property (nonatomic, assign) CGFloat hPadding;
@property (nonatomic, assign) CGFloat vPadding;

@end

@implementation THPinNumPadView

- (instancetype)initWithDelegate:(id<THPinNumPadViewDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.delegate = delegate;
        
        self.hPadding = 20.0f;
        self.vPadding = 12.5f;
        
        CGFloat x = 0.0f;
        CGFloat y = 0.0f;
        for (NSUInteger i = 1; i < 10; i++) {
            CGRect frame = CGRectMake(x, y, [THPinCircleButton diameter], [THPinCircleButton diameter]);
            NSString *letters = nil;
            switch (i) {
                case 1:
                    letters = @" "; // empty string to trigger shifted number position
                    break;
                case 2:
                    letters = @"ABC";
                    break;
                case 3:
                    letters = @"DEF";
                    break;
                case 4:
                    letters = @"GHI";
                    break;
                case 5:
                    letters = @"JKL";
                    break;
                case 6:
                    letters = @"MNO";
                    break;
                case 7:
                    letters = @"PQRS";
                    break;
                case 8:
                    letters = @"TUV";
                    break;
                case 9:
                    letters = @"WXYZ";
                    break;
            }
            THPinCircleButton *btn = [[THPinCircleButton alloc] initWithFrame:frame number:i letters:letters];
            [btn addTarget:self action:@selector(numberButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            if (i % 3) {
                x += [THPinCircleButton diameter] + self.hPadding;
            } else {
                x = 0.0f;
                y += [THPinCircleButton diameter] + self.vPadding;
            }
        }
        CGRect frame = CGRectMake([THPinCircleButton diameter] + self.hPadding, y,
                                  [THPinCircleButton diameter], [THPinCircleButton diameter]);
        THPinCircleButton *btn = [[THPinCircleButton alloc] initWithFrame:frame number:0 letters:nil];
        [btn addTarget:self action:@selector(numberButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(3.0f * [THPinCircleButton diameter] + 2.0f * self.hPadding,
                      4.0f * [THPinCircleButton diameter] + 3.0f * self.vPadding);
}

- (void)numberButtonTapped:(id)sender
{
    [self.delegate pinNumPadView:self numberTapped:[(THPinCircleButton *)sender number]];
}

@end
