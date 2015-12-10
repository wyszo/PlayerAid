// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TutorialComment.m instead.

#import "_TutorialComment.h"

const struct TutorialCommentAttributes TutorialCommentAttributes = {
	.createdOn = @"createdOn",
	.likesCount = @"likesCount",
	.serverID = @"serverID",
	.status = @"status",
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

	if ([key isEqualToString:@"likesCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"likesCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"serverIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"serverID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"statusValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"status"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic createdOn;

@dynamic likesCount;

- (int64_t)likesCountValue {
	NSNumber *result = [self likesCount];
	return [result longLongValue];
}

- (void)setLikesCountValue:(int64_t)value_ {
	[self setLikesCount:@(value_)];
}

- (int64_t)primitiveLikesCountValue {
	NSNumber *result = [self primitiveLikesCount];
	return [result longLongValue];
}

- (void)setPrimitiveLikesCountValue:(int64_t)value_ {
	[self setPrimitiveLikesCount:@(value_)];
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

@dynamic status;

- (uint64_t)statusValue {
	NSNumber *result = [self status];
	return [result unsignedLongLongValue];
}

- (void)setStatusValue:(uint64_t)value_ {
	[self setStatus:@(value_)];
}

- (uint64_t)primitiveStatusValue {
	NSNumber *result = [self primitiveStatus];
	return [result unsignedLongLongValue];
}

- (void)setPrimitiveStatusValue:(uint64_t)value_ {
	[self setPrimitiveStatus:@(value_)];
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

