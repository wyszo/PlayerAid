// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tutorial.h instead.

@import CoreData;

extern const struct TutorialAttributes {
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *draft;
	__unsafe_unretained NSString *imageURL;
	__unsafe_unretained NSString *inReview;
	__unsafe_unretained NSString *jpegImageData;
	__unsafe_unretained NSString *reportedByUser;
	__unsafe_unretained NSString *serverID;
	__unsafe_unretained NSString *state;
	__unsafe_unretained NSString *title;
} TutorialAttributes;

extern const struct TutorialRelationships {
	__unsafe_unretained NSString *consistsOf;
	__unsafe_unretained NSString *createdBy;
	__unsafe_unretained NSString *hasComments;
	__unsafe_unretained NSString *likedBy;
	__unsafe_unretained NSString *section;
} TutorialRelationships;

@class TutorialStep;
@class User;
@class TutorialComment;
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

@property (nonatomic, strong) NSString* imageURL;

//- (BOOL)validateImageURL:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* inReview;

@property (atomic) BOOL inReviewValue;
- (BOOL)inReviewValue;
- (void)setInReviewValue:(BOOL)value_;

//- (BOOL)validateInReview:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSData* jpegImageData;

//- (BOOL)validateJpegImageData:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* reportedByUser;

@property (atomic) BOOL reportedByUserValue;
- (BOOL)reportedByUserValue;
- (void)setReportedByUserValue:(BOOL)value_;

//- (BOOL)validateReportedByUser:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* serverID;

@property (atomic) int64_t serverIDValue;
- (int64_t)serverIDValue;
- (void)setServerIDValue:(int64_t)value_;

//- (BOOL)validateServerID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* state;

//- (BOOL)validateState:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSOrderedSet *consistsOf;

- (NSMutableOrderedSet*)consistsOfSet;

@property (nonatomic, strong) User *createdBy;

//- (BOOL)validateCreatedBy:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSOrderedSet *hasComments;

- (NSMutableOrderedSet*)hasCommentsSet;

@property (nonatomic, strong) NSSet *likedBy;

- (NSMutableSet*)likedBySet;

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

@interface _Tutorial (HasCommentsCoreDataGeneratedAccessors)
- (void)addHasComments:(NSOrderedSet*)value_;
- (void)removeHasComments:(NSOrderedSet*)value_;
- (void)addHasCommentsObject:(TutorialComment*)value_;
- (void)removeHasCommentsObject:(TutorialComment*)value_;

- (void)insertObject:(TutorialComment*)value inHasCommentsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromHasCommentsAtIndex:(NSUInteger)idx;
- (void)insertHasComments:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeHasCommentsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInHasCommentsAtIndex:(NSUInteger)idx withObject:(TutorialComment*)value;
- (void)replaceHasCommentsAtIndexes:(NSIndexSet *)indexes withHasComments:(NSArray *)values;

@end

@interface _Tutorial (LikedByCoreDataGeneratedAccessors)
- (void)addLikedBy:(NSSet*)value_;
- (void)removeLikedBy:(NSSet*)value_;
- (void)addLikedByObject:(User*)value_;
- (void)removeLikedByObject:(User*)value_;

@end

@interface _Tutorial (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;

- (NSNumber*)primitiveDraft;
- (void)setPrimitiveDraft:(NSNumber*)value;

- (BOOL)primitiveDraftValue;
- (void)setPrimitiveDraftValue:(BOOL)value_;

- (NSString*)primitiveImageURL;
- (void)setPrimitiveImageURL:(NSString*)value;

- (NSNumber*)primitiveInReview;
- (void)setPrimitiveInReview:(NSNumber*)value;

- (BOOL)primitiveInReviewValue;
- (void)setPrimitiveInReviewValue:(BOOL)value_;

- (NSData*)primitiveJpegImageData;
- (void)setPrimitiveJpegImageData:(NSData*)value;

- (NSNumber*)primitiveReportedByUser;
- (void)setPrimitiveReportedByUser:(NSNumber*)value;

- (BOOL)primitiveReportedByUserValue;
- (void)setPrimitiveReportedByUserValue:(BOOL)value_;

- (NSNumber*)primitiveServerID;
- (void)setPrimitiveServerID:(NSNumber*)value;

- (int64_t)primitiveServerIDValue;
- (void)setPrimitiveServerIDValue:(int64_t)value_;

- (NSString*)primitiveState;
- (void)setPrimitiveState:(NSString*)value;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (NSMutableOrderedSet*)primitiveConsistsOf;
- (void)setPrimitiveConsistsOf:(NSMutableOrderedSet*)value;

- (User*)primitiveCreatedBy;
- (void)setPrimitiveCreatedBy:(User*)value;

- (NSMutableOrderedSet*)primitiveHasComments;
- (void)setPrimitiveHasComments:(NSMutableOrderedSet*)value;

- (NSMutableSet*)primitiveLikedBy;
- (void)setPrimitiveLikedBy:(NSMutableSet*)value;

- (Section*)primitiveSection;
- (void)setPrimitiveSection:(Section*)value;

@end
