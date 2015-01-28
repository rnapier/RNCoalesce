//
//  RNCoalesceTest.m
//  RNCoalesce
//
//  Created by Rob Napier on 1/28/15.
//  Copyright (c) 2015 Rob Napier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

#import "RNCoalesce.h"

@interface RNCoalesceTest : XCTestCase
@property (nonatomic, readwrite, strong) dispatch_queue_t queue;
@end

@implementation RNCoalesceTest

- (void)setUp {
    self.queue = dispatch_queue_create("", DISPATCH_QUEUE_SERIAL);
}

- (void)testRunOnce {
    __block int timesRun = 0;
    RNCoalesce *coalesce = [[RNCoalesce alloc] initWithTimeout:0.1 queue:self.queue block:^{
        timesRun++;
    }];

    [coalesce fireWhenExpired];

    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    XCTAssertEqual(timesRun, 1, @"Ran incorrect number of times: %d", timesRun);
    XCTAssertNotNil(coalesce); // Just to make sure coalesce doesn't evaporate
}

- (void)testRunNever {
    __block int timesRun = 0;
    RNCoalesce *coalesce = [[RNCoalesce alloc] initWithTimeout:0.1 queue:self.queue block:^{
        timesRun++;
    }];

    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    XCTAssertEqual(timesRun, 0, @"Ran incorrect number of times: %d", timesRun);
    XCTAssertNotNil(coalesce); // Just to make sure coalesce doesn't evaporate
}

- (void)testDelay {
    __block int timesRun = 0;
    RNCoalesce *coalesce = [[RNCoalesce alloc] initWithTimeout:0.5 queue:self.queue block:^{
        timesRun++;
    }];
    [coalesce fireWhenExpired];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.25]];
    XCTAssertEqual(timesRun, 0, @"Ran too soon (1)");

    [coalesce fireWhenExpired];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.25]];
    XCTAssertEqual(timesRun, 0, @"Ran too soon (2)");

    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    XCTAssertEqual(timesRun, 1, @"Didn't run");
    XCTAssertNotNil(coalesce); // Just to make sure coalesce doesn't evaporate
}

- (void)testDealloc {
    __block int timesRun = 0;
    {
        RNCoalesce *coalesce = [[RNCoalesce alloc] initWithTimeout:0.25 queue:self.queue block:^{
            timesRun++;
        }];
        [coalesce fireWhenExpired];
    }
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    XCTAssertEqual(timesRun, 1);
}

@end
