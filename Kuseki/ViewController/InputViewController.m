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
#import "InformationViewController.h"
#import "Flurry.h"
#import "KUDatePickerViewController.h"
#import "NSDate+IntegerDate.h"
#import "KUReviewMusterController.h"

@interface
InputViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, MITextFieldDelegate, THDatePickerDelegate> {
    // outlet
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UIPickerView *_picker_train;
    __weak IBOutlet UIPickerView *_picker_dep;
    __weak IBOutlet UIPickerView *_picker_arr;
    __weak IBOutlet UIButton *_btClose_train;
    __weak IBOutlet UIButton *_btClose_dep;
    __weak IBOutlet UIButton *_btClose_arr;

    // constraint
    __weak IBOutlet NSLayoutConstraint *_bottomSpace_picker_train;
    __weak IBOutlet NSLayoutConstraint *_bottomSpace_picker_dep;
    __weak IBOutlet NSLayoutConstraint *_bottomSpace_picker_arr;

    // model
    KUSearchCondition *_condition;

    // other
    NSArray *_trains;
    NSDictionary *_stations;
    NSInteger _selected_index;
    KUDatePickerViewController *_datePicker;
}

@end

@implementation InputViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // tableView
    _tableView.delegate = self;
    _tableView.dataSource = self;

    // pickerView
    _picker_train.delegate = self;
    _picker_train.dataSource = self;

    _picker_dep.delegate = self;
    _picker_arr.delegate = self;

    _picker_dep.dataSource = self;
    _picker_arr.dataSource = self;

    // notification keyboard
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

    [nc addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];

    [nc addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
    // notification reviewMuster
    [nc addObserver:self selector:@selector(fireReviewTrigger) name:UIApplicationDidBecomeActiveNotification object:nil];
    

    //検索条件の初期化
    [self initCondition];
    
    _trains = [NSArray arrayWithObjects:
               NSLocalizedString(@"trainType1", nil),
               NSLocalizedString(@"trainType2", nil),
               NSLocalizedString(@"trainType3", nil),
               NSLocalizedString(@"trainType4", nil), nil];
    
    // stations
    [self updateStations];

    // button_close
    [_btClose_train addTarget:self action:@selector(btCloseTrainPressed) forControlEvents:UIControlEventTouchUpInside];
    [_btClose_dep addTarget:self action:@selector(btCloseDepPressed) forControlEvents:UIControlEventTouchUpInside];
    [_btClose_arr addTarget:self action:@selector(btCloseArrPressed) forControlEvents:UIControlEventTouchUpInside];
    
    //datePicker
    if (!_datePicker) {
        _datePicker = [KUDatePickerViewController datePickerController];
        _datePicker.delegate = self;
    }

    _selected_index = 99;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTitle];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSString *identifier = [NSString stringWithFormat:@"cell%ld", (long)indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    [self updateCell:cell atIndexPath:indexPath];

    return cell;
}

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{

    switch (indexPath.row) {
        case 0: {
            // ride date
            MITextField *tf_month = (MITextField *)[cell viewWithTag:1];
            MITextField *tf_day = (MITextField *)[cell viewWithTag:2];
            tf_month.text = _condition.month;
            tf_day.text = _condition.day;
            UILabel *lb_rideDate = (UILabel *)[cell viewWithTag:3];
            UIView *focus_view = (UIView *)[cell viewWithTag:9];

            // selection color
            focus_view.alpha = (indexPath.row == _selected_index) ? 0.2 : 0;
            
            //localization
            lb_rideDate.text = NSLocalizedString(@"rideDate", nil);
            break;
        }

        case 1: {
            //ride time
            MITextField *tf_hour = (MITextField *)[cell viewWithTag:1];
            MITextField *tf_minute = (MITextField *)[cell viewWithTag:2];
            UILabel *lb_rideTime = (UILabel *)[cell viewWithTag:3];
            UIView *focus_view = (UIView *)[cell viewWithTag:9];

            tf_hour.accessory_mode = ACCESSORY_ALL;
            tf_hour.delegate = self;
            tf_hour.indexPath = indexPath;
            tf_hour.text = _condition.hour;

            tf_minute.accessory_mode = ACCESSORY_ALL;
            tf_minute.delegate = self;
            tf_minute.indexPath = indexPath;
            tf_minute.text = _condition.minute;

            //selection color
            focus_view.alpha = (indexPath.row == _selected_index) ? 0.2 : 0;
            
            //localization
            lb_rideTime.text = NSLocalizedString(@"rideTime", nil);

            break;
        }

        case 2: {  //train types
            UILabel *lb_train = (UILabel *)[cell viewWithTag:1];
            UILabel *lb_trainType = (UILabel *)[cell viewWithTag:3];
            UIView *focus_view = (UIView *)[cell viewWithTag:9];
            
            if (_condition.train.intValue == 3) {
                lb_train.text = NSLocalizedString(@"trainType3", nil);
            } else {
                lb_train.text = _trains[_condition.train.intValue - 1];
            }

            //selection color
            focus_view.alpha = (indexPath.row == _selected_index) ? 0.2 : 0;
            
            //localization
            lb_trainType.text = NSLocalizedString(@"typeOfTrain", nil);

            break;
        }

        case 3: {  //departure, destination
            UILabel *lb_departure = (UILabel *)[cell viewWithTag:7];
            UILabel *lb_destination = (UILabel *)[cell viewWithTag:8];
            UIView *focus_view_dep = (UIView *)[cell viewWithTag:9];
            UIView *focus_view_arr = (UIView *)[cell viewWithTag:10];

            MITextField *tf_dep_stn = (MITextField *)[cell viewWithTag:1];
            tf_dep_stn.delegate = self;
            tf_dep_stn.indexPath = indexPath;
            tf_dep_stn.text = [KUStationsManager localizedStation:_condition.dep_stn];

            MITextField *tf_arr_stn = (MITextField *)[cell viewWithTag:2];
            tf_arr_stn.delegate = self;
            tf_arr_stn.indexPath = indexPath;
            tf_arr_stn.text = [KUStationsManager localizedStation:_condition.arr_stn];

            // reverse stations
            UIButton *bt_reverse = (UIButton *)[cell viewWithTag:5];
            [bt_reverse addTarget:self action:@selector(btReversePressed) forControlEvents:UIControlEventTouchUpInside];

            // button for selecting cells
            UIButton *bt_dep = (UIButton *)[cell viewWithTag:3];
            UIButton *bt_arr = (UIButton *)[cell viewWithTag:4];
            [bt_dep addTarget:self action:@selector(btDepPressed) forControlEvents:UIControlEventTouchUpInside];
            [bt_arr addTarget:self action:@selector(btArrPressed) forControlEvents:UIControlEventTouchUpInside];

            // selection color
            //乗車駅・降車駅のそれぞれで位置をずらして表示
            if (_selected_index == 3) {  // departure
                focus_view_dep.alpha = 0.2;
                focus_view_arr.alpha = 0;

            } else if (_selected_index == 4) {  // destination
                focus_view_dep.alpha = 0;
                focus_view_arr.alpha = 0.2;

            } else {
                focus_view_dep.alpha = 0;
                focus_view_arr.alpha = 0;
            }
            
            // localization
            lb_departure.text = NSLocalizedString(@"departureStation", nil);
            lb_destination.text = NSLocalizedString(@"destinationStation", nil);

            break;
        }
            

        case 4: {
            UIButton *bt_search = (UIButton *)[cell viewWithTag:1];
            UIImage *buttonImage = [UIImage imageNamed:NSLocalizedString(@"searchButton", nil)];
            [bt_search setImage:buttonImage forState:UIControlStateNormal];
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
            height = 72;
            break;

        case 3:
            height = 144;
            break;

        case 4: {
            NSString *model = [UIDevice currentDevice].model;
            if ([model isEqualToString:@"iPad"] || [model isEqualToString:@"iPad Simulator"]) {
                height = 140;

            } else {
                height = 83;
            }
            break;
        }
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    switch (indexPath.row) {
        case 0: {  // ride date
            [self presentSemiViewController:_datePicker];
            break;
        }

        case 1: {  // ride time
            [self hidePickerArr];
            [self hidePickerTrain];
            UITextField *tf_hour = (UITextField *)[cell viewWithTag:1];
            [tf_hour becomeFirstResponder];
            break;
        }

        case 2: {  // train types
            [self hidePickerArr];
            [self hidePickerDep];
            [self hidePickerTrain];
            [self showPickerTrain];
            break;
        }

        case 3: {  // departure, destination
            //タップする場所によって分ける必要があるため、ボタンで処理
            break;
        }

        default: {
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
    NSArray *stationsJapanese = _stations[@"ja"];
    switch (pickerView.tag) {
        case 1:  // train
            return 4;
            break;

        case 2:  // dep_stn
            return stationsJapanese.count;

        case 3:  // arr_stn
            return stationsJapanese.count;

        default:
            break;
    }

    return 0;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;

    if (pickerView.tag == 1) {  // train
        switch (row) {
            case 0: {
                title = _trains[0];
                break;
            }
            case 1: {
                title = _trains[1];
                break;
            }

            case 2: {
                title = _trains[2];
                break;
            }

            case 3: {
                title = _trains[3];
                break;
            }

            case 4: {
                title = _trains[4];
                break;
            }
        }
    } else {  // stations
        title = _stations[@"ja"][row];
    }

    NSAttributedString *attString;
    attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor darkGrayColor]}];

    return attString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 1) {  // train

        NSString *selectedNum = [NSString stringWithFormat:@"%d", (int)row + 1];
        _condition.train = selectedNum;

        [self updateStations];
    } else if (pickerView.tag == 2) {  // dep_stn
        _condition.dep_stn = _stations[@"ja"][row];
    } else {  // arr_stn
        _condition.arr_stn = _stations[@"ja"][row];
    }

    [_tableView reloadData];
}

