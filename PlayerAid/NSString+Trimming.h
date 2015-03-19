//
//  PlayerAid
//

@interface NSString (Trimming)

- (NSString *)stringByTrimmingWhitespaceAndNewline;
- (NSString *)stringByRemovingLastOccurrenceOfString:(NSString *)stringToReplace fromLastNumberOfCharacters:(NSInteger)characterRange;

@end
