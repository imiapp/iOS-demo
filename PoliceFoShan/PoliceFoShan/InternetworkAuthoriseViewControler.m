//
//  InternetworkAuthoriseViewControler.m
//  PoliceFoShan
//
//  Created by 汤书亚 on 2017/4/7.
//  Copyright © 2017年 汤书亚. All rights reserved.
//

#import "InternetworkAuthoriseViewControler.h"
#import <BuildIMISdk/BuildIMISdk.h>
#import "SVProgressHUD.h"
#import "InternetHttpTools.h"
/** 弱引用 */
#define VWWeakSelf __weak typeof(self) weakSelf = self;
@interface InternetworkAuthoriseViewControler ()
@property (weak, nonatomic) IBOutlet UILabel *allowLable;

/** WFVport_url */
@property (nonatomic, copy) NSString * WFVport_url;
/** topicID */
@property (nonatomic, copy) NSString * topicID;

@property (weak, nonatomic) IBOutlet UILabel *allowDataLable;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *numberLable;
@property (weak, nonatomic) IBOutlet UILabel *onLable;

@property (weak, nonatomic) IBOutlet UILabel *offLable;


@property (weak, nonatomic) IBOutlet UILabel *sioLable;
@property (weak, nonatomic) IBOutlet UILabel *endText;

@end

@implementation InternetworkAuthoriseViewControler

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title  = @"网上预约";
    self.allowLable.text = @"实名预约";
    self.allowLable.textColor = [UIColor darkGrayColor];
    self.allowDataLable.text = @" ";
    
    UITapGestureRecognizer * userTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allowLableClicked)];
    [self.allowLable addGestureRecognizer:userTap];
   
}

#pragma mark -- 1.使用IMI授权身份信息
-(void)allowLableClicked{
VWWeakSelf
    NSLog(@"触发了点按手势...");
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
    dictPrames[@"scope"] = @"snsapi_card";
    [tools postTopicIDparams:dictPrames success:^(id json) {
        if ([json[@"retCode"] isEqualToString:@"0000000"]) {
            NSString *topicID =  json[@"result"][@"topicId"];
            weakSelf.topicID = topicID;
            
            //调用sdk--启动imi
            [weakSelf reqAuthData];
        }
 
    } failure:^(NSError *error) {
          [SVProgressHUD showInfoWithStatus:error.localizedDescription];
    }];
    
}

#pragma mark -- 2.调用sdk，启动IMI
-(void)reqAuthData{
    VWWeakSelf
    BuildIMISdk *obj = [BuildIMISdk sharedInstance];
    InternetHttpTools *tools = [InternetHttpTools sharedInstance];
    NSMutableDictionary *dictPrames = [NSMutableDictionary dictionary];
    dictPrames[@"topicId"] = _topicID;
    dictPrames[@"scope"] = @"snsapi_idcard,snsapi_info";
    NSString *typeAuthorize =@"snsapi_idcard,snsapi_info";
   
    [obj reqAuthorize:typeAuthorize name:@"互联网医疗" andCreateChannelBlock:^NSString * _Nullable{
        return _topicID;
    } andIMIResponseHandler:^(NSString * _Nullable result, NSError * _Nullable error) {
        if ([result isEqualToString:@"success"]) {
          //获取用户数据
            [tools pullDataLoginParams:dictPrames success:^(id json) {
               
                NSLog(@"%@",json);
                weakSelf.allowLable.text = @"已成功预约";
                weakSelf.allowLable.textColor = [UIColor blueColor];
                weakSelf.allowDataLable.text = @"获取身份信息如下：";
                NSDictionary *infoDict = json[@"result"];
                NSString *idnumber = infoDict[@"cin"];
                NSString *sexString = infoDict[@"sex"];
                NSString *idname = infoDict[@"name"];
                NSString *idsio = infoDict[@"authority"];
                NSString *idissuedOff  =infoDict[@"doe"];
                NSString *idissuedOn =infoDict[@"doi"];
                
                weakSelf.nameLable.text = [NSString stringWithFormat:@"姓    名：%@",idname];
                weakSelf.numberLable.text = [NSString stringWithFormat:@"性    别 ：%@",sexString];
                weakSelf.onLable.text = [NSString stringWithFormat:@"身份证号：%@",idnumber];
                weakSelf.offLable.text = [NSString stringWithFormat:@"开始日期：%@",idissuedOn];
                weakSelf.sioLable.text = [NSString stringWithFormat:@"结束日期：%@",idissuedOff];
                weakSelf.endText.text = [NSString stringWithFormat:@"签发机关：%@",idsio];
            } failure:^(NSError *error) {
                [SVProgressHUD showInfoWithStatus:error.localizedDescription];
                
            }];
            
            
        }
        
    }];
    

}


@end
