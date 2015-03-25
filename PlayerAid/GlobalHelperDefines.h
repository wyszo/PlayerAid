//
//  PlayerAid
//

#ifndef PlayerAid_Header_h
#define PlayerAid_Header_h

#define defineWeakSelf() __weak typeof(self) weakSelf = self

typedef void (^VoidBlock)();
typedef void (^BlockWithFloatParameter)(CGFloat);
typedef void (^CellAtIndexPathBlock)(UITableViewCell *cell, NSIndexPath *indexPath);
typedef void (^IndexPathBlock)(NSIndexPath *indexPath);

#endif
