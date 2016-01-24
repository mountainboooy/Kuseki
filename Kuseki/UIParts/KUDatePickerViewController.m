//
//  KUDatePickerViewController.m
//  Kuseki
//
//  Created by 吉原建 on 1/23/16.
//  Copyright © 2016 Takeru Yoshihara. All rights reserved.
//

#import "KUDatePickerViewController.h"

@interface KUDatePickerViewController ()

@end

@implementation KUDatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (KUDatePickerViewController *)datePickerController {
    THDatePickerViewController *datePicker = [self datePicker];
    datePicker.date = [NSDate date];
    [datePicker setDisableHistorySelection:YES];
    [datePicker setAutoCloseOnSelectDate:YES];
    datePicker.slideAnimationDuration = .2;
    [datePicker setAllowSelectionOfSelectedDate:NO];
    
    
    return (KUDatePickerViewController *)datePicker;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
