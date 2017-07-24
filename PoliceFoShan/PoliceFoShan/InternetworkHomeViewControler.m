//
//  InternetworkHomeViewControler.m
//  PoliceFoShan
//
//  Created by 汤书亚 on 2017/3/24.
//  Copyright © 2017年 汤书亚. All rights reserved.
//

#import "InternetworkHomeViewControler.h"
#import <BuildIMISdk/BuildIMISdk.h>
#import "SVProgressHUD.h"
#import "InternetworkLoginViewControler.h"
#import "InternetworkAuthoriseViewControler.h"
#import "InternetHttpTools.h"

/** 弱引用 */
#define VWWeakSelf __weak typeof(self) weakSelf = self;
@interface InternetworkHomeViewControler ()

/** InternetworkLoginViewControler */
@property (nonatomic, strong) InternetworkLoginViewControler *policVC;
@property (nonatomic, strong) NSString *topicId;
@end

@implementation InternetworkHomeViewControler

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"互联网+医疗";

}
#pragma mark -- 1.使用IMI登录
- (IBAction)allowLoginButton:(UIButton *)sender {
    VWWeakSelf
    BuildIMISdk *obj = [BuildIMISdk sharedInstance];
    BOOL isInstall = [obj isIMIinstalled];
    if (!isInstall) {
        [SVProgressHUD showInfoWithStatus:@"未安装IMI_APP"];
        return;
    }
//获取topicId
    InternetHttpTools *tools = [InternetHttpTools sharedInstance];
    NSMutableDictionary *dictPrames = [NSMutableDictionary dictionary];
    dictPrames[@"version"] = @"2.0.4";
    dictPrames[@"scope"] = @"snsapi_info";
   [tools postTopicIDparams: dictPrames success:^(id json) {
       if ([json[@"retCode"] isEqualToString:@"0000000"]) {
           NSString *topicID =  json[@"result"][@"topicId"];
           weakSelf.topicId = topicID;
           
           //调用sdk--启动imi
           [weakSelf reqInfoData];
       }
    } failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"获取topicId失败"];
    }];
}

#pragma mark -- 2.调用sdk，启动IMI
-(void)reqInfoData{
    BuildIMISdk *obj = [BuildIMISdk sharedInstance];
    InternetHttpTools *tools = [InternetHttpTools sharedInstance];
    VWWeakSelf
    [obj reqLogin:@"互联网医疗" andCreateChannelBlock:^NSString * _Nullable{
        return _topicId;
    } andIMIResponseHandler:^(NSString * _Nullable result, NSError * _Nullable error) {
        if ([result isEqualToString:@"success"]) {
            //请求数据
            NSMutableDictionary *pullPrames = [NSMutableDictionary dictionary];
            pullPrames[@"topicId"] = _topicId;
            pullPrames[@"scope"] = @"snsapi_info";
            [tools pullDataLoginParams:pullPrames success:^(id json) {
                
                NSLog(@"%@",json);
                weakSelf.policVC = [[InternetworkLoginViewControler alloc] init];
                weakSelf.policVC.loginInfoDict = json;
                [weakSelf.navigationController pushViewController:weakSelf.policVC animated:YES];
            } failure:^(NSError *error) {
                [SVProgressHUD showInfoWithStatus:error.localizedDescription];
                
            }];
        }
        
        }];
    
}


- (IBAction)loginInButton:(UIButton *)sender {
    
    InternetworkAuthoriseViewControler *idViewController = [[InternetworkAuthoriseViewControler alloc] init];
    [self.navigationController pushViewController:idViewController animated:YES];
    
}


@end
