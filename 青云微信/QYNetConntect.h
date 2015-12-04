//
//  QYNetConntect.h
//  青云微信
//
//  Created by 青云-wjl on 15/11/29.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"
#import "QYWXModel.h"
@interface QYNetConntect : NSObject<XMPPStreamDelegate,WXMessageDelegate,StatusDelegate>
{
    
}
@property (nonatomic, strong) XMPPStream *xmppStream;//通道
@property (nonatomic) BOOL isOpen;//服务器是否开启
@property (nonatomic) NSString *passWord;//密码

@property (nonatomic, assign) id <StatusDelegate> statusDelegate;
@property (nonatomic, assign) id <WXMessageDelegate> msgDelegate;


+(instancetype)shareNetConnect;

//连接服务器（查看服务器是否可连接）
-(BOOL)connect;

//断开连接
-(void)disConnect;
@end
