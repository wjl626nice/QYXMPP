//
//  QYWXModel.h
//  青云微信
//
//  Created by 青云-wjl on 15/11/29.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
//消息
@interface WXMessage : NSObject
@property (nonatomic, strong) NSString *body;   //正文
@property (nonatomic, strong) NSString *from;   //来源
@property (nonatomic) BOOL isComposing;         //输入中
@property (nonatomic) BOOL isDelay;             //离线消息
@property (nonatomic) BOOL isMe;                //本人所发
@end

//状态
@interface Status : NSObject
@property (nonatomic, strong) NSString *name;   //用户名
@property (nonatomic) BOOL isOnLine;            //是否在线
@property (nonatomic, strong) NSMutableArray *messages;
@end

//消息协议
@protocol WXMessageDelegate <NSObject>
@optional
-(void)newMsg:(WXMessage *)message;             //收到新消息
@end

//状态协议
@protocol StatusDelegate <NSObject>
@optional
-(void)isOn:(Status *)status;                   //上线
-(void)isOff:(Status *)status;                  //下线
@end

