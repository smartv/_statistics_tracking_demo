//
//  UIControl+Tracking.m
//  tracking_demo
//
//  Created by luguobin on 15/9/21.
//  Copyright © 2015年 XS. All rights reserved.
//

/**
 * 用来统计点击事件，，
 */

#import "UIControl+Tracking.h"
#import <objc/runtime.h>
#import <objc/message.h>
//#import "UMengStatistics.h"
@implementation UIControl (Tracking)


+ (void)load
{
    [self changeAddTarget];
}

/**
 * 在创建control的时候先交换addTarget:action:forControlEvents:方法，在addTarget:action:forControlEvents:方便在方法里添加点击事件
 */
+ (void)changeAddTarget
{
    Class class = [self class];
    
    SEL originalSelector = @selector(addTarget:action:forControlEvents:);
    SEL swizzledSelector = @selector(xs_addTarget:action:forControlEvents:);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    //交换实现
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

/**
 * 交换的点击事件，先添加target事件，然后进行交换
 *
 */
- (void)xs_addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self xs_addTarget:target action:action forControlEvents:controlEvents];
    
    Class class = [target class];
    
    NSString *oldSelString = NSStringFromSelector(action);
    // 防止出现反复交换的问题
    if ([oldSelString rangeOfString:@"cimc_"].location != NSNotFound) {
        return;
    }
    
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"cimc_%@",oldSelString]);
    SEL actionSel = action;
    
    if (class_addMethod(class, selector, (IMP)xs_buttonAction, "v@:@")) {
        Method dis_originalMethod = class_getInstanceMethod(class, actionSel);
        Method dis_swizzledMethod = class_getInstanceMethod(class, selector);
        
        //交换实现
        method_exchangeImplementations(dis_originalMethod, dis_swizzledMethod);
    }
}

/**
 * control点击事件最后的实现，可以拼接[self class]和事件方法弄个字符串，建个配置表
 *
 * @param self   target，一般为所在ViewController
 * @param _cmd   事件方法，点击的事件方法
 * @param sender sender，点击的button
 */
void  xs_buttonAction(id self, SEL _cmd, id sender) {

    //此处添加你想统计的打点事件
    
    
    NSString *oldSelString = NSStringFromSelector(_cmd);
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"cimc_%@",oldSelString]);
    ((void(*)(id, SEL,id))objc_msgSend)(self, selector, sender);
    NSLog(@"--------%@-------",oldSelString,sender);
}
@end
