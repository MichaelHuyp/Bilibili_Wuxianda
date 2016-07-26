//
//  YPRequestTool.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/5/23.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YPNetManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface YPRequestTool : NSObject

+ (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;


+ (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

+ (void)cancel;

@end


NS_ASSUME_NONNULL_END