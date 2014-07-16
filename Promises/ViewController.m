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


/******************************************************************************************************************************************************/
/******************************************************************************************************************************************************/

NSString *randomStringOfLenght(int stringLenght) {
    char data[stringLenght];
    for (int x = 0; x < stringLenght; data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:stringLenght encoding:NSUTF8StringEncoding];
}


@interface AsyncStringGen : NSObject

+ (BFTask *)generate;
+ (BFTask *)generateAndAppendTo:(NSString *)otherString;

@end

@implementation AsyncStringGen

+ (BFTask *)generate {
    return [self generateAndAppendTo:nil];
}

+ (BFTask *)generateAndAppendTo:(NSString *)otherString {
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    
    int seconds = arc4random_uniform(3);
    int stringLenght = 6;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *string = randomStringOfLenght(stringLenght);
        NSString *result = [NSString stringWithFormat:@"%@%@", otherString ? otherString : @"", string];
        
        [completionSource setResult:result];
//        [completionSource setError:[NSError errorWithDomain:@"Promises" code:0 userInfo:@{NSLocalizedDescriptionKey: result}]];
//        [completionSource setException:[NSException exceptionWithName:@"PromisesException" reason:@"NoReason" userInfo:@{NSLocalizedDescriptionKey: result}]];
//        [completionSource cancel];
    });
    
    return completionSource.task;
}

@end


/******************************************************************************************************************************************************/
/******************************************************************************************************************************************************/


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *someStrings = @[@"First ", @"Second ", @"Third "];
    BFTask *serialTask = [BFTask taskWithResult:nil];
    
    for (NSString *string in someStrings) {
        serialTask = [serialTask continueWithSuccessBlock:^id(BFTask *task) {
            
            NSLog(@"Partial result: %@", task.result);
            
            NSString *previousResult = task.result ?: @"";
            NSString *newString = [previousResult stringByAppendingFormat:@" - %@", string];
            
            return [AsyncStringGen generateAndAppendTo:newString];
        }];
    }
    
    [serialTask continueWithBlock:^id(BFTask *task) {
        self.resultLabel.text = task.result;
        return nil;
    }];
}

@end
