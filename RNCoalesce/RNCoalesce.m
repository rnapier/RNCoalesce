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
@property (nonatomic, readwrite, strong) dispatch_queue_t queue;
@property (nonatomic, readwrite, strong) dispatch_block_t block;
@property (nonatomic, readwrite, strong) dispatch_source_t timerSource;
@end

@implementation RNCoalesce

- (instancetype)initWithTimeout:(NSTimeInterval)timeout
                          queue:(dispatch_queue_t)queue
                          block:(dispatch_block_t)block {
    if (self = [super init]) {
        _timeout = timeout;
        _queue = queue;
        _block = block;
        _timerSource = nil;
    }
    return self;
}

- (void)createTimerIfNeeded {
    if (self.timerSource == nil) {
        self.timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                                  0, 0,
                                                  self.queue);
        dispatch_source_set_event_handler(self.timerSource, self.block);
        dispatch_resume(self.timerSource);
    }
}

- (void)fireWhenExpired {
    [self createTimerIfNeeded];
    uint64_t nsec = (uint64_t)(self.timeout * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timerSource,
                              dispatch_time(DISPATCH_TIME_NOW, nsec),
                              DISPATCH_TIME_FOREVER,
                              0);
}

- (void)dealloc {
    if (_timerSource != nil) {
        dispatch_source_cancel(_timerSource);
    }
}

@end
