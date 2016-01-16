//
//  KUTabBarController.m
//  Kuseki
//
//  Created by 吉原建 on 1/16/16.
//  Copyright © 2016 Takeru Yoshihara. All rights reserved.
//

#import "KUTabBarController.h"

@interface KUTabBarController ()

@end

@implementation KUTabBarController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UITabBarItem *searchPage = self.tabBar.items[0];
    searchPage.title = NSLocalizedString(@"search", nil);
    
    UITabBarItem *historyPage = self.tabBar.items[1];
    historyPage.title = NSLocalizedString(@"history", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
