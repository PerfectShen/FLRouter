//
//  FLRouter.h
//  FLRouter
//
//  Created by fl-226 on 2018/4/26.
//  Copyright © 2018年 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLRouter : NSObject

//路由
+ (id)openURL:(NSString *)url arg:(NSDictionary *)arg error:(NSError **)error completion:(id)completion;
@end
