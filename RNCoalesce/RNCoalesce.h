//
//  RNCoalesce.h
//  RNCoalesce
//
//  Created by Rob Napier on 1/28/15.
//  Copyright (c) 2015 Rob Napier. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Configure this object by providing it a block and a timeout. Once you
 call `fireWhenExpired`, the object is "armed." As long as you keep
 calling `fireWhenExpired` before the timeout, it will keep delaying.
 When the timer expires, it will execute the block.

 After firing, it will not fire again until `fireWhenExpired` is called,
 and the timer expires.

 While this object is armed, it self-retains until it fires. So if you
 release this object, and it would otherwise be deallocated, it will
 still perform the block after the timeout and then deallocate.
 */


@interface RNCoalesce : NSObject
- (instancetype)initWithTimeout:(NSTimeInterval)timeout
                          block:(dispatch_block_t)block;
- (void)fireWhenExpired;

@end
