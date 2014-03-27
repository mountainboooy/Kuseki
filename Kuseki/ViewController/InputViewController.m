//
//  InputViewController.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/16.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "InputViewController.h"
#import "MITextField.h"
#import "ResultsViewController.h"
#import "KUSearchCondition.h"
#import "KUStationsManager.h"

@interface InputViewController ()
<UITableViewDataSource, UITableViewDelegate,
UIPickerViewDataSource, UIPickerViewDelegate,
UITextFieldDelegate>
{
    //outlet
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UIPickerView *_picker_train;
    __weak IBOutlet UIPickerView *_picker_dep;
    __weak IBOutlet UIPickerView *_picker_arr;
    __weak IBOutlet UIButton *_btClose_train;
    __weak IBOutlet UIButton *_btClose_dep;
    __weak IBOutlet UIButton *_btClose_arr;
    __weak IBOutlet UIButton *_btNext_dep;
    __weak IBOutlet UIButton *_btSearch_arr;
    
    //constraint
    __weak IBOutlet NSLayoutConstraint *_bottomSpace_picker_train;
    __weak IBOutlet NSLayoutConstraint *_bottomSpace_picker_dep;
    __weak IBOutlet NSLayoutConstraint *_bottomSpace_picker_arr;
    
    //model
    KUSearchCondition *_condition;
    
    //other
    NSArray *_trains;
    NSArray *_stations;
    NSInteger _selected_index;

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
    _picker_train.delegate = self;
    _picker_train.dataSource = self;
    
    _picker_dep.delegate = self;
    _picker_arr.delegate = self;
    
    _picker_dep.dataSource = self;
    _picker_arr.dataSource = self;
    
    //notification
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
    //検索条件の初期化
    [self initCondition];
    
    
    _trains = @[@"のぞみ・ひかり・さくら・みずほ・つばめ",
                        @"こだま",
                        @"はやぶさ・はやて・やまびこ・なすの・つばさ・こまち",
                        @"とき・たにがわ・あさま",
                        @"在来線列車"];
    
    //stations
    [self updateStations];
    
    //button_close
    [_btClose_train addTarget:self action:@selector(hidePickerTrain) forControlEvents:UIControlEventTouchUpInside];
    [_btClose_dep addTarget:self action:@selector(hidePickerDep) forControlEvents:UIControlEventTouchUpInside];
    [_btClose_arr addTarget:self action:@selector(hidePickerArr) forControlEvents:UIControlEventTouchUpInside];
    
    //button_next
    [_btNext_dep addTarget:self action:@selector(btNextDepPressed) forControlEvents:UIControlEventTouchUpInside];
    [_btSearch_arr addTarget:self action:@selector(btSearchArrPressed) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTitle];
}


