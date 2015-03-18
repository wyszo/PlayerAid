//
//  PlayerAid
//

@interface NSObject (ObjectLifetime)

- (void)bindLifetimeTo:(NSObject *)owner;
- (void)releaseLifetimeDependencyFrom:(NSObject *)owner;

@end
