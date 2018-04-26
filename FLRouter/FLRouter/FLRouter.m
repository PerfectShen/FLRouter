//
//  FLRouter.m
//  FLRouter
//
//  Created by fl-226 on 2018/4/26.
//  Copyright © 2018年 Sean. All rights reserved.
//

#import "FLRouter.h"

// 默认路由
static NSString *const FLDefaultRouteSchema = @"FLRoute";

@implementation FLRouter

+ (id)openURL:(NSString *)url arg:(NSDictionary *)arg error:(NSError **)error completion:(id)completion {
    
//    if ([url rangeOfString:@"FLAAPI"].location != NSNotFound) {
//        Class B = NSClassFromString(@"FLAAPI");
//        SEL selector = NSSelectorFromString(@"presentAVC");
//        [B performSelector:selector withObject:nil];
//    }else {
//        Class B = NSClassFromString(@"FLBAPI");
//        SEL selector = NSSelectorFromString(@"presentBVC");
//        [B performSelector:selector withObject:nil];
//    }
//
//    return nil;
    NSArray *tmpArray = [self generateURL:url];
    NSString *targetName;
    NSString *actionName;
    NSString *getParams;
    if (tmpArray.count >= 3) {
        targetName = tmpArray[2];
    }
    if (tmpArray.count >= 4) {
        actionName = tmpArray[3];
    }
    if (tmpArray.count >= 5) {
        getParams = tmpArray[4];
    }
    if (!targetName) {
        NSLog(@"找不到 Target");
    }
    if (!actionName) {
        NSLog(@"找不到 actionName");
    }
    

    Class target = NSClassFromString(targetName);
    SEL selector = NSSelectorFromString(actionName);
    if ([target respondsToSelector:selector]) {
        [target performSelector:selector withObject:nil];
    }else {
        NSLog(@"路径有误 target: %@ , action: %@",targetName,actionName);
    }
    
    return  nil;
}

+ (NSArray *)generateURL:(NSString *)url {
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    NSString *regex = @"(^[A-Za-z]{4,10})://([a-zA-Z0-9_]{1,})/([a-zA-Z0-9_]{1,})[?]{0,1}([a-zA-Z0-9_=&]{0,})";
    NSError *error;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [expression matchesInString:url options:NSMatchingReportProgress range:NSMakeRange(0, url.length)];
    for (NSTextCheckingResult *match in matches) {
        NSInteger numbers = [match numberOfRanges];
        for (NSInteger i = 0; i < numbers; i ++) {
            NSString *tmpGroup = [url substringWithRange:[match rangeAtIndex:i]];
            NSLog(@"%@", tmpGroup);
            [tmpArray addObject:tmpGroup];
        }
    }
    return tmpArray;
}

//url 解析  解析答 target 和  action 然后动态调用 -
//如果 解析到的是 http:




@end