- (void)viewDidAppear:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    MITextField *tf = (MITextField*)[cell viewWithTag:1];
    //[tf becomeFirstResponder];
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
    return 5;
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
    //選択色用のビュー
    UIView *focus_view = (UIView*)[cell viewWithTag:9];

    switch(indexPath.row){
        case 0:{//乗車日
            MITextField  *tf_month = (MITextField*)[cell viewWithTag:1];
            MITextField  *tf_day  = (MITextField*)[cell viewWithTag:2];
            
            tf_month.showsAccessoryView = YES;
            tf_month.delegate = self;
            tf_month.indexPath  = indexPath;
            tf_month.text = _condition.month;
           
            tf_day.showsAccessoryView = YES;
            tf_day.delegate = self;
            tf_day.indexPath  = indexPath;
            tf_day.text = _condition.day;
            
            //選択色
            focus_view.alpha = (indexPath.row == _selected_index)? 0.2 : 0;
            
            break;
        }
        
        case 1:{//乗車時間
            MITextField  *tf_hour = (MITextField*)[cell viewWithTag:1];
            MITextField  *tf_minute  = (MITextField*)[cell viewWithTag:2];
            
            tf_hour.showsAccessoryView = YES;
            tf_hour.delegate = self;
            tf_hour.indexPath = indexPath;
            tf_hour.text = _condition.hour;
            
            tf_minute.showsAccessoryView= YES;
            tf_minute.delegate = self;
            tf_minute.indexPath  =  indexPath;
            tf_minute.text = _condition.minute;
            
            //選択色
            focus_view.alpha = (indexPath.row == _selected_index)? 0.2 : 0;
            
            break;
        }
        
        case 2:{//列車の種類
            MITextField *tf_train = (MITextField*)[cell viewWithTag:1];
            tf_train.text = _trains[_condition.train.intValue - 1];
            
            //選択色
            focus_view.alpha = (indexPath.row == _selected_index)? 0.2 : 0;
            
            break;
        }
       
        case 3:{//乗車駅・降車駅
            MITextField *tf_dep_stn = (MITextField*)[cell viewWithTag:1];
            tf_dep_stn.text = _condition.dep_stn;
            tf_dep_stn.delegate = self;
            tf_dep_stn.indexPath = indexPath;
            
            MITextField *tf_arr_stn = (MITextField*)[cell viewWithTag:2];
            tf_arr_stn.text = _condition.arr_stn;
            tf_arr_stn.delegate  = self;
            tf_arr_stn.indexPath = indexPath;
            
            //button
            UIButton *bt_dep = (UIButton*)[cell viewWithTag:3];
            UIButton *bt_arr = (UIButton*)[cell viewWithTag:4];
            [bt_dep addTarget:self action:@selector(btDepPressed) forControlEvents:UIControlEventTouchUpInside];
            [bt_arr addTarget:self action:@selector(btArrPressed) forControlEvents:UIControlEventTouchUpInside];
            
            //選択色
            //乗車駅・降車駅のそれぞれで位置をずらして表示
            if (_selected_index == 3) {//乗車駅
                focus_view.alpha = 0.2;
                focus_view.frame = CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height/2);
            
            }else if(_selected_index == 4){//降車駅
                focus_view.alpha = 0.2;
                focus_view.frame = CGRectMake(0, cell.bounds.size.height/2, cell.bounds.size.width, cell.bounds.size.height/2);
            
            }else{
                focus_view.alpha = 0;
            }
            
            break;
        }

        case 4:{
            UIButton *bt_search = (UIButton*)[cell viewWithTag:1];
            [bt_search addTarget:self action:@selector(btSearchPressed) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
    }
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    
    switch (indexPath.row) {
        case 0:
        case 1:
        case 2:
            height = 89;
            break;
            
        case 3:
            height = 178;
            break;
            
        case 4:
            height = 183;
            break;
    }
    return height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    //cell取得
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:{//乗車日
            [self hidePickerArr];
            [self hidePickerTrain];
            
            //text field
            UITextField *tf_month = (UITextField*)[cell viewWithTag:1];
            [tf_month becomeFirstResponder];
            
            break;
        }
            
        case 1:{//乗車時間
            [self hidePickerArr];
            [self hidePickerTrain];
            
            //text field
            UITextField *tf_hour = (UITextField*)[cell viewWithTag:1];
            [tf_hour becomeFirstResponder];
            break;
        }
            
        case 2:{//列車の種類
            [self hidePickerArr];
            [self hidePickerDep];
            [self showPickerTrain];
            break;
        }
            
        case 3:{//乗車駅・降車駅
            //タップする場所によって分ける必要があるため、ボタンで処理
            break;
        }

        default:{
            [self hidePickerArr];
            [self hidePickerDep];
            [self hidePickerTrain];
        }
    }
}


#pragma mark -
#pragma mark picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case 1://train
            return 5;
            break;
            
            case 2://dep_stn
            return _stations.count;
            
            case 3://arr_stn
            return _stations.count;
            
        default:
            break;
    }
    
    return 0;
    
}


- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    
    if (pickerView.tag == 1) {//train
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
    }
    
    else{//stations
        title = _stations[row];
    }
    
    
    
    return title;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 1) {//train
        
        NSString *selectedNum = [NSString stringWithFormat:@"%d",(int)row+1];
        _condition.train = selectedNum;
        
        [self updateStations];
        
        //dep_stnのピッカーを表示
        [self hidePickerTrain];
        [self showPickerDep];
        
    }
    
    else if(pickerView.tag == 2){//dep_stn
        _condition.dep_stn = _stations[row];
    }
    
    else{//arr_stn
        _condition.arr_stn = _stations[row];
    }
    
    //テーブル更新
    [_tableView reloadData];


}


#pragma mark -
#pragma mark textField