#pragma mark - datePicker

- (void)datePickerCancelPressed:(THDatePickerViewController *)datePicker {
    [self dismissSemiModalView];
}

- (void)datePickerDonePressed:(THDatePickerViewController *)datePicker {
    [self dismissSemiModalView];
}

- (void)datePicker:(THDatePickerViewController *)datePicker selectedDate:(NSDate *)selectedDate {
    NSLog(@"year:%d", [selectedDate integerYear]);
    NSLog(@"month:%d", [selectedDate integerMonth]);
    NSLog(@"day:%d", [selectedDate integerDay]);
    _condition.year = [NSString stringWithFormat:@"%d", [selectedDate integerYear]];
    _condition.month = [NSString stringWithFormat:@"%d",[selectedDate integerMonth]];
    _condition.day = [NSString stringWithFormat:@"%d", [selectedDate integerDay]];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    [self updateCell:cell atIndexPath:indexPath];
}

#pragma mark -
#pragma mark textField

- (void)endEditingTextField {
    [self.view endEditing:YES];
}

- (void)textFieldDidBeginEditing:(MITextField *)textField
{
    // display selection color
    [self setFocusColorWithSelectedIndex:textField.indexPath.row];

    [self hidePickerTrain];
    [self hidePickerDep];
    [self hidePickerArr];
    textField.placeholder = textField.text;
    textField.text = @"";

    // table scroll
    [_tableView scrollToRowAtIndexPath:textField.indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)textFieldDidEndEditing:(MITextField *)textField
{
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:textField.indexPath];

    // textFieldが空の場合は元の値に戻す
    if ([textField.text isEqualToString:@""]) {
        [self updateCell:cell atIndexPath:textField.indexPath];
        return;
    }

    switch (textField.indexPath.row) {

        case 1: {                      // rite time
            if (textField.tag == 1) {  // hour
                _condition.hour = textField.text;

            } else {  // minute
                _condition.minute = textField.text;
            }
            break;
        }

        case 3: {  // dep_stn
            _condition.dep_stn = textField.text;
            break;
        }

        case 4: {  // arr_strn
            _condition.arr_stn = textField.text;
            break;
        }

        default:
            break;
    }
}

