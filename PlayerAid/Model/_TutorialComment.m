// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TutorialComment.m instead.

#import "_TutorialComment.h"

const struct TutorialCommentAttributes TutorialCommentAttributes = {
	.createdOn = @"createdOn",
	.likes = @"likes",
	.serverID = @"serverID",
	.text = @"text",
};

const struct TutorialCommentRelationships TutorialCommentRelationships = {
	.belongsToTutorial = @"belongsToTutorial",
	.hasReplies = @"hasReplies",
	.isReplyTo = @"isReplyTo",
	.likedBy = @"likedBy",
	.madeBy = @"madeBy",
};

@implementation TutorialCommentID
@end

@implementation _TutorialComment

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Comment";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Comment" inManagedObjectContext:moc_];
}

- (TutorialCommentID*)objectID {
	return (TutorialCommentID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"likesValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"likes"];
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

@dynamic createdOn;

@dynamic likes;

- (int64_t)likesValue {
	NSNumber *result = [self likes];
	return [result longLongValue];
}

- (void)setLikesValue:(int64_t)value_ {
	[self setLikes:@(value_)];
}

- (int64_t)primitiveLikesValue {
	NSNumber *result = [self primitiveLikes];
	return [result longLongValue];
}

- (void)setPrimitiveLikesValue:(int64_t)value_ {
	[self setPrimitiveLikes:@(value_)];
}

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

@dynamic text;

@dynamic belongsToTutorial;

@dynamic hasReplies;

- (NSMutableSet*)hasRepliesSet {
	[self willAccessValueForKey:@"hasReplies"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"hasReplies"];

	[self didAccessValueForKey:@"hasReplies"];
	return result;
}

@dynamic isReplyTo;

@dynamic likedBy;

- (NSMutableSet*)likedBySet {
	[self willAccessValueForKey:@"likedBy"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"likedBy"];

	[self didAccessValueForKey:@"likedBy"];
	return result;
}

@dynamic madeBy;

@end

