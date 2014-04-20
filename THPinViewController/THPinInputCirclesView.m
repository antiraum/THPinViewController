//
//  THPinInputCirclesView.m
//  THPinViewControllerExample
//
//  Created by Thomas Heß on 20.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

#import "THPinInputCirclesView.h"
#import "THPinInputCircleView.h"

@interface THPinInputCirclesView ()

@property (nonatomic, strong) NSMutableArray *inputCircleViews;

@property (nonatomic, assign) NSUInteger numShakes;
@property (nonatomic, assign) NSInteger shakeDirection;
@property (nonatomic, assign) CGFloat shakeAmplitude;
@property (nonatomic, strong) THPinInputCirclesViewShakeCompletionBlock shakeCompletionBlock;

@end

@implementation THPinInputCirclesView

- (instancetype)initWithPinLength:(NSUInteger)pinLength
{
    self = [super init];
    if (self)
    {
        self.pinLength = pinLength;
        
        self.inputCircleViews = [NSMutableArray array];
        for (NSUInteger i = 0; i < 4; i++) {
            CGRect frame = CGRectMake(i * 3.0f * [THPinInputCircleView diameter], 0.0f,
                                      [THPinInputCircleView diameter], [THPinInputCircleView diameter]);
            THPinInputCircleView* circleView = [[THPinInputCircleView alloc] initWithFrame:frame];
            [self addSubview:circleView];
            [self.inputCircleViews addObject:circleView];
        }
    }
    return self;
}

- (CGSize)intrinsicContentSize
{
    CGFloat width = [THPinInputCircleView diameter] * self.pinLength;
    width += 2.0f * [THPinInputCircleView diameter] * (self.pinLength - 1); // double diameter padding between circles
    return CGSizeMake(width, [THPinInputCircleView diameter]);
}

- (void)fillCircleAtPosition:(NSUInteger)position
{
    NSParameterAssert(position < [self.inputCircleViews count]);
    [self.inputCircleViews[position] setFilled:YES];
}

- (void)unfillCircleAtPosition:(NSUInteger)position
{
    NSParameterAssert(position < [self.inputCircleViews count]);
    [self.inputCircleViews[position] setFilled:NO];
}

- (void)unfillAllCircles
{
    for (THPinInputCircleView *view in self.inputCircleViews) {
        view.filled = NO;
    }
}

#define TOTAL_NUM_SHAKES 6
#define INITIAL_SHAKE_AMPLITUDE 40.0f

- (void)shakeWithCompletion:(THPinInputCirclesViewShakeCompletionBlock)completion
{
    self.numShakes = 0;
    self.shakeDirection = -1;
    self.shakeAmplitude = INITIAL_SHAKE_AMPLITUDE;
    self.shakeCompletionBlock = completion;
    [self performShake];
}

- (void)performShake
{
    [UIView animateWithDuration:0.03f animations:^ {
        self.transform = CGAffineTransformMakeTranslation(self.shakeDirection * self.shakeAmplitude, 0.0f);
    } completion:^(BOOL finished) {
        if (self.numShakes < TOTAL_NUM_SHAKES)
        {
            self.numShakes++;
            self.shakeDirection = -1 * self.shakeDirection;
            self.shakeAmplitude = (TOTAL_NUM_SHAKES - self.numShakes) * (INITIAL_SHAKE_AMPLITUDE / TOTAL_NUM_SHAKES);
            [self performShake];
            
        } else {
            
            self.transform = CGAffineTransformIdentity;
            if (self.shakeCompletionBlock) {
                self.shakeCompletionBlock();
                self.shakeCompletionBlock = nil;
            }
        }
    }];
}

@end
