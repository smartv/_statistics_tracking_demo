//
//  UIApplication+EventAutomator.m
//  Coffee Timer
//
//  Created by Matin Movassate on 4/27/14.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

#import "UIApplication+EventAutomator.h"
#import <objc/runtime.h>

@implementation UIApplication (EventAutomator)

+ (void)load {
    // This implementation of swizzling was lifted from http://nshipster.com/method-swizzling
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(sendAction:to:from:forEvent:);
        SEL swizzledSelector = @selector(heap_sendAction:to:from:forEvent:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (BOOL)heap_sendAction:(SEL)action to:(id)target from:(id)sender forEvent:(UIEvent *)event {
    NSString *selectorName = NSStringFromSelector(action);
    // Sometimes this method proxies through to its internal method. We want to ignore those calls.
    if (![selectorName isEqualToString:@"_sendAction:withEvent:"]) {
        printf("Selector %s occurred.\n", [selectorName UTF8String]);
    }
    return [self heap_sendAction:action to:target from:sender forEvent:event];
}

@end