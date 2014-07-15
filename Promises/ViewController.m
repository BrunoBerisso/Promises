//
//  ViewController.m
//  Promises
//
//  Created by Bruno Berisso on 7/15/14.
//  Copyright (c) 2014 Bruno Berisso. All rights reserved.
//

#import "ViewController.h"
#import <BFTask.h>
#import <BFTaskCompletionSource.h>



@interface AsyncStringGen : NSObject

+ (BFTask *)generate;

@end

@implementation AsyncStringGen

+ (BFTask *)generate {
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    
    int seconds = arc4random_uniform(3);
    int stringLenght = 5;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        char data[stringLenght];
        for (int x = 0; x < stringLenght; data[x++] = (char)('A' + (arc4random_uniform(26))));
        [completionSource setResult:[[NSString alloc] initWithBytes:data length:stringLenght encoding:NSUTF8StringEncoding]];
    });
    
    return completionSource.task;
}

@end












@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AsyncStringGen generate] continueWithBlock:^id(BFTask *task) {
        NSLog(@"%@", task.result);
        return nil;
    }];
}

@end
