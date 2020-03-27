//
//  LCViewController.m
//  LCMenu
//
//  Created by 541102613@qq.com on 03/27/2020.
//  Copyright (c) 2020 541102613@qq.com. All rights reserved.
//

#import "LCViewController.h"
#import <LCMenu.h>

@interface LCViewController ()<UIPopoverPresentationControllerDelegate>

@end

@implementation LCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"test" style:UIBarButtonItemStylePlain target:self action:@selector(navRightBarItemsAction:)];
}

//
- (void)navRightBarItemsAction:(UIBarButtonItem *) right {
    
    NSMutableArray *kxItems = [NSMutableArray array];

    LCMenuItem * menuItem1 = [LCMenuItem menuItem:@"扫一扫"
                                               image:[UIImage imageNamed:@"flip"]
                                          titleColor:[UIColor blackColor]
                                              target:self
                                              action:@selector(QRcodeshowAction)];
    [kxItems addObject:menuItem1];

    LCMenuItem * menuItem2 = [LCMenuItem menuItem:@"刷新"
                                            image:[UIImage imageNamed:@"refresh"]
                                       titleColor:[UIColor blackColor]
                                           target:self
                                           action:@selector(reloadAllDatas)];

    [kxItems addObject:menuItem2];


    OptionalConfiguration  abcd =   {
        .marginXSpacing = 5,  //MenuItem左右边距
        .marginYSpacing = 7,  //MenuItem上下边距
        .intervalSpacing = 10,  //MenuItemImage与MenuItemTitle的间距
        .menuCornerRadius = 7,  //菜单圆角半径
        .hasSeperatorLine = true,  //是否设置分割线
        .seperatorLineHasInsets =NO,  //是否在分割线两侧留下Insets
        .menuBackgroundColor = [UIColor colorWithRed:1 green:0.5 blue:1 alpha:1],  //menuItem背景字体颜色

    };
    
    [LCMenu defaultLCMenuController].popoverPresentationController.delegate = self;
    [LCMenu showMenuInVC:self fromView:right menuItems:kxItems withOptions:abcd];
    
}


- (IBAction)buttonAction:(UIButton *)sender {
    
    NSMutableArray *kxItems = [NSMutableArray array];

    LCMenuItem * menuItem1 = [LCMenuItem menuItem:@"扫一扫"
                                            image:[UIImage imageNamed:@"flip"]
                                       titleColor:[UIColor blackColor]
                                            target:self
                                            action:@selector(QRcodeshowAction)];
    [kxItems addObject:menuItem1];

    LCMenuItem * menuItem2 = [LCMenuItem menuItem:@"刷新"
                                            image:[UIImage imageNamed:@"refresh"]
                                       titleColor:[UIColor blackColor]
                                            target:self
                                            action:@selector(reloadAllDatas)];

    [kxItems addObject:menuItem2];

    LCMenuItem * menuItem3 = [LCMenuItem menuItem:@"摇商机"
                                            image:[UIImage imageNamed:@"Shake"]
                                       titleColor:[UIColor blackColor]
                                            target:self
                                            action:@selector(goShake)];

    [kxItems addObject:menuItem3];


    OptionalConfiguration  abcd =   {
        .marginXSpacing = 5,  //MenuItem左右边距
        .marginYSpacing = 7,  //MenuItem上下边距
        .intervalSpacing = 10,  //MenuItemImage与MenuItemTitle的间距
        .menuCornerRadius = 7,  //菜单圆角半径
        .hasSeperatorLine = true,  //是否设置分割线
        .seperatorLineHasInsets =NO,  //是否在分割线两侧留下Insets
        .menuBackgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1],  //menuItem背景字体颜色

    };
    

    
    [LCMenu defaultLCMenuController].popoverPresentationController.delegate = self;
    [LCMenu showMenuInVC:self fromView:sender menuItems:kxItems withOptions:abcd];

}



//执行的方法
- (void)QRcodeshowAction {
    
    
}

- (void)reloadAllDatas {
    
}

- (void)goShake {
    
}

//需要添加代理
#pragma mark - <UIPopoverPresentationControllerDelegate>
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
