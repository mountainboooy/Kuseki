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
    
    NSArray *_trains;
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
    
    
    _trains = @[@"のぞみ・ひかり・さくら・みずほ・つばめ",
                        @"こだま",
                        @"はやぶさ・はやて・やまびこ・なすの・つばさ・こまち",
                        @"とき・たにがわ・あさま",
                        @"在来線列車"];
    
    
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

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
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
            tf_month.delegate = self;
            tf_month.indexPath  = indexPath;
           
            tf_date.showsAccessoryView = YES;
            tf_date.delegate = self;
            tf_date.indexPath  = indexPath;
            
            break;
        }
        
        case 1:{
            MITextField  *tf_hour = (MITextField*)[cell viewWithTag:1];
            MITextField  *tf_minute  = (MITextField*)[cell viewWithTag:2];
            
            tf_hour.showsAccessoryView = YES;
            tf_hour.delegate = self;
            tf_hour.indexPath = indexPath;
            
            tf_minute.showsAccessoryView= YES;
            tf_minute.delegate = self;
            tf_minute.indexPath  =  indexPath;
            
            
            break;
        }
        
        case 2:{
            MITextField *tf_train = (MITextField*)[cell viewWithTag:1];
            tf_train.text = _trains[_paramManager.train.intValue - 1];
            break;
        }
       
        case 3:{
            MITextField *tf_dep_stn = (MITextField*)[cell viewWithTag:1];
            tf_dep_stn.text = _paramManager.dep_stn;
            tf_dep_stn.delegate = self;
            tf_dep_stn.indexPath = indexPath;
            break;
        }
            
        case 4:{
            MITextField *tf_arr_stn = (MITextField*)[cell viewWithTag:1];
            tf_arr_stn.text = _paramManager.arr_stn;
            tf_arr_stn.delegate  = self;
            tf_arr_stn.indexPath = indexPath;
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
            title = _trains[0];
            break;
        }
        case 1:{
            title = _trains[1];
            break;
        }
            
        case 2:{
            title = _trains[2];
            break;
        }
            
        case 3:{
            title = _trains[3];
            break;
        }
            
        case 4:{
            title = _trains[4];
            break;
        }
    }
    
    return title;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSString *selectedNum = [NSString stringWithFormat:@"%d",(int)row+1];
    _paramManager.train = selectedNum;
    
    //テーブル更新
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    [self updateCell:cell atIndexPath:indexPath];
    
    [self hidePickerTrain];
}


#pragma mark -
#pragma mark textField
- (void)textFieldDidEndEditing:(MITextField *)textField
{
    
    NSLog(@"indexPath.row:%d",(int)textField.indexPath.row);
    switch(textField.indexPath.row){
        
        case 0:{//乗車年月日
            if(textField.tag == 1){//month
                _paramManager.month = textField.text;
            
            }else{//date
                _paramManager.day = textField.text;
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
    
    //テーブル更新
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:textField.indexPath];
    [self updateCell:cell atIndexPath:textField.indexPath];

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



@end
