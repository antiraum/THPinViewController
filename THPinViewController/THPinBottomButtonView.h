
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, THPinBottomButtonState) {
    THPinBottomButtonStateNone,
    THPinBottomButtonStateCancel,
    THPinBottomButtonStateDelete
};

@interface THPinBottomButtonView : UIView
@property (nonatomic) THPinBottomButtonState state;
@property (nonatomic) BOOL disableCancel;
@property (nonatomic, strong, readonly) UIButton *deleteButton;
@property (nonatomic, strong, readonly) UIButton *cancelButton;
@end
