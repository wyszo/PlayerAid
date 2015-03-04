// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TutorialStep.m instead.

#import "_TutorialStep.h"

const struct TutorialStepAttributes TutorialStepAttributes = {
	.imageData = @"imageData",
	.text = @"text",
	.videoPath = @"videoPath",
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

	return keyPaths;
}

@dynamic imageData;

@dynamic text;

@dynamic videoPath;

@dynamic belongsTo;

@end

