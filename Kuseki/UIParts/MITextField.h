//
//  MITextField.h
//  minne
//
//  Created by Takeru Yoshihara on 2013/12/13.
//
//

#import <UIKit/UIKit.h>

@protocol MITextFieldDelegate;
@interface MITextField : UITextField

@property(nonatomic,strong) NSIndexPath *indexPath;
@property BOOL showsAccessoryView;
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
