//
//  PlayerAid
//

#include "DispatchHelper.h"

void inline DISPATCH_AFTER(NSTimeInterval when, void (^block)())
{
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(when * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

void DISPATCH_ASYNC(QueuePriority priority, void (^block)())
{
  AssertTrueOrReturn(block); // TODO: not safe for C functions! Will crash
  
  dispatch_async(dispatch_get_global_queue(priority, 0), ^{
    block();
  });
}