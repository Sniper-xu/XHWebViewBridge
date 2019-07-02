//
//  XHWebView.h
//  XHWebViewBridgeDemo
//
//  Created by icochu on 2019/4/29.
//  Copyright © 2019 Sniper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBridge.h"

NS_ASSUME_NONNULL_BEGIN
@class XHWebView;

@protocol XHWebViewDelegate <NSObject>

@optional
//加载函数
- (void)webViewDidStartLoad:(XHWebView *)webView;

- (void)webViewDidFinishLoad:(XHWebView *)webView;

- (void)webView:(XHWebView *)webView didFailLoadWithError:(NSError *)error;

- (BOOL)webView:(XHWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end

@interface XHWebView : UIView

@property(weak,nonatomic)id<XHWebViewDelegate> delegate;

@property(strong,nonatomic) XHBridge* bridge;

///内部使用的webView
@property (nonatomic, readonly) id realWebView;

///是否正在使用 UIWebView
@property (nonatomic, readonly) BOOL usingUIWebView;

///预估网页加载进度
@property (nonatomic, readonly) double estimatedProgress;

@property (nonatomic, readonly) NSURLRequest *originRequest;

///---- UI 或者 WK 的API
@property (nonatomic, readonly) UIScrollView *scrollView;
//网页的title
@property (nonatomic, readonly, copy) NSString *title;

@property (nonatomic, readonly) NSURLRequest *currentRequest;

@property (nonatomic, readonly) NSURL *URL;

@property (nonatomic, readonly, getter=isLoading) BOOL loading;
// 是否可以后退
@property (nonatomic, readonly) BOOL canGoBack;
// 是否可以向前
@property (nonatomic, readonly) BOOL canGoForward;

///是否根据视图大小来缩放页面  默认为YES
@property (nonatomic) BOOL scalesPageToFit;

///使用UIWebView
- (instancetype)initWithFrame:(CGRect)frame usingUIWebView:(BOOL)usingUIWebView;
//加载请求
- (id)loadRequest:(NSURLRequest *)request;

- (id)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;
//返回
- (id)goBack;
//前进
- (id)goForward;
//重新加载
- (id)reload;
//会比较网络数据是否有变化，没有变化则使用缓存，否则从新请求
- (id)reloadFromOrigin;
//停止加载
- (void)stopLoading;
//本地调用js
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler;

///不建议使用这个办法  因为会在内部等待webView 的执行结果
- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)javaScriptString __deprecated_msg("Method deprecated. Use [evaluateJavaScript:completionHandler:]");

//back 层数
- (NSInteger)countOfHistory;
//可以跳转到某个指定历史页面
- (void)gobackWithStep:(NSInteger)step;
@end

NS_ASSUME_NONNULL_END
