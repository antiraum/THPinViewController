//
//  THPinInputCirclesView.h
//  THPinViewControllerExample
//
//  Created by Thomas Heß on 20.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

typedef void (^THPinInputCirclesViewShakeCompletionBlock)(void);

@interface THPinInputCirclesView : UIView

@property (nonatomic, assign) NSUInteger pinLength;

- (instancetype)initWithPinLength:(NSUInteger)pinLength NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithFrame:(CGRect)frame __attribute__((unavailable("Use -initWithPinLength: instead")));
- (instancetype)initWithCoder:(NSCoder *)aDecoder __attribute__((unavailable("Use -initWithPinLength: instead")));

- (void)fillCircleAtPosition:(NSUInteger)position;
- (void)unfillCircleAtPosition:(NSUInteger)position;
- (void)unfillAllCircles;
- (void)shakeWithCompletion:(__nullable THPinInputCirclesViewShakeCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