- (void)textFieldDidBeginEditing:(MITextField *)textField
{
    //選択色表示
    [self setFocusColorWithSelectedIndex:textField.indexPath.row];
    
    [self hidePickerTrain];
    [self hidePickerDep];
    [self hidePickerArr];
    textField.placeholder = textField.text;
    textField.text = @"";
    
    //テーブルをスクロール
    [_tableView scrollToRowAtIndexPath:textField.indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)textFieldDidEndEditing:(MITextField *)textField
{
    
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:textField.indexPath];

    //textFieldが空の場合は元の値に戻す
    if ([textField.text isEqualToString:@""]) {
        [self updateCell:cell atIndexPath:textField.indexPath];
        return;
    }
    
    NSLog(@"indexPath.row:%d",(int)textField.indexPath.row);
    switch(textField.indexPath.row){
        
        case 0:{//乗車年月日
            if(textField.tag == 1){//month
                _condition.month = textField.text;
            
            }else{//date
                _condition.day = textField.text;
            }
            
            break;
        }
           
        case 1:{//時間
            if(textField.tag == 1){//hour
                _condition.hour  = textField.text;
                
            }else{//minute
                _condition.minute = textField.text;
            }
            break;
        }
            
        case 3:{//dep_stn
            _condition.dep_stn = textField.text;
            break;
        }
            
        case 4:{//arr_strn
            _condition.arr_stn = textField.text;
            break;
        }
            
        default:
            break;
    }
    
    //テーブル更新
    [self updateCell:cell atIndexPath:textField.indexPath];

}


- (BOOL)textField:(MITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    NSMutableString *text   = [textField.text mutableCopy];
    [text replaceCharactersInRange:range withString:string];
    NSIndexPath *nextPath;
    UITableViewCell *nextCell;
    MITextField  *nextField;
    
    /*
    //バリデーション
    if ([self textIsInvalid:]) {
        NSString *message = @"入力内容が正しくありません";
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [al show];
        return NO;
    }*/

    
    switch (textField.indexPath.row) {
        case 0:{//乗車月日
            if (textField.tag == 1) {//月
                if (text.length == 2) {//日に移動
                    nextPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    nextCell = [_tableView cellForRowAtIndexPath:nextPath];
                    nextField = (MITextField*)[nextCell viewWithTag:2];
                    [self performSelector:@selector(focusNextField:) withObject:nextField afterDelay:0.1];
                    return YES;
                }
                
            }else{//日
                if (text.length == 2) {//時に移動
                    nextPath = [NSIndexPath indexPathForRow:1 inSection:0];
                    nextCell = [_tableView cellForRowAtIndexPath:nextPath];
                    nextField = (MITextField*)[nextCell viewWithTag:1];
                    [self performSelector:@selector(focusNextField:) withObject:nextField afterDelay:0.1];
                    return YES;
                }
                
                break;
            }
            
        case 1:{//時間
            if (textField.tag == 1) {//時
                if (text.length == 2) {//分に移動
                    nextPath = [NSIndexPath indexPathForRow:1 inSection:0];
                    nextCell = [_tableView cellForRowAtIndexPath:nextPath];
                    nextField = (MITextField*)[nextCell viewWithTag:2];
                    [self performSelector:@selector(focusNextField:) withObject:nextField afterDelay:0.1];
                    return YES;
                }
                
            }else{//分
                if (text.length == 2) {//お乗りになる列車を表示
                    [self performSelector:@selector(showPickerTrain) withObject:nil afterDelay:0.1];
                    return YES;
                }
            }
            break;
            
        default:
            break;
        }
            return YES;
        }
    }
    return YES;
}

- (void)focusNextField:(MITextField*)nextField
{
    [nextField becomeFirstResponder];
}



#pragma mark -
#pragma mark private methods

- (void)initCondition
{
    //現在の日時を取得
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit |
                                   NSMonthCalendarUnit |
                                   NSDayCalendarUnit |
                                   NSHourCalendarUnit |
                                   NSMinuteCalendarUnit
                                              fromDate:date];
    
    
    NSDictionary *dic = @{@"month"  :[NSString stringWithFormat:@"%02d",dateComps.month],
                          @"day"    :[NSString stringWithFormat:@"%02d",dateComps.day],
                          @"hour"   :[NSString stringWithFormat:@"%02d",dateComps.hour],
                          @"minute" :[NSString stringWithFormat:@"%02d",dateComps.minute],
                          @"train"  :@"1",
                          @"dep_stn":@"東京",
                          @"arr_stn":@"新大阪"
                          };
    _condition = [[KUSearchCondition alloc]initWithDictionary:dic];
    
}


- (void)setFocusColorWithSelectedIndex:(NSInteger)selected_index
{
    if (selected_index > 4) {
        return;
    }
    
    _selected_index = selected_index;
    
    //選択色解除も必要なため、全てのセルを更新
    for (int i=0; i<5; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        [self updateCell:cell atIndexPath:indexPath];
    }
}

- (void)clearAllFocus
{
    _selected_index = 99;
    
    for (int i=0; i<5; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        [self updateCell:cell atIndexPath:indexPath];
    }
}

- (void)setTitle
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 170, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor =[UIColor lightGrayColor];
    label.text = @"空席検索";     self.navigationItem.titleView = label;

}

