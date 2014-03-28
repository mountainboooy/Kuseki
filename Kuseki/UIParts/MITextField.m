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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _showsAccessoryView = NO;
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
    if (!_showsAccessoryView) {
        return nil;
    }
    
    if (!_inputAccessoryView) {
        
        //baseView
        _inputAccessoryView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width , 44)];
        _inputAccessoryView.backgroundColor = [UIColor colorWithRed:0.4 green:0.38 blue:0.36 alpha:0.8];
        
        //button_close
        UIButton *bt_close = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        bt_close.frame = CGRectMake(120, 8, 56, 28);
        [bt_close setTitle:@"閉じる" forState:UIControlStateNormal];
        [bt_close setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bt_close addTarget:self action:@selector(btClosePressed) forControlEvents:UIControlEventTouchUpInside];
        
        [_inputAccessoryView addSubview:bt_close];
        
        
        //button_back
        UIButton *bt_back = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        bt_back.frame = CGRectMake(10, 8, 56, 28);
        [bt_back setTitle:@"戻る" forState:UIControlStateNormal];
        [bt_back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bt_back addTarget:self action:@selector(btBackPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [_inputAccessoryView addSubview:bt_back];
        
        //button_next
        UIButton *bt_next = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        bt_next.frame = CGRectMake(255, 8, 56, 28);
        [bt_next setTitle:@"次へ" forState:UIControlStateNormal];
        [bt_next setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bt_next addTarget:self action:@selector(btNextPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [_inputAccessoryView addSubview:bt_next];
        
        
    }
    return _inputAccessoryView;
}


- (void)btClosePressed
{
    [self resignFirstResponder];
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
