//
//  MITextField.m
//  minne
//
//  Created by Takeru Yoshihara on 2013/12/13.
//
//

#import "MITextField.h"

@interface MITextField ()
{
    UIView *_inputAccessoryView;
}
@end

@implementation MITextField
@dynamic delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _accessory_mode = ACCESSORY_NONE;
    }
    return self;
}

- (BOOL)validateForVariety
{
    if ([self includeAlphabet] && [self includeNumbers]) {
        return YES;
    }
    
    if ([self includeAlphabet] && [self includeSymbols]) {
        return YES;
    }
    
    if ([self includeNumbers] && [self includeSymbols]) {
        return YES;
    }
    
    if ([self includeAlphabet] && [self includeNumbers] && [self includeSymbols]) {
        return YES;
    }
    
    return NO;
    
}


- (BOOL)validateForMinimumLength:(NSInteger)lentgh
{
    if (self.text.length < lentgh) {
        return NO;
    }
    
    return YES;
}


- (BOOL)includeNumbers
{
    NSString *pattern = @"[0-9]";
    NSRange range = [self.text rangeOfString:pattern options:NSRegularExpressionSearch];
    
    if (range.location == NSNotFound) {
        return NO;
    }
    
    return YES;
    
}


- (BOOL)includeAlphabet
{
    NSString *pattern = @"[a-z]|[A-Z]";
    NSRange range = [self.text rangeOfString:pattern options:NSRegularExpressionSearch];
    
    if (range.location == NSNotFound) {
        return NO;
    }
    return YES;
}


- (BOOL)includeSymbols
{
    //nsstringと正規表現の両方に対するエスケープが必要なため\がダブっいる
    NSString *pattern = @"[\\!-\\/]|[\\:-\\@]|[\\[-\\`]|[\\{-\\~]";
    NSRange range = [self.text rangeOfString:pattern options:NSRegularExpressionSearch];
    
    if (range.location == NSNotFound) {
        return NO;
    }
    
    return YES;
}


- (UIView*)inputAccessoryView
{
    if (_accessory_mode == ACCESSORY_NONE) {
        return nil;
    }
    
    if (!_inputAccessoryView) {
        
        //baseView
        _inputAccessoryView = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width , 44)];
        _inputAccessoryView.backgroundColor = [UIColor colorWithRed:0.4 green:0.38 blue:0.36 alpha:0.8];
        
        //button_close
        UIButton *bt_close = [UIButton buttonWithType:UIButtonTypeCustom];
        bt_close.frame = CGRectMake(0, 0, 80, 44);
        [bt_close setImage:[UIImage imageNamed:@"bt_close_picker"] forState:UIControlStateNormal];
        [bt_close addTarget:self action:@selector(btClosePressed) forControlEvents:UIControlEventTouchUpInside];
        
        [_inputAccessoryView addSubview:bt_close];
    }
    return _inputAccessoryView;
}


- (void)btClosePressed
{
    [self resignFirstResponder];
    [self.delegate textFieldDidPressCloseBt:self];
}


-(void)btNextPressed
{
    [self.delegate textFieldDidPressNextBt:self];
}


- (void)btBackPressed
{
    [self.delegate textFieldDidPressBackBt:self];
}
@end
