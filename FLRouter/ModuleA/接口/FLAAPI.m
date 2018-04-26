//
//  FLAAPI.m
//  FLRouter
//
//  Created by fl-226 on 2018/4/26.
//  Copyright © 2018年 Sean. All rights reserved.
//

#import "FLAAPI.h"
#import "FLAViewController.h"

@implementation FLAAPI

+ (void)presentAVC {
    
    FLAViewController *vc = [[FLAViewController alloc] init];
    UIViewController *currVC = [self _currentViewController];
//    [currVC presentViewController:vc animated:YES completion:nil];
    [currVC.navigationController pushViewController:vc animated:YES];
}


/// 获取当前控制器
+ (UIViewController *)_currentViewController{
    
    UIViewController * currVC = nil;
    UIViewController * Rootvc = [UIApplication sharedApplication].keyWindow.rootViewController ;
    do {
        if ([Rootvc isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)Rootvc;
            UIViewController * v = [nav.viewControllers lastObject];
            currVC = v;
            Rootvc = v.presentedViewController;
            continue;
        }else if([Rootvc isKindOfClass:[UITabBarController class]]){
            UITabBarController * tabVC = (UITabBarController *)Rootvc;
            currVC = tabVC;
            Rootvc = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
            continue;
        }else if([Rootvc isKindOfClass:[UIViewController class]] && Rootvc.presentedViewController){
            return Rootvc.presentedViewController;
        }else if([Rootvc isKindOfClass:[UIViewController class]]){
            return Rootvc;
        }
    } while (Rootvc!=nil);
    
    return currVC;
}


@end
