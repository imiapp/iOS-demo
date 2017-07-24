//
//  InternetworkAuthoriseViewControler.h
//  PoliceFoShan
//
//  Created by 汤书亚 on 2017/4/7.
//  Copyright © 2017年 汤书亚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InternetworkAuthoriseViewControler : UIViewController

/** 登录授权信息 */
@property (nonatomic, copy) NSString * allowInfoString;
@property (nonatomic, strong) NSDictionary * allowInfoDict;

@end
