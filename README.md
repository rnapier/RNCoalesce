 Configure this object by providing it a block and a timeout. Once you
 call `fireWhenExpired`, the object is "armed." As long as you keep
 calling `fireWhenExpired` before the timeout, it will keep delaying.
 When the timer expires, it will execute the block.
 After firing, it will not fire again until `fireWhenExpired` is called,
 and the timer expires.
 While this object is armed, it self-retains until it fires. So if you
 release this object, and it would otherwise be deallocated, it will
 still perform the block after the timeout and then deallocate.
