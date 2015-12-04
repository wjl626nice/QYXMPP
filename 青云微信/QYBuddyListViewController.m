//
//  QYBuddyListViewController.m
//  青云微信
//
//  Created by 青云-wjl on 15/11/20.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYBuddyListViewController.h"
#import "QYNetConntect.h"
@interface QYBuddyListViewController ()<StatusDelegate,WXMessageDelegate>
//好友状态
@property (nonatomic, strong) NSMutableArray *statusList;


@property (nonatomic) BOOL isLogin;


@property (nonatomic, strong) QYNetConntect *netConnect;
@end

@implementation QYBuddyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //状态数组
    _statusList = [NSMutableArray array];
    //消息数组
    
    //通信连接
    _netConnect = [QYNetConntect shareNetConnect];
    //设置状态代理
    _netConnect.statusDelegate = self;
    //设置消息代理
    _netConnect.msgDelegate = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//登录
- (void)login{
    //清空数据
    //[_statusList removeAllObjects];
    
    //连接服务器
    [_netConnect connect];
    //更改左边的item上线状态
    self.navigationItem.leftBarButtonItem.title = @"on";
    _isLogin = YES;
    NSString *myID = [[NSUserDefaults standardUserDefaults] stringForKey:@"wxID"];
    self.navigationItem.title = [NSString stringWithFormat:@"%@的好友",myID];
}


- (void)logoff{
    //清空数据
    [_statusList removeAllObjects];
    
    //断开连接
    [_netConnect disConnect];
    //更改左边的item下线状态
    self.navigationItem.leftBarButtonItem.title = @"off";
    _isLogin = NO;
    
    [self.tableView reloadData];
}

//更改在线状态
- (IBAction)changeOnLine:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"on"]) {
        sender.title = @"off";
        [self logoff];
    }else if ([sender.title isEqualToString:@"off"]){
        sender.title = @"on";
        [self login];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    
    NSString *myID = [[NSUserDefaults standardUserDefaults] stringForKey:@"wxID"];
    
    if (myID != nil) {
        [self login];
        
    }else{
        [self performSegueWithIdentifier:@"login" sender:self];
    }
    
}

#pragma mark -好友状态更改

-(void)isOn:(Status *)status
{
    for (Status *s in _statusList) {
        if ([s.name isEqualToString:status.name]) {
            //移除旧的用户状态
            [_statusList removeObject:s];
            break;
        }
    }
    //添加状态
    [_statusList addObject:status];
    [self.tableView reloadData];
}

-(void)isOff:(Status *)status
{
    for (Status *s in _statusList) {
        if ([s.name isEqualToString:status.name]) {
            //更改旧的用户状态
            s.isOnLine = NO;
            break;
        }
    }
    //刷新界面
    [self.tableView reloadData];
}

#pragma mark - 收到消息
-(void)newMsg:(WXMessage *)message
{
    if (message.body != nil && ![message.body isEqualToString:@""]) {
        for (Status *s in _statusList) {
            if ([s.name isEqualToString:message.from]) {
                [s.messages addObject:message];
                break;
            }
        }
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _statusList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buddyListCell" forIndexPath:indexPath];
    
    
    Status *s = _statusList[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%ld)",s.name,s.messages.count];
    cell.imageView.image = s.isOnLine ? [UIImage imageNamed:@"online"] : [UIImage imageNamed:@"offlinepurple"];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"login"]) {
        UINavigationController *destinationNav = segue.destinationViewController;
        UIViewController *destinationVC = destinationNav.viewControllers[0];
        [destinationVC setValue:^{[self login];} forKeyPath:@"login"];
    }
}

//反向过渡
-(IBAction)unwindSegueToBListVC:(UIStoryboardSegue *)segue{
    
}

@end
