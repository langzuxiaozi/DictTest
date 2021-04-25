//
//  ViewController.m
//  DictTest
//
//  Created by zhao.yan on 2021/4/25.
//

#import "ViewController.h"
#include <objc/runtime.h>

@interface ViewController ()

@property (nonatomic,strong) NSOperationQueue * queue;
@property (nonatomic,strong) NSMutableDictionary * dic;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dic = [NSMutableDictionary new];
    self.queue = [NSOperationQueue new];

    [self dictionaryTest1];
    [self dictionaryTest2];
}
- (void)dictionaryTest1{
    for (int i = 0;i<1000;i++){
        int r = arc4random_uniform(160)*8;
        NSString *key = [NSString stringWithFormat:@"this is a key:%@",@(r)];
        id value = class_createInstance([NSObject class], r);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"赋值开始 ： key： %@ value:%@",key,value);
            self.dic[key] = value;
            NSLog(@"赋值结束");
        });
    }
}
- (void)dictionaryTest2{
    self.queue.maxConcurrentOperationCount = 1;
    for (int i = 0;i<1000;i++){
        
        [self.queue addOperationWithBlock:^{
            // 第一个循环任务：随机申请 key 和 value（value 的大小是随机的，模拟线上情况），并放入字典
            int r = arc4random_uniform(160) * 8;
            NSString *key = [NSString stringWithFormat:@"this is a key:%@", @(r)];
            id value = class_createInstance([NSObject class], r);
            
            NSLog(@"赋值开始:key:%@:value:%@", key, value);
            
            self.dic[key] = value;
            
            NSLog(@"赋值开始:key:%@:value:%@", key, value);
            NSLog(@"赋值结束");
        }];
    }
}

@end
