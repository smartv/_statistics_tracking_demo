//
//  ViewController.m
//  tracking_demo
//
//  Created by luguobin on 15/9/21.
//  Copyright © 2015年 XS. All rights reserved.
//

#import "ViewController.h"
//#import "UIControl+Tracking.h"

@interface ViewController ()

@end

@implementation ViewController

+ (void)load
{
    
    //Appdelegate Thinning
    __block id observer =
    [[NSNotificationCenter defaultCenter]
     addObserverForName:UIApplicationDidFinishLaunchingNotification
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         [self setupSomeModule]; // Do whatever you want
         [[NSNotificationCenter defaultCenter] removeObserver:observer];
     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 内联语法
    UIView *bg = ({
        
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        view.backgroundColor = [UIColor redColor];
        view.alpha = 0.8f;
        [self.view addSubview:view];
        view;
    });
    
    // 对象 等于 内存地址 加偏移量
    NSString *name = @"sunnyxx";
    id cls = [Sark class];
    void *obj = &cls;
    [(__bridge id)obj speak];
}



- (IBAction)test:(id)sender {
//
//    UITapGestureRecognizer *gestrue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInfoLabel)];
//    [self.tipBackground addGestureRecognizer:gestrue];

    
    NSLog(@"----sgfsg");
}


+ (void)setupSomeModule {
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    NSArray *allModes = CFBridgingRelease(CFRunLoopCopyAllModes(runLoop));
    while (1) {
        for (NSString *mode in allModes) {
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }
}

@end
