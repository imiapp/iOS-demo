//
//  InternetHttpTools.m
//  PoliceFoShan
//
//  Created by 汤书亚 on 2017/7/20.
//  Copyright © 2017年 汤书亚. All rights reserved.
//

#import "InternetHttpTools.h"
#import "InternetHttpsessionManager.h"

/** 弱引用 */
#define VWWeakSelf __weak typeof(self) weakSelf = self;
//测试环境
/** mapping servers */
#define VWURLTest(args) ([NSString stringWithFormat:@"http://test.service.azurenet.cn:9100/imi/%@",args])
//正式环境
/** mapping servers */
#define VWURLFormal(args) ([NSString stringWithFormat:@"http://test.service.azurenet.cn:9110/imi/%@",args])
//通用接口
/** 获取topicID */
#define VWCommonTopicIdURL VWURLFormal(@"createChannel")
/** pull获取用户数据 */
#define VWLoginPullDataURL VWURLFormal(@"getAuthorizationInfo")

@interface InternetHttpTools ()
/** 请求管理者类*/
@property (nonatomic, strong) InternetHttpsessionManager *manager;

@end

@implementation InternetHttpTools


- (InternetHttpsessionManager *)manager
{
    if (!_manager) {
        _manager = [InternetHttpsessionManager manager];
        
    }
    return _manager;
}

/** 创建网络服务 */
+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static InternetHttpTools *sharedInstance = nil;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}


/** 获取topicID */
- (void)postTopicIDparams:(NSDictionary*)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    
    VWWeakSelf
    
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer.timeoutInterval = 120;
    
    // 发送POST请求
    [weakSelf.manager POST:VWCommonTopicIdURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        if (success) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            success(dict);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

/** pull获取用户登录信息 */
- (void)pullDataLoginParams:(NSDictionary*)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    
    
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer.timeoutInterval = 120;
    
    // 发送POST请求
    
    [self.manager POST:VWLoginPullDataURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        if (success) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            success(dict);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

@end
