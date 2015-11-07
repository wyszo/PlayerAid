// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tutorial.m instead.

#import "_Tutorial.h"

const struct TutorialAttributes TutorialAttributes = {
	.createdAt = @"createdAt",
	.draft = @"draft",
	.flaggedAsInappropriate = @"flaggedAsInappropriate",
	.hidden = @"hidden",
	.imageURL = @"imageURL",
	.inReview = @"inReview",
	.jpegImageData = @"jpegImageData",
	.serverID = @"serverID",
	.state = @"state",
	.title = @"title",
};

const struct TutorialRelationships TutorialRelationships = {
	.consistsOf = @"consistsOf",
	.createdBy = @"createdBy",
	.likedBy = @"likedBy",
	.section = @"section",
};

@implementation TutorialID
@end

@implementation _Tutorial

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Tutorial" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Tutorial";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Tutorial" inManagedObjectContext:moc_];
}

- (TutorialID*)objectID {
	return (TutorialID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"draftValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"draft"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"flaggedAsInappropriateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"flaggedAsInappropriate"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"hiddenValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"hidden"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"inReviewValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"inReview"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"serverIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"serverID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic createdAt;

@dynamic draft;

- (BOOL)draftValue {
	NSNumber *result = [self draft];
	return [result boolValue];
}

- (void)setDraftValue:(BOOL)value_ {
	[self setDraft:@(value_)];
}

- (BOOL)primitiveDraftValue {
	NSNumber *result = [self primitiveDraft];
	return [result boolValue];
}

- (void)setPrimitiveDraftValue:(BOOL)value_ {
	[self setPrimitiveDraft:@(value_)];
}

@dynamic flaggedAsInappropriate;

- (BOOL)flaggedAsInappropriateValue {
	NSNumber *result = [self flaggedAsInappropriate];
	return [result boolValue];
}

- (void)setFlaggedAsInappropriateValue:(BOOL)value_ {
	[self setFlaggedAsInappropriate:@(value_)];
}

- (BOOL)primitiveFlaggedAsInappropriateValue {
	NSNumber *result = [self primitiveFlaggedAsInappropriate];
	return [result boolValue];
}

- (void)setPrimitiveFlaggedAsInappropriateValue:(BOOL)value_ {
	[self setPrimitiveFlaggedAsInappropriate:@(value_)];
}

@dynamic hidden;

- (BOOL)hiddenValue {
	NSNumber *result = [self hidden];
	return [result boolValue];
}

- (void)setHiddenValue:(BOOL)value_ {
	[self setHidden:@(value_)];
}

- (BOOL)primitiveHiddenValue {
	NSNumber *result = [self primitiveHidden];
	return [result boolValue];
}

- (void)setPrimitiveHiddenValue:(BOOL)value_ {
	[self setPrimitiveHidden:@(value_)];
}

@dynamic imageURL;

@dynamic inReview;

- (BOOL)inReviewValue {
	NSNumber *result = [self inReview];
	return [result boolValue];
}

- (void)setInReviewValue:(BOOL)value_ {
	[self setInReview:@(value_)];
}

- (BOOL)primitiveInReviewValue {
	NSNumber *result = [self primitiveInReview];
	return [result boolValue];
}

- (void)setPrimitiveInReviewValue:(BOOL)value_ {
	[self setPrimitiveInReview:@(value_)];
}

@dynamic jpegImageData;

@dynamic serverID;

- (int64_t)serverIDValue {
	NSNumber *result = [self serverID];
	return [result longLongValue];
}

- (void)setServerIDValue:(int64_t)value_ {
	[self setServerID:@(value_)];
}

- (int64_t)primitiveServerIDValue {
	NSNumber *result = [self primitiveServerID];
	return [result longLongValue];
}

- (void)setPrimitiveServerIDValue:(int64_t)value_ {
	[self setPrimitiveServerID:@(value_)];
}

@dynamic state;

@dynamic title;

@dynamic consistsOf;

- (NSMutableOrderedSet*)consistsOfSet {
	[self willAccessValueForKey:@"consistsOf"];

	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"consistsOf"];

	[self didAccessValueForKey:@"consistsOf"];
	return result;
}

@dynamic createdBy;

@dynamic likedBy;

- (NSMutableSet*)likedBySet {
	[self willAccessValueForKey:@"likedBy"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"likedBy"];

	[self didAccessValueForKey:@"likedBy"];
	return result;
}

@dynamic section;

@end

@implementation _Tutorial (ConsistsOfCoreDataGeneratedAccessors)
- (void)addConsistsOf:(NSOrderedSet*)value_ {
	[self.consistsOfSet unionOrderedSet:value_];
}
- (void)removeConsistsOf:(NSOrderedSet*)value_ {
	[self.consistsOfSet minusOrderedSet:value_];
}
- (void)addConsistsOfObject:(TutorialStep*)value_ {
	[self.consistsOfSet addObject:value_];
}
- (void)removeConsistsOfObject:(TutorialStep*)value_ {
	[self.consistsOfSet removeObject:value_];
}
- (void)insertObject:(TutorialStep*)value inConsistsOfAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"consistsOf"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self consistsOf]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"consistsOf"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"consistsOf"];
}
- (void)removeObjectFromConsistsOfAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"consistsOf"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self consistsOf]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"consistsOf"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"consistsOf"];
}
- (void)insertConsistsOf:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"consistsOf"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self consistsOf]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"consistsOf"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"consistsOf"];
}
- (void)removeConsistsOfAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"consistsOf"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self consistsOf]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"consistsOf"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"consistsOf"];
}
- (void)replaceObjectInConsistsOfAtIndex:(NSUInteger)idx withObject:(TutorialStep*)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"consistsOf"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self consistsOf]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"consistsOf"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"consistsOf"];
}
- (void)replaceConsistsOfAtIndexes:(NSIndexSet *)indexes withConsistsOf:(NSArray *)value {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"consistsOf"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self consistsOf]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"consistsOf"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"consistsOf"];
}
@end

