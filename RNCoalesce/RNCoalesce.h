//
//  RNCoalesce.h
//  RNCoalesce
//
//  Created by Rob Napier on 1/28/15.
//  Copyright (c) 2015 Rob Napier. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Configure this object by providing it a block, a queue and a timeout.
 Once you call `fireWhenExpired`, the object is "armed." As long as you
 keep calling `fireWhenExpired` before the timeout, it will keep delaying.
 When the timer expires, it will execute the block.

 After firing, it will not fire again until `fireWhenExpired` is called,
 and the timer expires.

 If this object is deallocated while a fire event is pending, it will
 immediately fire block before deallocating. (This object does not
 self-retain.)
 */


@interface RNCoalesce : NSObject
- (instancetype)initWithTimeout:(NSTimeInterval)timeout
                          queue:(dispatch_queue_t)queue
                          block:(dispatch_block_t)block;
- (void)fireWhenExpired;

@end
