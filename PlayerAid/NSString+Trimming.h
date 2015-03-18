//
//  PlayerAid
//

@interface NSString (Trimming)

- (NSString *)stringByRemovingLastOccurrenceOfString:(NSString *)stringToReplace fromLastNumberOfCharacters:(NSInteger)characterRange;

@end
