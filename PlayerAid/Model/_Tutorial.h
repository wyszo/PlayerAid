// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tutorial.h instead.

@import CoreData;

extern const struct TutorialAttributes {
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *draft;
	__unsafe_unretained NSString *favourited;
	__unsafe_unretained NSString *inReview;
	__unsafe_unretained NSString *state;
	__unsafe_unretained NSString *title;
} TutorialAttributes;

extern const struct TutorialRelationships {
	__unsafe_unretained NSString *createdBy;
	__unsafe_unretained NSString *section;
} TutorialRelationships;

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

@property (nonatomic, strong) NSNumber* inReview;

@property (atomic) BOOL inReviewValue;
- (BOOL)inReviewValue;
- (void)setInReviewValue:(BOOL)value_;

//- (BOOL)validateInReview:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* state;

//- (BOOL)validateState:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) User *createdBy;

//- (BOOL)validateCreatedBy:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Section *section;

//- (BOOL)validateSection:(id*)value_ error:(NSError**)error_;

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

- (NSNumber*)primitiveInReview;
- (void)setPrimitiveInReview:(NSNumber*)value;

- (BOOL)primitiveInReviewValue;
- (void)setPrimitiveInReviewValue:(BOOL)value_;

- (NSString*)primitiveState;
- (void)setPrimitiveState:(NSString*)value;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (User*)primitiveCreatedBy;
- (void)setPrimitiveCreatedBy:(User*)value;

- (Section*)primitiveSection;
- (void)setPrimitiveSection:(Section*)value;

@end
