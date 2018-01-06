//
//  TestRunloop.m
//  Test
//
//  Created by xiangnan.yang on 2018/1/5.
//  Copyright © 2018年 xiangnan.yang. All rights reserved.
//

#import "TestRunloop.h"

/*
 */

@interface TestRunloop ()

//@property (nonatomic, strong)NSPort *emptyPort;

@end

@implementation TestRunloop

- (void)start{
    NSThread *_thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadTest) object:nil];
    [_thread start];
    
}


#pragma mark -----

- (void)observer
{
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"RunLoop进入");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"RunLoop要处理Timers了");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"RunLoop要处理Sources了");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"RunLoop要休息了");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"RunLoop醒来了");
                break;
            case kCFRunLoopExit:
                NSLog(@"RunLoop退出了");
                break;
                
            default:
                break;
        }
    });
    // 添加观察者：监听RunLoop的状态
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    // 释放Observer
    CFRelease(observer);
}

                                                                       
                                                                       




- (void)threadTest
{
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(TimerTest) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] run];
}

- (void)TimerTest
{
    NSLog(@"----%@-----", [NSThread currentThread]);
}

#pragma mark -----

+ (void)memoryTest {
    for (int i = 0; i < 1000; ++i) {
        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
        [thread start];
    }
}
static NSPort *emptyPort = nil;

+ (void)run {
    @autoreleasepool {
        NSLog(@"current thread = %@", [NSThread currentThread]);
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        if (!emptyPort) {
            emptyPort = [NSMachPort port];
        }
        [runLoop addPort:emptyPort forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}


+ (void)memoryTest2 {
    for (int i = 0; i < 1000; ++i) {
        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
        [thread start];
        [self performSelector:@selector(stopThread) onThread:thread withObject:nil waitUntilDone:NO];
    }
}

+ (void)stopThread {
    [[NSRunLoop currentRunLoop]removePort:emptyPort forMode:NSDefaultRunLoopMode];
    CFRunLoopStop(CFRunLoopGetCurrent());
    [NSThread exit];
}




#pragma mark ----- afnetwork

+ (NSThread *)networkRequestThread {
    static NSThread *_networkRequestThread = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _networkRequestThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint:) object:nil];
        [_networkRequestThread start];
    });
    return _networkRequestThread;
}

+ (void)networkRequestThreadEntryPoint:(id)__unused object {
    @autoreleasepool {
        [[NSThread currentThread] setName:@"AFNetworking"];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}

@end
