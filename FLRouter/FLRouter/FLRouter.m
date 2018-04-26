//
//  FLRouter.m
//  FLRouter
//
//  Created by fl-226 on 2018/4/26.
//  Copyright © 2018年 Sean. All rights reserved.
//

#import "FLRouter.h"
#import <UIKit/UIKit.h>

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

- (id)safePerformAction:(SEL)action target:(NSObject *)target params:(NSDictionary *)params
{
    NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
    if(methodSig == nil) {
        return nil;
    }
    const char* retType = [methodSig methodReturnType];
    
    if (strcmp(retType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        return nil;
    }
    
    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(CGFloat)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
}



@end
