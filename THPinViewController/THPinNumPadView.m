//
//  THPinNumPadView.m
//  THPinViewControllerExample
//
//  Created by Thomas Heß on 20.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

#import "THPinNumPadView.h"
#import "THPinNumButton.h"

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
            CGRect frame = CGRectMake(x, y, [THPinNumButton diameter], [THPinNumButton diameter]);
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
            THPinNumButton *btn = [[THPinNumButton alloc] initWithFrame:frame number:i letters:letters];
            [btn addTarget:self action:@selector(numberButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            if (i % 3) {
                x += [THPinNumButton diameter] + self.hPadding;
            } else {
                x = 0.0f;
                y += [THPinNumButton diameter] + self.vPadding;
            }
        }
        CGRect frame = CGRectMake([THPinNumButton diameter] + self.hPadding, y,
                                  [THPinNumButton diameter], [THPinNumButton diameter]);
        THPinNumButton *btn = [[THPinNumButton alloc] initWithFrame:frame number:0 letters:nil];
        [btn addTarget:self action:@selector(numberButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(3.0f * [THPinNumButton diameter] + 2.0f * self.hPadding,
                      4.0f * [THPinNumButton diameter] + 3.0f * self.vPadding);
}

- (void)numberButtonTapped:(id)sender
{
    [self.delegate pinNumPadView:self numberTapped:[(THPinNumButton *)sender number]];
}

@end
