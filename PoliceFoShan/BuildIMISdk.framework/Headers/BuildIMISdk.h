//
//  BuildIMISdk.h
//  BuildIMISdk
//
//  Created by 汤书亚 on 2017/7/7.
//  Copyright © 2017年 汤书亚. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^completeBlock)(NSDictionary * _Nullable object,NSString * _Nullable jwtString, NSError * _Nullable  error);
typedef void(^handlerBlock)(NSString * _Nullable result, NSError * _Nullable  error);
typedef void(^scanCompleteBlock)(NSDictionary * _Nullable object,NSError * _Nullable  error);
typedef NSString *_Nullable(^signCompleteBlock)(NSString * _Nullable object);
typedef NSString *_Nullable(^createChannelBlock)();

@interface BuildIMISdk : NSObject

/*
 一.第三方APP调起IMI，使用登录或者授权功能，需要配置以下功能（1--2）。
 
 1.请先在app中设置白名单权限.
 步骤:右键plist文件,open as-->source code
 添加以下代码:
 <key>LSApplicationQueriesSchemes</key>
 <array>
 <string>WFVportAllowLogin</string>
 </array>
 
 2. 需要手动或者github导入第三方库
 2.2 <AFNetworking>
 */


/*
 *  1.创建网络服务
 *  @return 网络服务(单例)
 */
+(instancetype _Nullable )sharedInstance;


/* 2.检查IMI是否已被用户安装
 * @return IMI已安装返回YES，未安装返回NO。
 */
- (BOOL)isIMIinstalled;


/* 3.登录方法
 * name:第三方app的名称
 * createChannelReq:有返回值的block，需要第三方实现获取topicId的函数，返回给IMI。
 * @return handler:返回IMI登录的结果，如果result=success，代表IMI推送登录数据成功，第三方app此时从自己服务器就能获取到登录数据。
 */

- (void)reqLogin:(NSString *_Nullable)name andCreateChannelBlock:(createChannelBlock _Nullable )createChannelReq  andIMIResponseHandler:(nullable handlerBlock)handler;

/* 4.授权方法
 * name:第三方app的名称
 * type:用于区分授权类型,目前支持类型为:1.type = "snsapi_idcard,snsapi_info"，代表获取登录信息和身份证信息。2.type="snsapi_idcard",代表只获取身份证信息;
   后续会推出其他功能，根据第三方传递不同的type值，推送不同的信息。
 * createChannelReq:有返回值的block，需要第三方实现获取topicId的函数，返回给IMI。
 * @return handler:返回IMI授权的结果，如果result=success，代表IMI推送授权数据成功，第三方app此时从自己服务器就能获取到授权数据。
 */
- (void)reqAuthorize:(NSString *_Nullable)type name:(NSString *_Nullable)name andCreateChannelBlock:(createChannelBlock _Nullable )createChannelReq  andIMIResponseHandler:(nullable handlerBlock)handler;


/* 5.回调函数
 * 需要在application: openURL方法实现
 * IMI登录或授权完成返回第三方app在此方法中可以拦截到。
 * IMI登录或者授权需要调起此方法，获取IMI登录或者授权的结果。
 * url:IMI回调的url
 */
- (void)IMI_HandleBackUrl:(NSString *_Nullable)url;







@end
