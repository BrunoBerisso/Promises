//
//  ViewController.m
//  Promises
//
//  Created by Bruno Berisso on 7/15/14.
//  Copyright (c) 2014 Bruno Berisso. All rights reserved.
//

#import "ViewController.h"


@class Promise;

typedef void(^SuccessHandler)(id result);
typedef void(^ErrorHandler)(NSError *error);
typedef Promise *(^ChainHandler)(id result);
typedef id(^ChainDo)(id result);


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

- (Promise *)thenContinueWith:(ChainHandler)chain;
- (id)thenDo:(ChainDo)chain;
- (void)done:(ChainDo)chain;

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

- (Promise *)thenContinueWith:(ChainHandler)chain {
    return chain(nil);
}

- (Promise *)thenDo:(ChainDo)chain {
    return self;
}

- (void)done:(ChainDo)chain {
    chain(nil);
}

- (void)setFulfilledWithResult:(id)result {
    
}

- (void)setRejectedWithError:(NSError *)error {
    
}

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
    
    //V 1.0
    Promise *promisedResult = [self someAsyncTask];
    
    [promisedResult whenFulfilled:^(id result) {
        //Success with result 'result'
    }];
    
    [promisedResult whenRejected:^(NSError *error) {
        //Fail with error 'error'
    }];
    
    //V 2.0
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







@implementation ViewController (Example2_Chaining)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //Example2 - Continue
    [[[self someAsyncTask] thenContinueWith:^Promise *(id result) {
        return [self someOtherAsyncTaskWithParam:result];
    }] whenFulfilled:^(id result) {
        //Both tasks end and result is the last one
    }];
    
    
    [self someAsyncTaskOnSuccess:^(id result) {
        
        [self someAsyncTaskOnSuccess:^(id result) {
            //Both tasks end and result is the last one
        } onError:^(NSError *error) {
            //Fail with error 'error'
        }];
        
    } onError:^(NSError *error) {
        //Fail with error 'error'
    }];
    
    
    //Example2 - Do
    
    [[[[self someAsyncTask] thenDo:^id(id result) {
        return @([result integerValue] + 1);
    }] thenDo:^id(id result) {
        return @([result integerValue] + 2);
    }] done:^id(id result) {
        //Final result: 3
        return nil;
    }];
    
    
}


- (Promise *)someOtherAsyncTaskWithParam:(id)param {
    return nil;
}

@end
