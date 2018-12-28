//
//  ResultsViewController.h
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/17.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KUSearchCondition.h"

@interface ResultsViewController : UIViewController

@property (nonatomic,copy) KUSearchCondition *condition;

@end
