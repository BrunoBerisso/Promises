//
//  ViewController.m
//  Promises
//
//  Created by Bruno Berisso on 7/15/14.
//  Copyright (c) 2014 Bruno Berisso. All rights reserved.
//

#import "ViewController.h"



typedef void(^SuccessHandler)(id result);
typedef void(^ErrorHandler)(NSError *error);



@interface ViewController ()

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self someAsyncTaskOnSuccess:^(id result) {
        //Success with result 'result'
    } onError:^(NSError *error) {
        //Fail with error 'error'
    }];
}


- (void)someAsyncTaskOnSuccess:(SuccessHandler)success onError:(ErrorHandler)error {
    
}


@end
