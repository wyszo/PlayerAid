// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.m instead.

#import "_User.h"

const struct UserAttributes UserAttributes = {
	.name = @"name",
	.pictureURL = @"pictureURL",
	.serverID = @"serverID",
	.userDescription = @"userDescription",
};

const struct UserRelationships UserRelationships = {
	.createdTutorial = @"createdTutorial",
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

	return keyPaths;
}

@dynamic name;

@dynamic pictureURL;

@dynamic serverID;

@dynamic userDescription;

@dynamic createdTutorial;

- (NSMutableSet*)createdTutorialSet {
	[self willAccessValueForKey:@"createdTutorial"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"createdTutorial"];

	[self didAccessValueForKey:@"createdTutorial"];
	return result;
}

@end

