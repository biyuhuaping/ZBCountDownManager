//
//  ViewController.m
//  CellCountDown
//
//  Created by Gold on 2017/9/30.
//  Copyright © 2017年 herobin. All rights reserved.
//

#import "ViewController.h"
#import "ZBTableVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首页";
}

- (IBAction)singleTableBtnClick:(id)sender {
    [self.navigationController pushViewController:[ZBTableVC new] animated:YES];
}

@end
