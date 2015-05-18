// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Section.h instead.

@import CoreData;

extern const struct SectionAttributes {
	__unsafe_unretained NSString *backgroundImage;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *sectionDescription;
} SectionAttributes;

extern const struct SectionRelationships {
	__unsafe_unretained NSString *containsTutorial;
} SectionRelationships;

@class Tutorial;

@class NSObject;

@interface SectionID : NSManagedObjectID {}
@end

@interface _Section : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SectionID* objectID;

@property (nonatomic, strong) id backgroundImage;

//- (BOOL)validateBackgroundImage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* sectionDescription;

//- (BOOL)validateSectionDescription:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Tutorial *containsTutorial;

//- (BOOL)validateContainsTutorial:(id*)value_ error:(NSError**)error_;

@end

@interface _Section (CoreDataGeneratedPrimitiveAccessors)

- (id)primitiveBackgroundImage;
- (void)setPrimitiveBackgroundImage:(id)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveSectionDescription;
- (void)setPrimitiveSectionDescription:(NSString*)value;

- (Tutorial*)primitiveContainsTutorial;
- (void)setPrimitiveContainsTutorial:(Tutorial*)value;

@end
