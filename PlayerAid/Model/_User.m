// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.m instead.

#import "_User.h"

const struct UserAttributes UserAttributes = {
	.loggedInUser = @"loggedInUser",
	.name = @"name",
	.pictureURL = @"pictureURL",
	.serverID = @"serverID",
	.userDescription = @"userDescription",
};

const struct UserRelationships UserRelationships = {
	.createdTutorial = @"createdTutorial",
	.follows = @"follows",
	.isFollowedBy = @"isFollowedBy",
	.likes = @"likes",
};

@implementation UserID
@end

@implementation _User

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"User";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"User" inManagedObjectContext:moc_];
}

- (UserID*)objectID {
	return (UserID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"loggedInUserValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"loggedInUser"];
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

@dynamic loggedInUser;

- (BOOL)loggedInUserValue {
	NSNumber *result = [self loggedInUser];
	return [result boolValue];
}

- (void)setLoggedInUserValue:(BOOL)value_ {
	[self setLoggedInUser:@(value_)];
}

- (BOOL)primitiveLoggedInUserValue {
	NSNumber *result = [self primitiveLoggedInUser];
	return [result boolValue];
}

- (void)setPrimitiveLoggedInUserValue:(BOOL)value_ {
	[self setPrimitiveLoggedInUser:@(value_)];
}

@dynamic name;

@dynamic pictureURL;

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

@dynamic userDescription;

@dynamic createdTutorial;

- (NSMutableSet*)createdTutorialSet {
	[self willAccessValueForKey:@"createdTutorial"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"createdTutorial"];

	[self didAccessValueForKey:@"createdTutorial"];
	return result;
}

@dynamic follows;

- (NSMutableSet*)followsSet {
	[self willAccessValueForKey:@"follows"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"follows"];

	[self didAccessValueForKey:@"follows"];
	return result;
}

@dynamic isFollowedBy;

- (NSMutableSet*)isFollowedBySet {
	[self willAccessValueForKey:@"isFollowedBy"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"isFollowedBy"];

	[self didAccessValueForKey:@"isFollowedBy"];
	return result;
}

@dynamic likes;

- (NSMutableSet*)likesSet {
	[self willAccessValueForKey:@"likes"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"likes"];

	[self didAccessValueForKey:@"likes"];
	return result;
}

@end

