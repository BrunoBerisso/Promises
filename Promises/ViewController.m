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



typedef enum {
    PromisePending,
    PromiseFulfilled,
    PromiseRejected
} PromiseState;


@interface Promise : NSObject
@property (nonatomic) PromiseState state;

- (void)setFulfilledWithResult:(id)result;
- (void)setRejectedWithError:(NSError *)error;

- (Promise *)whenFulfilled:(SuccessHandler)success;
- (Promise *)whenRejected:(ErrorHandler)error;

@end


@implementation Promise

- (id)init {
    self = [super init];
    if (self)
        self.state = PromisePending;
    
    return self;
}

- (Promise *)whenFulfilled:(SuccessHandler)success {
    return self;
}

- (Promise *)whenRejected:(ErrorHandler)error {
    return self;
}

- (void)setFulfilledWithResult:(id)result {
    
}

- (void)setRejectedWithError:(NSError *)error {
    
}

@end






@interface ViewController ()

@end



@implementation ViewController (Example1)

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



@implementation ViewController (Example1_Promise)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    Promise *promisedResult = [self someAsyncTask];
    
    [promisedResult whenFulfilled:^(id result) {
        //Success with result 'result'
    }];
    
    [promisedResult whenRejected:^(NSError *error) {
        //Fail with error 'error'
    }];
    
    
    [[[self someAsyncTask] whenFulfilled:^(id result) {
        //Success with result 'result'
    }] whenRejected:^(NSError *error) {
        //Fail with error 'error'
    }];
}

- (Promise *)someAsyncTask {
    Promise *p = [Promise new]; //p.state == PromisePending;
    
    [self someAsyncTaskOnSuccess:^(id result) {
        [p setFulfilledWithResult:result]; //p.state == PromiseFulfilled;
    } onError:^(NSError *error) {
        [p setRejectedWithError:error]; //p.state == PromiseRejected;
    }];
    
    return p;
}

@end
