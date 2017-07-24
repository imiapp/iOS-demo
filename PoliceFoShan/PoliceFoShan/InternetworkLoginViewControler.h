//
//  InternetworkLoginViewControler.h
//  PoliceFoShan
//
//  Created by 汤书亚 on 2017/3/23.
//  Copyright © 2017年 汤书亚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InternetworkLoginViewControler : UIViewController
/** 登录授权信息 */
@property (nonatomic, copy) NSString * loginInfoString;
@property (nonatomic, strong) NSDictionary * loginInfoDict;
@end
