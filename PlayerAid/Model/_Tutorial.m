// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tutorial.m instead.

#import "_Tutorial.h"

const struct TutorialAttributes TutorialAttributes = {
	.createdAt = @"createdAt",
	.draft = @"draft",
	.favourited = @"favourited",
	.inReview = @"inReview",
	.state = @"state",
	.title = @"title",
	.unsaved = @"unsaved",
};

const struct TutorialRelationships TutorialRelationships = {
	.consistsOf = @"consistsOf",
	.createdBy = @"createdBy",
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
	if ([key isEqualToString:@"favouritedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"favourited"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"inReviewValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"inReview"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"unsavedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"unsaved"];
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

@dynamic favourited;

- (BOOL)favouritedValue {
	NSNumber *result = [self favourited];
	return [result boolValue];
}

- (void)setFavouritedValue:(BOOL)value_ {
	[self setFavourited:@(value_)];
}

- (BOOL)primitiveFavouritedValue {
	NSNumber *result = [self primitiveFavourited];
	return [result boolValue];
}

- (void)setPrimitiveFavouritedValue:(BOOL)value_ {
	[self setPrimitiveFavourited:@(value_)];
}

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

@dynamic state;

@dynamic title;

@dynamic unsaved;

- (BOOL)unsavedValue {
	NSNumber *result = [self unsaved];
	return [result boolValue];
}

- (void)setUnsavedValue:(BOOL)value_ {
	[self setUnsaved:@(value_)];
}

- (BOOL)primitiveUnsavedValue {
	NSNumber *result = [self primitiveUnsaved];
	return [result boolValue];
}

- (void)setPrimitiveUnsavedValue:(BOOL)value_ {
	[self setPrimitiveUnsaved:@(value_)];
}

@dynamic consistsOf;

- (NSMutableOrderedSet*)consistsOfSet {
	[self willAccessValueForKey:@"consistsOf"];

	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"consistsOf"];

	[self didAccessValueForKey:@"consistsOf"];
	return result;
}

@dynamic createdBy;

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

