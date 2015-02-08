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
};

const struct TutorialRelationships TutorialRelationships = {
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

@dynamic createdBy;

@dynamic section;

@end

