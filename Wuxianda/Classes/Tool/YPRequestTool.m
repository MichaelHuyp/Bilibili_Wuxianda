//
//  YPRequestTool.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/5/23.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPRequestTool.h"


@implementation YPRequestTool

+ (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    YPNetManager *mgr = [YPNetManager shareManager];
    NSURLSessionDataTask *task = [mgr GET:URLString parameters:parameters progress:downloadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        YPLog(@"%@",responseObject);
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        YPLog(@"%@",error);
        failure(task,error);
    }];;
    return task;
}


+ (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    NSURLSessionDataTask *task = [[YPNetManager shareManager] POST:URLString parameters:parameters progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        YPLog(@"%@",responseObject);
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        YPLog(@"%@",error);
        failure(task,error);
    }];
    return task;
}

+ (void)cancel
{
    // 取消网络请求
    [[YPNetManager shareManager].operationQueue cancelAllOperations];
    
    // 取消任务中的所有网络请求
//    [[YPNetManager shareManager].tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 杀死Session
//    [[YPNetManager shareManager] invalidateSessionCancelingTasks:YES];
}


@end


























