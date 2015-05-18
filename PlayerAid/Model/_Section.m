// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Section.m instead.

#import "_Section.h"

const struct SectionAttributes SectionAttributes = {
	.backgroundImage = @"backgroundImage",
	.name = @"name",
	.sectionDescription = @"sectionDescription",
};

const struct SectionRelationships SectionRelationships = {
	.containsTutorial = @"containsTutorial",
};

@implementation SectionID
@end

@implementation _Section

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Section" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Section";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Section" inManagedObjectContext:moc_];
}

- (SectionID*)objectID {
	return (SectionID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic backgroundImage;

@dynamic name;

@dynamic sectionDescription;

@dynamic containsTutorial;

@end

