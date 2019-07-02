//
//  ViewController.m
//  XHWebViewBridgeDemo
//
//  Created by icochu on 2019/4/29.
//  Copyright © 2019 Sniper. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <WebKit/WKWebView.h>
#import "XHWebView.h"
@interface ViewController ()<XHWebViewDelegate,UIScrollViewDelegate>
@property (nonatomic ,strong) XHWebView *indexWebView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _indexWebView = [[XHWebView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    _indexWebView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_indexWebView];
    //加载本地网页
    [self startLoad];
    WKWebView *webView = (WKWebView *)_indexWebView.realWebView;
    webView.scrollView.backgroundColor = [UIColor whiteColor];
    webView.scrollView.delegate = self;
    
    [self loadButton];
}

- (void)startLoad {
    //网页资源
    NSString *indexPath = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"index.html"];
    //加载相应的网页
    [_indexWebView loadRequest:[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:indexPath]]];
}

- (void)loadButton {
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(50, 200, 150, 50)];
    [button1 setTitle:@"oc调用js方法1" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button1 setBackgroundColor:[UIColor cyanColor]];
    [button1 addTarget:self action:@selector(button1Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(250, 200, 150, 50)];
    [button2 setTitle:@"oc调用js方法2" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button2 setBackgroundColor:[UIColor cyanColor]];
    [button2 addTarget:self action:@selector(button2Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
}
- (void)webViewDidFinishLoad:(XHWebView *)webView {
    [_indexWebView evaluateJavaScript:@"window.alert('OC调用网页打印：页面加载完成')" completionHandler:^(id object, NSError *error) {
        NSLog(@"influx js success");
    }];
}

- (void)button1Action {
    [_indexWebView evaluateJavaScript:@"ocCalljsfun1('OC调用网页打印')" completionHandler:^(id object, NSError *error) {
        NSLog(@"influx js success");
    }];
}

- (void)button2Action {
    [_indexWebView evaluateJavaScript:@"ocCalljsfun2('OC调用网页打印,传递一个参数')" completionHandler:^(id object, NSError *error) {
        NSLog(@"--------JS回传给OC参数：%@------------",object);
    }];
}
@end
