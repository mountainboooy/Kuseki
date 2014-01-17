//
//  MITextField.h
//  minne
//
//  Created by Takeru Yoshihara on 2013/12/13.
//
//

#import <UIKit/UIKit.h>

@interface MITextField : UITextField

@property(nonatomic,strong) NSIndexPath *indexPath;
@property BOOL showsAccessoryView;

- (BOOL)validateForVariety;
- (BOOL)validateForMinimumLength:(NSInteger)length;
- (BOOL)includeNumbers;
- (BOOL)includeAlphabet;
- (BOOL)includeSymbols;



@end