//picker_train
- (void)showPickerTrain
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        _bottomSpace_picker_train.constant = 0;
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 216, 0);
        [self.view layoutIfNeeded];
    }];
    
    //選択色
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [self setFocusColorWithSelectedIndex:indexPath.row];
    
    //table スクロール
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)hidePickerTrain
{
    [UIView animateWithDuration:0.3 animations:^{
        _bottomSpace_picker_train.constant = -216;
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        [self.view  layoutIfNeeded];
    }];
}


//picker_dep
- (void)showPickerDep
{
    
    [UIView animateWithDuration:0.3 animations:^{
        //_bottomSpace_picker_dep.constant = -0;
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 216, 0);
        [self.view layoutIfNeeded];
    }];
    
    //選択色
    [self setFocusColorWithSelectedIndex:3];
    
    //table スクロール
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)hidePickerDep
{
    [UIView animateWithDuration:0.3 animations:^{
        _bottomSpace_picker_dep.constant = -216;
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        [self.view  layoutIfNeeded];
    }completion:^(BOOL finished) {
    }];

}


//picker_arr
- (void)showPickerArr
{
    [UIView animateWithDuration:0.3 animations:^{
        //_bottomSpace_picker_arr.constant = -0;
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 216, 0);
        NSLog(@"insets_bottom:%f",_tableView.contentInset.bottom);
        NSLog(@"insets_top:%f",_tableView.contentInset.top);
        //[self.view layoutIfNeeded];

    }];
    
    //選択色
    [self setFocusColorWithSelectedIndex:4];
}

- (void)hidePickerArr
{
    [UIView animateWithDuration:0.3 animations:^{
        _bottomSpace_picker_arr.constant = -216;
        [self.view  layoutIfNeeded];
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        
    } completion:^(BOOL finished) {
    }];
    
}


- (void)keyboardWillAppear:(NSNotification*)notification
{
   [UIView animateWithDuration:0.3 animations:^{
    _tableView.contentInset = UIEdgeInsetsMake(64, 0, 216, 0);

   }];
}


- (void)keyboardWillDisappear:(NSNotification*)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);

    }];
}


- (void)updateStations
{
    _stations = [KUStationsManager stationsWithTrainId:_condition.train];
    [_picker_arr reloadAllComponents];
    [_picker_dep reloadAllComponents];
    
}


#pragma mark -
#pragma mark button action

- (void)btDepPressed
{
    [self.view endEditing:YES];
    [self hidePickerTrain];
    [self hidePickerArr];
    [self showPickerDep];
}


- (void)btArrPressed
{
    [self.view endEditing:YES];
    [self hidePickerTrain];
    [self showPickerArr];
    [self hidePickerDep];
}


- (void)btSearchArrPressed
{
    [self.view endEditing:YES];
    [self hidePickerArr];
    [self btSearchPressed];
}

- (void)btNextDepPressed
{
    [self hidePickerDep];
    [self showPickerArr];
}


- (void)btSearchPressed
{
    
    if (![self isValidTime:[NSDate date]]) {
        NSString *message = @"23:30〜6:30の間は情報が提供されません";
        [AppDelegate showAlertWithTitle:nil message:message completion:nil];
    }
    
    ResultsViewController *resultCon = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultsViewController"];
    resultCon.condition = _condition;
    resultCon.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:resultCon animated:YES];
}


- (BOOL)isValidTime:(NSDate*)date
{
    
    if (!date) {
        [[NSException exceptionWithName:@"TimeValudateionExecption" reason:@"date is null" userInfo:nil] raise];
    }
    
    NSDateFormatter *formatter = [NSDateFormatter new];
//    formatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"];
//    formatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
//    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"JIST"];
    [formatter setDateFormat:@"HH:mm"];
    
    NSString *date_str = [formatter stringFromDate:date];
    NSLog(@"current time:%@", date_str);
    
    NSLog(@"toindex2:%@",[date_str substringToIndex:2]);
    NSLog(@"fromindex3:%@",[date_str substringFromIndex:3]);
    
    
    if ([date_str substringToIndex:2].intValue < 6 ||
        ([date_str substringToIndex:2].intValue == 6 &&
         [date_str substringFromIndex:3].intValue < 30)) {
        //時間が早すぎる
            return NO;
    }
    
    if ([date_str substringToIndex:2].intValue > 22 ||
        ([date_str substringToIndex:2].intValue == 22 &&
         [date_str substringFromIndex:3].intValue > 30)) {
        //時間が遅すぎる
            return NO;
    }
    
    return YES;
    
}


@end
