//
//  InternetHttpTools.h
//  PoliceFoShan
//
//  Created by 汤书亚 on 2017/7/20.
//  Copyright © 2017年 汤书亚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InternetHttpTools : NSObject
+ (instancetype)sharedInstance;
- (void)postTopicIDparams:(NSDictionary*)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
- (void)pullDataLoginParams:(NSDictionary*)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
@end
