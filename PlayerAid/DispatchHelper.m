//
//  PlayerAid
//

#include "DispatchHelper.h"


void inline DISPATCH_AFTER(NSTimeInterval when, void (^block)())
{
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(when * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}
