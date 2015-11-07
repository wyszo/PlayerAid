// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TutorialComment.h instead.

@import CoreData;

extern const struct TutorialCommentAttributes {
	__unsafe_unretained NSString *createdOn;
	__unsafe_unretained NSString *likes;
	__unsafe_unretained NSString *serverID;
	__unsafe_unretained NSString *text;
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

@property (nonatomic, strong) NSNumber* likes;

@property (atomic) int64_t likesValue;
- (int64_t)likesValue;
- (void)setLikesValue:(int64_t)value_;

//- (BOOL)validateLikes:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* serverID;

@property (atomic) int64_t serverIDValue;
- (int64_t)serverIDValue;
- (void)setServerIDValue:(int64_t)value_;

//- (BOOL)validateServerID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* text;

//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;

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

- (NSNumber*)primitiveLikes;
- (void)setPrimitiveLikes:(NSNumber*)value;

- (int64_t)primitiveLikesValue;
- (void)setPrimitiveLikesValue:(int64_t)value_;

- (NSNumber*)primitiveServerID;
- (void)setPrimitiveServerID:(NSNumber*)value;

- (int64_t)primitiveServerIDValue;
- (void)setPrimitiveServerIDValue:(int64_t)value_;

- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;

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