- (BOOL)textField:(MITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSMutableString *text = [textField.text mutableCopy];
    [text replaceCharactersInRange:range withString:string];
    NSIndexPath *nextPath;
    UITableViewCell *nextCell;
    MITextField *nextField;
    
    switch (textField.indexPath.row) {
        case 1: {                      //時間
            if (textField.tag == 1) {  //時
                if (text.length == 1 && text.intValue > 2) {
                    // 3以上の場合は03などに変換して次に移動
                    textField.text = @"0";
                    nextPath = [NSIndexPath indexPathForRow:1 inSection:0];
                    nextCell = [_tableView cellForRowAtIndexPath:nextPath];
                    nextField = (MITextField *)[nextCell viewWithTag:2];
                    [self performSelector:@selector(focusNextField:) withObject:nextField afterDelay:0.1];
                    return YES;
                }
                
                if (text.length == 2) {  //分に移動
                    nextPath = [NSIndexPath indexPathForRow:1 inSection:0];
                    nextCell = [_tableView cellForRowAtIndexPath:nextPath];
                    nextField = (MITextField *)[nextCell viewWithTag:2];
                    [self performSelector:@selector(focusNextField:) withObject:nextField afterDelay:0.1];
                    return YES;
                }
                
            } else {  //分
                if (text.length == 1 && text.intValue > 5) {
                    // 6以上の場合は06などに変換して次に移動
                    textField.text = @"0";
                    [self performSelector:@selector(showPickerTrain) withObject:nil afterDelay:0.1];
                    return YES;
                }
                if (text.length == 2) {  //編集を完了
                    [self performSelector:@selector(endEditingTextField) withObject:nil afterDelay:.1];
                    return YES;
                }
            }
            break;
        }
            
        default:{
            break;
        }
    }
    return YES;
}

