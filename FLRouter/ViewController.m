//
//  ViewController.m
//  FLRouter
//
//  Created by fl-226 on 2018/4/26.
//  Copyright © 2018年 Sean. All rights reserved.
//

#import "ViewController.h"
#import "FLRouter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 100, 100, 40);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)btnAction:(UIButton *)sender {
    [FLRouter openURL:@"route://FLBAPI/presentBVC?username=10" arg:@{@"userid":@"123"} error:nil completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
