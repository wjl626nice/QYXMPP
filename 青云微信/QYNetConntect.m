//
//  QYNetConntect.m
//  青云微信
//
//  Created by 青云-wjl on 15/11/29.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYNetConntect.h"

@implementation QYNetConntect

+(instancetype)shareNetConnect
{
    static QYNetConntect *connect;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (connect == nil ) {
            connect = [[self alloc] init];
        }
    });
    return connect;
}

//建立通道
-(void)buildStream
{
    //建立通道
    _xmppStream = [[XMPPStream alloc]init];
    //设置总代理 主线程里
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

//发送上线状态
-(void)goOnLine
{
    //状态
    XMPPPresence *p = [XMPPPresence presence];
    
    //发送状态
    [_xmppStream sendElement:p];
}

//发送下线状态
-(void)goOffLine
{
    //状态
    XMPPPresence *p = [XMPPPresence presenceWithType:@"unavailable"];
    
    //发送状态
    [_xmppStream sendElement:p];
}

//连接服务器（查看服务器是否可连接）
-(BOOL)connect
{
    //建立通道
    if (_xmppStream == nil) {
        [self buildStream];
    }
    
    //判断通道是否连接
    if (_xmppStream.isConnected) {
        return YES;
    }
    //取到用户名、密码、以及服务器，连接服务器
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"wxID"];
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"wxPWD"];
    NSString *localhost = [[NSUserDefaults standardUserDefaults] stringForKey:@"wxServer"];
    
    if (username != nil && password != nil) {
        //通道的用户名
        _xmppStream.myJID = [XMPPJID jidWithString:username];
        //域名
        _xmppStream.hostName = localhost;
        //密码
        _passWord = password;
        //连接服务器
        return [_xmppStream connectWithTimeout:5000 error:nil];
    }
    return NO;
}


//断开连接
-(void)disConnect
{
    if (_xmppStream != nil) {
        if (_xmppStream.isConnected) {
            //下线
            [self goOffLine];
            //断开连接
            [_xmppStream disconnect];
        }
    }
}


#pragma mark -XMPPStreamDelegate

//连接成功
-(void)xmppStreamDidConnect:(XMPPStream *)sender
{
    //已经连接
    _isOpen = YES;
    NSError *err = nil;
    //验证密码
    [_xmppStream authenticateWithPassword:_passWord error:&err];
}

//验证成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    //上线
    [self goOnLine];
}

//收到状态
-(void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    NSLog(@"%@",presence);
    //自己的用户名
    NSString *myUser = sender.myJID.user;
    
    //好友用户名
    NSString *friendUser = presence.from.user;
    
    //用户名所在的域
    NSString *domain = presence.from.domain;
    
    //状态类型
    NSString *pType = presence.type;
    
    //判断上线的状态不是自己的
    if (![myUser isEqualToString:friendUser]) {
        //状态保存的结构
        Status *s = [[Status alloc] init];
        s.messages = [NSMutableArray array];
        //保存了状态的用户名
        s.name = [NSString stringWithFormat:@"%@@%@",friendUser,domain];
        
        if ([pType isEqualToString:@"available"]) {                 //上线
            s.isOnLine = YES;
            [_statusDelegate isOn:s];
        }else if ([pType isEqualToString:@"unavailable"]){          //下线
            [_statusDelegate isOff:s];
        }
    }
}

//收到消息
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    //NSLog(@"message:%@",message);
    //如果是聊天消息
    if (message.isChatMessage) {
        WXMessage *msg = [[WXMessage alloc] init];
        
        //对方正在输入
        if ([message elementForName:@"composing"] != nil) {
            msg.isComposing = YES;
        }
        
        //离线消息
        if ([message elementForName:@"delay"] != nil) {
            msg.isDelay = YES;
        }
        
        //消息正文
        NSXMLElement *body = [message elementForName:@"body"];
        if (body != nil) {
            msg.body = [body stringValue];
        }
        
        //来源（完整的用户名）
        msg.from = [NSString stringWithFormat:@"%@@%@",message.from.user,message.from.domain];
        
        [_msgDelegate newMsg:msg];
    }
}

@end
