// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TutorialStep.h instead.

@import CoreData;

extern const struct TutorialStepAttributes {
	__unsafe_unretained NSString *imageData;
	__unsafe_unretained NSString *imagePath;
	__unsafe_unretained NSString *order;
	__unsafe_unretained NSString *serverID;
	__unsafe_unretained NSString *serverVideoThumbnailUrl;
	__unsafe_unretained NSString *text;
	__unsafe_unretained NSString *videoPath;
	__unsafe_unretained NSString *videoThumbnailData;
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

@property (nonatomic, strong) NSString* imagePath;

//- (BOOL)validateImagePath:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* order;

@property (atomic) int16_t orderValue;
- (int16_t)orderValue;
- (void)setOrderValue:(int16_t)value_;

//- (BOOL)validateOrder:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* serverID;

@property (atomic) int64_t serverIDValue;
- (int64_t)serverIDValue;
- (void)setServerIDValue:(int64_t)value_;

//- (BOOL)validateServerID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* serverVideoThumbnailUrl;

//- (BOOL)validateServerVideoThumbnailUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* text;

//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* videoPath;

//- (BOOL)validateVideoPath:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSData* videoThumbnailData;

//- (BOOL)validateVideoThumbnailData:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Tutorial *belongsTo;

//- (BOOL)validateBelongsTo:(id*)value_ error:(NSError**)error_;

@end

@interface _TutorialStep (CoreDataGeneratedPrimitiveAccessors)

- (NSData*)primitiveImageData;
- (void)setPrimitiveImageData:(NSData*)value;

- (NSString*)primitiveImagePath;
- (void)setPrimitiveImagePath:(NSString*)value;

- (NSNumber*)primitiveOrder;
- (void)setPrimitiveOrder:(NSNumber*)value;

- (int16_t)primitiveOrderValue;
- (void)setPrimitiveOrderValue:(int16_t)value_;

- (NSNumber*)primitiveServerID;
- (void)setPrimitiveServerID:(NSNumber*)value;

- (int64_t)primitiveServerIDValue;
- (void)setPrimitiveServerIDValue:(int64_t)value_;

- (NSString*)primitiveServerVideoThumbnailUrl;
- (void)setPrimitiveServerVideoThumbnailUrl:(NSString*)value;

- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;

- (NSString*)primitiveVideoPath;
- (void)setPrimitiveVideoPath:(NSString*)value;

- (NSData*)primitiveVideoThumbnailData;
- (void)setPrimitiveVideoThumbnailData:(NSData*)value;

- (Tutorial*)primitiveBelongsTo;
- (void)setPrimitiveBelongsTo:(Tutorial*)value;

@end