- (void)focusNextField:(MITextField *)nextField
{
    [nextField becomeFirstResponder];
}

- (void)textFieldDidPressCloseBt:(MITextField *)textField
{
    [self setFocusColorWithSelectedIndex:99];
}

#pragma mark -
#pragma mark private methods

- (void)initCondition
{
    //現在の日時を取得
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:600];
    NSDictionary *dic = @{
                          @"identifier" : @"",
        @"year" : [NSString stringWithFormat:@"%d", [date integerYear]],
        @"month" : [NSString stringWithFormat:@"%d", [date integerMonth]],
        @"day" : [NSString stringWithFormat:@"%d", [date integerDay]],
        @"hour" : [NSString stringWithFormat:@"%d", [date integerHour]],
        @"minute" : [NSString stringWithFormat:@"%d", [date integerMinute]],
        @"train" : [[KUSearchCondition previousCondition] train],
        @"dep_stn" : [[KUSearchCondition previousCondition] dep_stn],
        @"arr_stn" : [[KUSearchCondition previousCondition] arr_stn]
    };
    _condition = [[KUSearchCondition alloc] initWithDictionary:dic];
}

- (void)setFocusColorWithSelectedIndex:(NSInteger)selected_index
{
    if (selected_index > 4 && selected_index != 99) {
        return;
    }

    _selected_index = selected_index;

    //選択色解除も必要なため、全てのセルを更新
    for (int i = 0; i < 5; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        [self updateCell:cell atIndexPath:indexPath];
    }
}

- (void)setTitle
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 170, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1];
    label.text = NSLocalizedString(@"vacancySearch", nil);
    self.navigationItem.titleView = label;
}

// picker_train
- (void)showPickerTrain
{
    [self.view endEditing:YES];
    [self.view layoutIfNeeded];
    _bottomSpace_picker_train.constant = 0;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 300, 0);
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];

    //選択色
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [self setFocusColorWithSelectedIndex:indexPath.row];

    // table スクロール
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)hidePickerTrain
{
    [self.view layoutIfNeeded];
    _bottomSpace_picker_train.constant = -300;
    _tableView.contentInset = UIEdgeInsetsZero;
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

// picker_dep
- (void)showPickerDep
{
    [self.view layoutIfNeeded];
    _bottomSpace_picker_dep.constant = -0;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 300, 0);
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];

    //選択色
    [self setFocusColorWithSelectedIndex:3];

    // table スクロール
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)hidePickerDep
{
    [self.view layoutIfNeeded];
    _bottomSpace_picker_dep.constant = -300;
    _tableView.contentInset = UIEdgeInsetsZero;
    [UIView animateWithDuration:0.3
        animations:^{
            [self.view layoutIfNeeded];
        }
        completion:^(BOOL finished) {}];
}

// picker_arr
- (void)showPickerArr
{
    [self.view layoutIfNeeded];
    _bottomSpace_picker_arr.constant = -0;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 300, 0);
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];

    //選択色
    [self setFocusColorWithSelectedIndex:4];

    // table スクロール
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)hidePickerArr
{
    [self.view layoutIfNeeded];
    _bottomSpace_picker_arr.constant = -300;
    _tableView.contentInset = UIEdgeInsetsZero;
    [UIView animateWithDuration:0.3
        animations:^{
            [self.view layoutIfNeeded];
        }
        completion:^(BOOL finished) {}];
}

- (void)keyboardWillAppear:(NSNotification *)notification
{
    [self.view layoutIfNeeded];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 300, 0);
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

