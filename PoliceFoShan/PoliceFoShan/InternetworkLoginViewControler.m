//
//  InternetworkLoginViewControler.m
//  PoliceFoShan
//
//  Created by 汤书亚 on 2017/3/23.
//  Copyright © 2017年 汤书亚. All rights reserved.
//

#import "InternetworkLoginViewControler.h"
#import "SVProgressHUD.h"



@interface InternetworkLoginViewControler ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLable;
@property (weak, nonatomic) IBOutlet UILabel *mobileLable;


@end

@implementation InternetworkLoginViewControler

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"互联网+医疗";
    NSDictionary *infoDict = self.loginInfoDict[@"result"];
    NSString *mobile = infoDict[@"mobile"];
    NSString *userN = infoDict[@"userName"];
    self.userNameLable.text = [NSString stringWithFormat:@"用户名：%@",userN];
    self.mobileLable.text = [NSString stringWithFormat:@"手机号：%@",mobile];
    
}





@end
