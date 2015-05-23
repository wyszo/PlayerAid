//
//  PlayerAid
//

#ifndef DispatchHelper_h
#define DispatchHelper_h

typedef NS_ENUM(long, QueuePriority) {
  QueuePriorityHigh = DISPATCH_QUEUE_PRIORITY_HIGH,
  QueuePriorityLow = DISPATCH_QUEUE_PRIORITY_LOW,
  QueuePriorityBackground = DISPATCH_QUEUE_PRIORITY_BACKGROUND,
  QueuePriorityDefault = DISPATCH_QUEUE_PRIORITY_DEFAULT
};


extern void DISPATCH_AFTER(NSTimeInterval when, void (^block)());
extern void DISPATCH_ASYNC(QueuePriority priority, void (^block)());

#endif