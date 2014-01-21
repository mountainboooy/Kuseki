//
//  InputViewController.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/16.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "InputViewController.h"
#import "MITextField.h"
#import "KUSearchParamManager.h"
#import "ResultsViewController.h"

@interface InputViewController ()
<UITableViewDataSource, UITableViewDelegate,
UIPickerViewDataSource, UIPickerViewDelegate,
UITextFieldDelegate>
{
    //outlet
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UIPickerView *_pickerView;
    
    //constraint
    __weak IBOutlet NSLayoutConstraint *_bottomSpace_picker_train;
    
    //modell
    KUSearchParamManager *_paramManager;
}


@end

@implementation InputViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //tableView
    _tableView.delegate = self;
    _tableView.dataSource  = self;
    
    //pickerView
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    //notification
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
    //model
    _paramManager = [KUSearchParamManager sharedManager];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSString *identifier = [NSString stringWithFormat:@"cell%d",indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    [self updateCell:cell atIndexPath:indexPath];
    
    return cell;
    
}

- (void)updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    switch(indexPath.row){
        case 0:{
            MITextField  *tf_month = (MITextField*)[cell viewWithTag:1];
            MITextField  *tf_date  = (MITextField*)[cell viewWithTag:2];
            tf_month.showsAccessoryView = YES;
            tf_date.showsAccessoryView = YES;
            break;
        }
        
        case 1:{
            MITextField  *tf_hour = (MITextField*)[cell viewWithTag:1];
            MITextField  *tf_minute  = (MITextField*)[cell viewWithTag:2];
            tf_hour.showsAccessoryView = YES;
            tf_minute.showsAccessoryView= YES;
            break;
        }
        
        case 2:{
            MITextField *tf_train = (MITextField*)[cell viewWithTag:1];
            break;
        }
       
        case 3:{
            MITextField *tf_dep_stn = (MITextField*)[cell viewWithTag:1];
            break;
        }
            
        case 4:{
            MITextField *tf_arr_stn = (MITextField*)[cell viewWithTag:1];
            break;
        }
        case 5:{
            UIButton *bt_search = (UIButton*)[cell viewWithTag:1];
            [bt_search addTarget:self action:@selector(btSearchPressed) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 2){
        //ピッカーを操作
        [self showPickerTrain];
    }
    
    [self.view endEditing:YES];
    
}


#pragma mark -
#pragma mark picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 5;
}


- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    
    switch(row){
        case 0:{
            title = @"のぞみ・ひかり・さくら・みずほ・つばめ";
            break;
        }
        case 1:{
            title = @"こだま";
            break;
        }
            
        case 2:{
            title = @"はやぶさ・はやて・やまびこ・なすの・つばさ・こまち";
            break;
        }
            
        case 3:{
            title = @"とき・たにがわ・あさま";
            break;
        }
            
        case 4:{
            title = @"在来線列車";
            break;
        }
    }
    
    return title;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSString *selectedNum = [NSString stringWithFormat:@"%d",row+1];
    _paramManager.train = selectedNum;
    
    [self hidePickerTrain];
}


#pragma mark -
#pragma mark textField
- (void)textFieldDidEndEditing:(MITextField *)textField
{
    switch(textField.indexPath.row){
        
        case 0:{//乗車年月日
            if(textField.tag == 1){//month
                _paramManager.month = textField.text;
            
            }else{//date
                _paramManager.date = textField.text;
            }
            
            break;
        }
           
        case 1:{//時間
            if(textField.tag == 1){//hour
                _paramManager.hour  = textField.text;
                
            }else{//minute
                _paramManager.minute = textField.text;
            }
            break;
        }
            
        case 3:{//dep_stn
            _paramManager.dep_stn = textField.text;
            break;
        }
            
        case 4:{//arr_strn
            _paramManager.arr_stn = textField.text;
            break;
        }
            
        default:
            break;
    }
}



#pragma mark -
#pragma mark private action

- (void)btSearchPressed
{
    ResultsViewController *resultCon = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultsViewController"];
    [self.navigationController pushViewController:resultCon animated:YES];
}


- (void)showPickerTrain
{
    [UIView animateWithDuration:0.3 animations:^{
        _bottomSpace_picker_train.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

- (void)hidePickerTrain
{
    [UIView animateWithDuration:0.3 animations:^{
        _bottomSpace_picker_train.constant = -216;
        [self.view  layoutIfNeeded];
    }];
}

- (void)keyboardWillAppear:(NSNotification*)notification
{
    _tableView.contentInset = UIEdgeInsetsMake(64, 0, 60, 0);
}


- (void)keyboardWillDisappear:(NSNotification*)notification
{
    _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}

/*
 #import "ViewController.h"
 #import "AFNetworking.h"
 
 @interface ViewController ()
 <UIWebViewDelegate>
 {
 __weak IBOutlet UIWebView *_webView;
 NSMutableData *_data;
 
 int _num;
 
 }
 
 @end
 
 @implementation ViewController
 
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 // Do any additional setup after loading the view, typically from a nib.
 
 //param
 NSDictionary *param;
 param = @{@"month": @"01",
 @"day":@"30",
 @"hour":@"13",
 @"minute":@"30",
 @"train":@"5",
 @"dep_stn":@"新大阪",
 @"arr_stn":@"東京"};
 
 NSString *param_str = @"month=01&day=30&hour=13&minute=30&train=1&dep_stn=%8b%9e%93s&arr_stn=%93%8c%8b%9e";
 
 //request
 
 NSURL *url = [NSURL URLWithString:@"http://www1.jr.cyberstation.ne.jp/csws/Vacancy.do"];
 NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
 [req setHTTPMethod:@"POST"];
 [req setHTTPBody:[param_str dataUsingEncoding:NSUTF8StringEncoding]];
 [req setValue:@"http://www.jr.cyberstation.ne.jp/vacancy/Vacancy.html" forHTTPHeaderField:@"Referer"];
 
 
 //webViewに表示してみる
 _webView.delegate = self;
 [_webView loadRequest:req];
 
 
 _num = 0;
 
 NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(testBackGround) userInfo:nil repeats:YES];
 [timer fire];
 
 
 
 
 }
 
 - (void)testBackGround
 {
 //バックグラウンドでwebへの定期的な接続を試みる
 NSString *url_str = @"http://yahoo.co.jp";
 NSURL *url = [NSURL URLWithString:url_str];
 NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
 
 AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc]initWithRequest:req];
 [op setCompletionBlock:^{
 NSLog(@"num:%d",_num);
 _num += 1;
 }];
 
 [op start];
 
 
 }
 
 - (void)didReceiveMemoryWarning
 {
 [super didReceiveMemoryWarning];
 // Dispose of any resources that can be recreated.
 }
 
 
 - (void)webViewDidFinishLoad:(UIWebView *)webView
 {
 NSString *body  = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
 NSLog(@"innerHTML=%@",body);
 }
 
 - (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
 {
 
 NSString *html = [[NSString alloc]initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
 NSLog(@"html2:%@",html);
 return YES;
 }
*/

@end
