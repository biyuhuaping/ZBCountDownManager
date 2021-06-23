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

- (IBAction)singleTableBtnClick:(UIButton *)sender {
    ZBTableVC *vc = [[ZBTableVC alloc]init];
    vc.title = sender.titleLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