- (void)keyboardWillDisappear:(NSNotification *)notification
{
    [self.view layoutIfNeeded];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

- (void)updateStations
{
    _stations = [KUStationsManager stationsWithTrainId:_condition.train];
    [_picker_arr reloadAllComponents];
    [_picker_dep reloadAllComponents];
}

- (void)trackEventWithFlurry
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    formatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"JST"];
    [formatter setDateFormat:@"yyyy-MM HH:mm:ss"];
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];

    NSDictionary *condition = @{
        @"month" : _condition.month,
        @"day" : _condition.day,
        @"hour" : _condition.hour,
        @"minute" : _condition.minute,
        @"train" : _condition.train,
        @"dep_stn" : _condition.dep_stn,
        @"arr_stn" : _condition.arr_stn,
        @"created_at" : timestamp
    };

    [Flurry logEvent:@"btnSearchPressed" withParameters:condition];
}

- (void)fireReviewTrigger {
    [KUReviewMusterController fireEventWithKey:@"DID_BECOME_ACTIVE" viewController:self];
}

#pragma mark - button action

- (void)btReversePressed
{
    //出発駅と到着駅を反転
    NSString *dep_stn = _condition.arr_stn;
    NSString *arr_stn = _condition.dep_stn;
    _condition.dep_stn = dep_stn;
    _condition.arr_stn = arr_stn;

    for (UITableViewCell *cell in _tableView.visibleCells) {
        [self updateCell:cell atIndexPath:[_tableView indexPathForCell:cell]];
    }

    //画像の回転
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:3 inSection:0];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];

    UIImageView *arrow = (UIImageView *)[cell viewWithTag:6];
    CGFloat angle = 180 * M_PI / 180.0;
    [UIView animateWithDuration:0.2
        animations:^{ arrow.transform = CGAffineTransformMakeRotation(angle); }
        completion:^(BOOL finished) {
            //回転後は元に戻す
            arrow.transform = CGAffineTransformIdentity;
        }];
}

- (void)btCloseTrainPressed
{
    [self hidePickerTrain];
    [self setFocusColorWithSelectedIndex:99];
}

- (void)btDepPressed
{
    [self.view endEditing:YES];
    [self hidePickerTrain];
    [self hidePickerArr];
    [self showPickerDep];
}

- (void)btNextDepPressed
{
    [self hidePickerDep];
    //[self showPickerArr];
}

- (void)btCloseDepPressed
{
    [self hidePickerDep];
    [self setFocusColorWithSelectedIndex:99];
}

- (void)btArrPressed
{
    [self.view endEditing:YES];
    [self hidePickerTrain];
    [self hidePickerDep];
    [self showPickerArr];
}

- (void)btCloseArrPressed
{
    [self hidePickerArr];
    [self setFocusColorWithSelectedIndex:99];
}

- (void)btSearchPressed
{
    if (![self isValidTime:[NSDate date]]) {
        NSString *message = @"22:30〜6:30の間は情報が提供されません";
        [AppDelegate showAlertWithTitle:nil message:message completion:nil];
    }

    ResultsViewController *resultCon = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultsViewController"];
    resultCon.condition = _condition;
    resultCon.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:resultCon animated:YES];
    [_condition saveAsPreviousCondition];

    [self trackEventWithFlurry];
}

- (BOOL)isValidTime:(NSDate *)date
{

    if (!date) {
        [[NSException exceptionWithName:@"TimeValudateionExecption" reason:@"date is null" userInfo:nil] raise];
    }

    NSDateFormatter *formatter = [NSDateFormatter new];
    //    formatter.locale = [[NSLocale
    // alloc]initWithLocaleIdentifier:@"en_US_POSIX"];
    //    formatter.calendar = [[NSCalendar
    // alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    //    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"JIST"];
    [formatter setDateFormat:@"HH:mm"];

    NSString *date_str = [formatter stringFromDate:date];
    NSLog(@"current time:%@", date_str);

    NSLog(@"toindex2:%@", [date_str substringToIndex:2]);
    NSLog(@"fromindex3:%@", [date_str substringFromIndex:3]);

    if ([date_str substringToIndex:2].intValue < 6 || ([date_str substringToIndex:2].intValue == 6 && [date_str substringFromIndex:3].intValue < 30)) {
        //時間が早すぎる
        return NO;
    }

    if ([date_str substringToIndex:2].intValue > 22 || ([date_str substringToIndex:2].intValue == 22 && [date_str substringFromIndex:3].intValue > 30)) {
        //時間が遅すぎる
        return NO;
    }

    return YES;
}

- (IBAction)btInfomationPressed:(id)sender
{
    InformationViewController *infoCon = [self.storyboard instantiateViewControllerWithIdentifier:@"InformationViewController"];
    infoCon.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:infoCon animated:YES];
}

@end
