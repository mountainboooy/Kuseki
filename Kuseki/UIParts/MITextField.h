//
//  MITextField.h
//  minne
//
//  Created by Takeru Yoshihara on 2013/12/13.
//
//

#import <UIKit/UIKit.h>
enum AccessoryMode {ACCESSORY_ALL, ACCESSORY_NEXT_CLOSE, ACCESSORY_NONE};

@protocol MITextFieldDelegate;
@interface MITextField : UITextField

@property(nonatomic,strong) NSIndexPath *indexPath;
@property enum AccessoryMode accessory_mode;
@property (nonatomic,weak) id delegate;

- (BOOL)validateForVariety;
- (BOOL)validateForMinimumLength:(NSInteger)length;
- (BOOL)includeNumbers;
- (BOOL)includeAlphabet;
- (BOOL)includeSymbols;

@end

@protocol MITextFieldDelegate <NSObject>

- (void)textFieldDidPressNextBt:(MITextField*)textField;
- (void)textFieldDidPressBackBt:(MITextField*)textField;

@end
