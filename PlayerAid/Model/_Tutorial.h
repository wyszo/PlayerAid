// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tutorial.h instead.

@import CoreData;

extern const struct TutorialAttributes {
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *draft;
	__unsafe_unretained NSString *favourited;
	__unsafe_unretained NSString *imageURL;
	__unsafe_unretained NSString *inReview;
	__unsafe_unretained NSString *serverID;
	__unsafe_unretained NSString *state;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *unsaved;
} TutorialAttributes;

extern const struct TutorialRelationships {
	__unsafe_unretained NSString *consistsOf;
	__unsafe_unretained NSString *createdBy;
	__unsafe_unretained NSString *section;
} TutorialRelationships;

@class TutorialStep;
@class User;
@class Section;

@interface TutorialID : NSManagedObjectID {}
@end

@interface _Tutorial : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) TutorialID* objectID;

@property (nonatomic, strong) NSDate* createdAt;

//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* draft;

@property (atomic) BOOL draftValue;
- (BOOL)draftValue;
- (void)setDraftValue:(BOOL)value_;

//- (BOOL)validateDraft:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* favourited;

@property (atomic) BOOL favouritedValue;
- (BOOL)favouritedValue;
- (void)setFavouritedValue:(BOOL)value_;

//- (BOOL)validateFavourited:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* imageURL;

//- (BOOL)validateImageURL:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* inReview;

@property (atomic) BOOL inReviewValue;
- (BOOL)inReviewValue;
- (void)setInReviewValue:(BOOL)value_;

//- (BOOL)validateInReview:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* serverID;

@property (atomic) int64_t serverIDValue;
- (int64_t)serverIDValue;
- (void)setServerIDValue:(int64_t)value_;

//- (BOOL)validateServerID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* state;

//- (BOOL)validateState:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* unsaved;

@property (atomic) BOOL unsavedValue;
- (BOOL)unsavedValue;
- (void)setUnsavedValue:(BOOL)value_;

//- (BOOL)validateUnsaved:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSOrderedSet *consistsOf;

- (NSMutableOrderedSet*)consistsOfSet;

@property (nonatomic, strong) User *createdBy;

//- (BOOL)validateCreatedBy:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Section *section;

//- (BOOL)validateSection:(id*)value_ error:(NSError**)error_;

@end

@interface _Tutorial (ConsistsOfCoreDataGeneratedAccessors)
- (void)addConsistsOf:(NSOrderedSet*)value_;
- (void)removeConsistsOf:(NSOrderedSet*)value_;
- (void)addConsistsOfObject:(TutorialStep*)value_;
- (void)removeConsistsOfObject:(TutorialStep*)value_;

- (void)insertObject:(TutorialStep*)value inConsistsOfAtIndex:(NSUInteger)idx;
- (void)removeObjectFromConsistsOfAtIndex:(NSUInteger)idx;
- (void)insertConsistsOf:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeConsistsOfAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInConsistsOfAtIndex:(NSUInteger)idx withObject:(TutorialStep*)value;
- (void)replaceConsistsOfAtIndexes:(NSIndexSet *)indexes withConsistsOf:(NSArray *)values;

@end

@interface _Tutorial (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;

- (NSNumber*)primitiveDraft;
- (void)setPrimitiveDraft:(NSNumber*)value;

- (BOOL)primitiveDraftValue;
- (void)setPrimitiveDraftValue:(BOOL)value_;

- (NSNumber*)primitiveFavourited;
- (void)setPrimitiveFavourited:(NSNumber*)value;

- (BOOL)primitiveFavouritedValue;
- (void)setPrimitiveFavouritedValue:(BOOL)value_;

- (NSString*)primitiveImageURL;
- (void)setPrimitiveImageURL:(NSString*)value;

- (NSNumber*)primitiveInReview;
- (void)setPrimitiveInReview:(NSNumber*)value;

- (BOOL)primitiveInReviewValue;
- (void)setPrimitiveInReviewValue:(BOOL)value_;

- (NSNumber*)primitiveServerID;
- (void)setPrimitiveServerID:(NSNumber*)value;

- (int64_t)primitiveServerIDValue;
- (void)setPrimitiveServerIDValue:(int64_t)value_;

- (NSString*)primitiveState;
- (void)setPrimitiveState:(NSString*)value;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (NSNumber*)primitiveUnsaved;
- (void)setPrimitiveUnsaved:(NSNumber*)value;

- (BOOL)primitiveUnsavedValue;
- (void)setPrimitiveUnsavedValue:(BOOL)value_;

- (NSMutableOrderedSet*)primitiveConsistsOf;
- (void)setPrimitiveConsistsOf:(NSMutableOrderedSet*)value;

- (User*)primitiveCreatedBy;
- (void)setPrimitiveCreatedBy:(User*)value;

- (Section*)primitiveSection;
- (void)setPrimitiveSection:(Section*)value;

@end
