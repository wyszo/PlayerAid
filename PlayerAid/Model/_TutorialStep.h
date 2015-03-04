// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TutorialStep.h instead.

@import CoreData;

extern const struct TutorialStepAttributes {
	__unsafe_unretained NSString *imageData;
	__unsafe_unretained NSString *text;
	__unsafe_unretained NSString *videoPath;
} TutorialStepAttributes;

extern const struct TutorialStepRelationships {
	__unsafe_unretained NSString *belongsTo;
} TutorialStepRelationships;

@class Tutorial;

@interface TutorialStepID : NSManagedObjectID {}
@end

@interface _TutorialStep : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) TutorialStepID* objectID;

@property (nonatomic, strong) NSData* imageData;

//- (BOOL)validateImageData:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* text;

//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* videoPath;

//- (BOOL)validateVideoPath:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Tutorial *belongsTo;

//- (BOOL)validateBelongsTo:(id*)value_ error:(NSError**)error_;

@end

@interface _TutorialStep (CoreDataGeneratedPrimitiveAccessors)

- (NSData*)primitiveImageData;
- (void)setPrimitiveImageData:(NSData*)value;

- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;

- (NSString*)primitiveVideoPath;
- (void)setPrimitiveVideoPath:(NSString*)value;

- (Tutorial*)primitiveBelongsTo;
- (void)setPrimitiveBelongsTo:(Tutorial*)value;

@end
