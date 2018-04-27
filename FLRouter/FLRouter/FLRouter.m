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

+ (instancetype)shareInstance {
    static FLRouter *s_route = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_route = [[FLRouter alloc] init];
    });
    return s_route;
}

+ (id)openURL:(NSString *)url arg:(NSDictionary *)arg error:(NSError **)error completion:(id)completion {
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
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:arg];
    if (getParams) {
        [params addEntriesFromDictionary:[self generateParamsString:getParams]];
    }
    NSLog(@"%@",params);
    Class target = NSClassFromString(targetName);
    SEL selector = NSSelectorFromString(actionName);
    if ([target respondsToSelector:selector]) {
        [self safePerformAction:selector target:target params:params];
//        [target performSelector:selector withObject:nil];
//        [self safePerformAction:selector target:target params:params];
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
            NSLog(@"匹配到 %@", tmpGroup);
            [tmpArray addObject:tmpGroup];
        }
    }
    return tmpArray;
}

+ (NSDictionary *)generateParamsString:(NSString *)paramString {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSArray *components = [paramString componentsSeparatedByString:@"&"];
    for (NSString *tmpStr in components) {
        NSArray *tmpArray = [tmpStr componentsSeparatedByString:@"="];
        if (tmpArray.count == 2) {
            [params setObject:tmpArray[1] forKey:tmpArray[0]];
        }else {
            NSLog(@"参数不合法 : %@",tmpStr);
        }
    }
    
    return params;
}

//url 解析  解析答 target 和  action 然后动态调用 -
//如果 解析到的是 http:

+ (id)safePerformAction:(SEL)action target:(id)target params:(NSDictionary *)params
{
    NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
    if(methodSig == nil) {
        return nil;
    }
    const char* retType = [methodSig methodReturnType];
    NSUInteger count =  [methodSig numberOfArguments];
    NSLog(@"方法的 参数个数 - %zd",count);
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    if (count >= 3) {
        [invocation setArgument:&params atIndex:2];
    }else {
        NSLog(@"Action：%@ 参数过多:%@",NSStringFromSelector(action),params);
    }
    [invocation setSelector:action];
    [invocation setTarget:target];
    if (strcmp(retType, @encode(void)) == 0) {
        [invocation invoke];
        return nil;
    }

    if (strcmp(retType, @encode(NSInteger)) == 0) {
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

    if (strcmp(retType, @encode(BOOL)) == 0) {
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

    if (strcmp(retType, @encode(CGFloat)) == 0) {
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
    return nil;
}



@end
