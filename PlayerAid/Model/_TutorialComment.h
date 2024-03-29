// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TutorialComment.h instead.

@import CoreData;

extern const struct TutorialCommentAttributes {
	__unsafe_unretained NSString *createdOn;
	__unsafe_unretained NSString *likesCount;
	__unsafe_unretained NSString *serverID;
	__unsafe_unretained NSString *status;
	__unsafe_unretained NSString *text;
	__unsafe_unretained NSString *upvotedByUser;
} TutorialCommentAttributes;

extern const struct TutorialCommentRelationships {
	__unsafe_unretained NSString *belongsToTutorial;
	__unsafe_unretained NSString *hasReplies;
	__unsafe_unretained NSString *isReplyTo;
	__unsafe_unretained NSString *likedBy;
	__unsafe_unretained NSString *madeBy;
} TutorialCommentRelationships;

@class Tutorial;
@class TutorialComment;
@class TutorialComment;
@class User;
@class User;

@interface TutorialCommentID : NSManagedObjectID {}
@end

@interface _TutorialComment : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) TutorialCommentID* objectID;

@property (nonatomic, strong) NSDate* createdOn;

//- (BOOL)validateCreatedOn:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* likesCount;

@property (atomic) int64_t likesCountValue;
- (int64_t)likesCountValue;
- (void)setLikesCountValue:(int64_t)value_;

//- (BOOL)validateLikesCount:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* serverID;

@property (atomic) int64_t serverIDValue;
- (int64_t)serverIDValue;
- (void)setServerIDValue:(int64_t)value_;

//- (BOOL)validateServerID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* status;

@property (atomic) uint64_t statusValue;
- (uint64_t)statusValue;
- (void)setStatusValue:(uint64_t)value_;

//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* text;

//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* upvotedByUser;

@property (atomic) BOOL upvotedByUserValue;
- (BOOL)upvotedByUserValue;
- (void)setUpvotedByUserValue:(BOOL)value_;

//- (BOOL)validateUpvotedByUser:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Tutorial *belongsToTutorial;

//- (BOOL)validateBelongsToTutorial:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *hasReplies;

- (NSMutableSet*)hasRepliesSet;

@property (nonatomic, strong) TutorialComment *isReplyTo;

//- (BOOL)validateIsReplyTo:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *likedBy;

- (NSMutableSet*)likedBySet;

@property (nonatomic, strong) User *madeBy;

//- (BOOL)validateMadeBy:(id*)value_ error:(NSError**)error_;

@end

@interface _TutorialComment (HasRepliesCoreDataGeneratedAccessors)
- (void)addHasReplies:(NSSet*)value_;
- (void)removeHasReplies:(NSSet*)value_;
- (void)addHasRepliesObject:(TutorialComment*)value_;
- (void)removeHasRepliesObject:(TutorialComment*)value_;

@end

@interface _TutorialComment (LikedByCoreDataGeneratedAccessors)
- (void)addLikedBy:(NSSet*)value_;
- (void)removeLikedBy:(NSSet*)value_;
- (void)addLikedByObject:(User*)value_;
- (void)removeLikedByObject:(User*)value_;

@end

@interface _TutorialComment (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveCreatedOn;
- (void)setPrimitiveCreatedOn:(NSDate*)value;

- (NSNumber*)primitiveLikesCount;
- (void)setPrimitiveLikesCount:(NSNumber*)value;

- (int64_t)primitiveLikesCountValue;
- (void)setPrimitiveLikesCountValue:(int64_t)value_;

- (NSNumber*)primitiveServerID;
- (void)setPrimitiveServerID:(NSNumber*)value;

- (int64_t)primitiveServerIDValue;
- (void)setPrimitiveServerIDValue:(int64_t)value_;

- (NSNumber*)primitiveStatus;
- (void)setPrimitiveStatus:(NSNumber*)value;

- (uint64_t)primitiveStatusValue;
- (void)setPrimitiveStatusValue:(uint64_t)value_;

- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;

- (NSNumber*)primitiveUpvotedByUser;
- (void)setPrimitiveUpvotedByUser:(NSNumber*)value;

- (BOOL)primitiveUpvotedByUserValue;
- (void)setPrimitiveUpvotedByUserValue:(BOOL)value_;

- (Tutorial*)primitiveBelongsToTutorial;
- (void)setPrimitiveBelongsToTutorial:(Tutorial*)value;

- (NSMutableSet*)primitiveHasReplies;
- (void)setPrimitiveHasReplies:(NSMutableSet*)value;

- (TutorialComment*)primitiveIsReplyTo;
- (void)setPrimitiveIsReplyTo:(TutorialComment*)value;

- (NSMutableSet*)primitiveLikedBy;
- (void)setPrimitiveLikedBy:(NSMutableSet*)value;

- (User*)primitiveMadeBy;
- (void)setPrimitiveMadeBy:(User*)value;

@end
