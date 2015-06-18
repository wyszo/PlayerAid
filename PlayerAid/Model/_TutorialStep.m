// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TutorialStep.m instead.

#import "_TutorialStep.h"

const struct TutorialStepAttributes TutorialStepAttributes = {
	.imageData = @"imageData",
	.order = @"order",
	.serverID = @"serverID",
	.text = @"text",
	.videoPath = @"videoPath",
	.videoThumbnailData = @"videoThumbnailData",
};

const struct TutorialStepRelationships TutorialStepRelationships = {
	.belongsTo = @"belongsTo",
};

@implementation TutorialStepID
@end

@implementation _TutorialStep

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TutorialStep" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TutorialStep";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TutorialStep" inManagedObjectContext:moc_];
}

- (TutorialStepID*)objectID {
	return (TutorialStepID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"orderValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"order"];
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

@dynamic imageData;

@dynamic order;

- (int16_t)orderValue {
	NSNumber *result = [self order];
	return [result shortValue];
}

- (void)setOrderValue:(int16_t)value_ {
	[self setOrder:@(value_)];
}

- (int16_t)primitiveOrderValue {
	NSNumber *result = [self primitiveOrder];
	return [result shortValue];
}

- (void)setPrimitiveOrderValue:(int16_t)value_ {
	[self setPrimitiveOrder:@(value_)];
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

@dynamic videoPath;

@dynamic videoThumbnailData;

@dynamic belongsTo;

@end

