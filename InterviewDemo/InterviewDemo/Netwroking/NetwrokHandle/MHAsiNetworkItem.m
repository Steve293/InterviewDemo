//
//  MHAsiNetworkItem.m
//  MHProject
//
//  Created by MengHuan on 15/4/23.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import "MHAsiNetworkItem.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
@interface MHAsiNetworkItem ()

@end

@implementation MHAsiNetworkItem


#pragma mark - 创建一个网络请求项，开始请求网络
/**
 *  创建一个网络请求项，开始请求网络
 *
 *  @param networkType  网络请求方式
 *  @param url          网络请求URL
 *  @param params       网络请求参数
 *  @param delegate     网络请求的委托，如果没有取消网络请求的需求，可传nil
 *  @param hashValue    网络请求的委托delegate的唯一标示
 *  @param showHUD      是否显示HUD
 *  @param successBlock 请求成功后的block
 *  @param failureBlock 请求失败后的block
 *
 *  @return MHAsiNetworkItem对象
 */
- (MHAsiNetworkItem *)initWithtype:(MHAsiNetWorkType)networkType
                               url:(NSString *)url
                            params:(NSDictionary *)params
                          delegate:(id)delegate
                            target:(id)target
                            action:(SEL)action
                         hashValue:(NSUInteger)hashValue
                           showHUD:(BOOL)showHUD
                      successBlock:(MHAsiSuccessBlock)successBlock
                      failureBlock:(MHAsiFailureBlock)failureBlock
{
    
    if (self = [super init])
    {
        self.networkType    = networkType;
        self.url            = url;
        self.params         = params;
        self.delegate       = delegate;
        self.showHUD        = showHUD;
        self.tagrget        = target;
        self.select         = action;
        if (showHUD==YES) {
            [MBProgressHUD showHUD];
        }
        __weak typeof(self)weakSelf = self;
        DTLog(@"--请求url地址--%@\n",url);
        DTLog(@"----请求参数%@\n",params);
        DTLog(@"----请求参数%@\n",params[@"beacon_infos"]);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        if (networkType==MHAsiNetWorkGET)
        {
            
            
            manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];//如果报接受类型不一致请替换一致text/html或别的
             manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
            [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (showHUD==YES) {
                    [MBProgressHUD dissmiss];
                }
                
                int code = 0;
                NSString *msg = nil;
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    NSString *success   = responseObject[@"success"];
                    code                = success.intValue;
                    msg                 = responseObject[@"msg"];
                }
                DTLog(@"\n\n----请求的返回结果 %@\n",responseObject);
                if (successBlock) {
                    successBlock(responseObject,code,msg);
                }
                if ([weakSelf.delegate respondsToSelector:@selector(requestDidFinishLoading:)]) {
                    [weakSelf.delegate requestDidFinishLoading:responseObject];
                }
                [weakSelf performSelector:@selector(finishedRequest: didFaild:) withObject:responseObject withObject:nil];
                [weakSelf removewItem];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (showHUD==YES) {
                    [MBProgressHUD dissmiss];
                }
                NSDictionary *dic=error.userInfo;
                NSHTTPURLResponse *response=dic[@"com.alamofire.serialization.response.error.response"];
                DTLog(@"---error==%@\n",error.localizedDescription);
                if (failureBlock) {
                    failureBlock(error,(int)response.statusCode);
                }
                if ([weakSelf.delegate respondsToSelector:@selector(requestdidFailWithError:andint:)]) {
                    [weakSelf.delegate requestdidFailWithError:error andint:(int)response.statusCode];
                }
                [weakSelf performSelector:@selector(finishedRequest: didFaild:) withObject:nil withObject:error];
            
                [weakSelf removewItem];
            }];
        }else if (networkType==MHAsiNetWorkPOST){
            manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];//如果报接受类型不一致请替换一致text/html或别的
             manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
            
            [manager.requestSerializer setValue:API_BASE_URL forHTTPHeaderField:@"Referer"];
            
            
//            [manager.requestSerializer setValue:[HMFileManager getObjectByFileName:cookice] forHTTPHeaderField:@"X-CSRFToken"];
            [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (showHUD==YES) {
                    [MBProgressHUD dissmiss];
                }
                int code = 0;
                NSString *msg = nil;
                if (responseObject) {
                    NSString *success   = responseObject[@"success"];
                    code                = success.intValue;
                    msg                 = responseObject[@"msg"];
                }
                DTLog(@"\n\n----请求的返回结果 %@\n",responseObject);
                if (successBlock) {
                    successBlock(responseObject,code,msg);
                }
                if ([weakSelf.delegate respondsToSelector:@selector(requestDidFinishLoading:)]) {
                    [weakSelf.delegate requestdidFailWithError:responseObject andint:0];
                }
                [weakSelf performSelector:@selector(finishedRequest: didFaild:) withObject:responseObject withObject:nil];
                [weakSelf removewItem];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error)
            {
                if (showHUD==YES) {
                    [MBProgressHUD dissmiss];
                }
                NSDictionary *dic=error.userInfo;
                NSHTTPURLResponse *response=dic[@"com.alamofire.serialization.response.error.response"];
//                ZKLog(@"%d",response.statusCode);
                DTLog(@"---error==%@\n",error.localizedDescription);
                if (failureBlock) {
                    failureBlock(error,(int)response.statusCode);
//                    if (response.statusCode==403) {
//                        NSNotification * notice = [NSNotification notificationWithName:@"Sign" object:nil userInfo:nil];
//                        //发送消息
//                        [[NSNotificationCenter defaultCenter]postNotification:notice];
//                    }
                }
                if ([weakSelf.delegate respondsToSelector:@selector(requestdidFailWithError:andint:)]) {
                    [weakSelf.delegate requestdidFailWithError:error andint:(int)response.statusCode];
//                    if (response.statusCode==403) {
//                        NSNotification * notice = [NSNotification notificationWithName:@"Sign" object:nil userInfo:nil];
//                        //发送消息
//                        [[NSNotificationCenter defaultCenter]postNotification:notice];
//                    }
                }
                [weakSelf performSelector:@selector(finishedRequest: didFaild:) withObject:nil withObject:error];
                [weakSelf removewItem];
            }];
        }
    }
    return self;
}
/**
 *   移除网络请求项
 */
- (void)removewItem
{
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([weakSelf.delegate respondsToSelector:@selector(netWorkWillDealloc:)]) {
            [weakSelf.delegate netWorkWillDealloc:weakSelf];
        }
    });
}

- (void)finishedRequest:(id)data didFaild:(NSError*)error
{
    if ([self.tagrget respondsToSelector:self.select]) {
        [self.tagrget performSelector:@selector(finishedRequest:didFaild:) withObject:data withObject:error];
    }
}

- (void)dealloc
{
    static int i = 0;
    
    NSLog(@"----%d",i);
    DTLog(@"网络请求项被移除了");
    
    i++;
}

@end
