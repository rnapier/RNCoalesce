//
//  RNCoalesce.m
//  RNCoalesce
//
//  Created by Rob Napier on 1/28/15.
//  Copyright (c) 2015 Rob Napier. All rights reserved.
//

#import "RNCoalesce.h"

@interface RNCoalesce ()
@property (nonatomic, readwrite, assign) NSTimeInterval timeout;
@property (nonatomic, readwrite, strong) NSTimer *timer;
@property (nonatomic, readwrite, strong) dispatch_block_t block;
@end

@implementation RNCoalesce

- (instancetype)initWithTimeout:(NSTimeInterval)timeout
                          block:(dispatch_block_t)block {
    if (self = [super init]) {
        _timeout = timeout;
        _block = block;
    }
    return self;
}

- (void)fireWhenExpired {
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeout target:self selector:@selector(fire) userInfo:nil repeats:NO];
}

- (void)fire {
    self.block();
    self.timer = nil;
}

@end
