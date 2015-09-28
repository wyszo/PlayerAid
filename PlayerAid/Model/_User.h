// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.h instead.

@import CoreData;

extern const struct UserAttributes {
	__unsafe_unretained NSString *linkedWithFacebook;
	__unsafe_unretained NSString *loggedInUser;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *pictureURL;
	__unsafe_unretained NSString *serverID;
	__unsafe_unretained NSString *userDescription;
} UserAttributes;

extern const struct UserRelationships {
	__unsafe_unretained NSString *createdTutorial;
	__unsafe_unretained NSString *follows;
	__unsafe_unretained NSString *isFollowedBy;
	__unsafe_unretained NSString *likes;
} UserRelationships;

@class Tutorial;
@class User;
@class User;
@class Tutorial;

@interface UserID : NSManagedObjectID {}
@end

@interface _User : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) UserID* objectID;

@property (nonatomic, strong) NSNumber* linkedWithFacebook;

@property (atomic) BOOL linkedWithFacebookValue;
- (BOOL)linkedWithFacebookValue;
- (void)setLinkedWithFacebookValue:(BOOL)value_;

//- (BOOL)validateLinkedWithFacebook:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* loggedInUser;

@property (atomic) BOOL loggedInUserValue;
- (BOOL)loggedInUserValue;
- (void)setLoggedInUserValue:(BOOL)value_;

//- (BOOL)validateLoggedInUser:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* pictureURL;

//- (BOOL)validatePictureURL:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* serverID;

@property (atomic) int64_t serverIDValue;
- (int64_t)serverIDValue;
- (void)setServerIDValue:(int64_t)value_;

//- (BOOL)validateServerID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* userDescription;

//- (BOOL)validateUserDescription:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *createdTutorial;

- (NSMutableSet*)createdTutorialSet;

@property (nonatomic, strong) NSSet *follows;

- (NSMutableSet*)followsSet;

@property (nonatomic, strong) NSSet *isFollowedBy;

- (NSMutableSet*)isFollowedBySet;

@property (nonatomic, strong) NSSet *likes;

- (NSMutableSet*)likesSet;

@end

@interface _User (CreatedTutorialCoreDataGeneratedAccessors)
- (void)addCreatedTutorial:(NSSet*)value_;
- (void)removeCreatedTutorial:(NSSet*)value_;
- (void)addCreatedTutorialObject:(Tutorial*)value_;
- (void)removeCreatedTutorialObject:(Tutorial*)value_;

@end

@interface _User (FollowsCoreDataGeneratedAccessors)
- (void)addFollows:(NSSet*)value_;
- (void)removeFollows:(NSSet*)value_;
- (void)addFollowsObject:(User*)value_;
- (void)removeFollowsObject:(User*)value_;

@end

@interface _User (IsFollowedByCoreDataGeneratedAccessors)
- (void)addIsFollowedBy:(NSSet*)value_;
- (void)removeIsFollowedBy:(NSSet*)value_;
- (void)addIsFollowedByObject:(User*)value_;
- (void)removeIsFollowedByObject:(User*)value_;

@end

@interface _User (LikesCoreDataGeneratedAccessors)
- (void)addLikes:(NSSet*)value_;
- (void)removeLikes:(NSSet*)value_;
- (void)addLikesObject:(Tutorial*)value_;
- (void)removeLikesObject:(Tutorial*)value_;

@end

@interface _User (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveLinkedWithFacebook;
- (void)setPrimitiveLinkedWithFacebook:(NSNumber*)value;

- (BOOL)primitiveLinkedWithFacebookValue;
- (void)setPrimitiveLinkedWithFacebookValue:(BOOL)value_;

- (NSNumber*)primitiveLoggedInUser;
- (void)setPrimitiveLoggedInUser:(NSNumber*)value;

- (BOOL)primitiveLoggedInUserValue;
- (void)setPrimitiveLoggedInUserValue:(BOOL)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitivePictureURL;
- (void)setPrimitivePictureURL:(NSString*)value;

- (NSNumber*)primitiveServerID;
- (void)setPrimitiveServerID:(NSNumber*)value;

- (int64_t)primitiveServerIDValue;
- (void)setPrimitiveServerIDValue:(int64_t)value_;

- (NSString*)primitiveUserDescription;
- (void)setPrimitiveUserDescription:(NSString*)value;

- (NSMutableSet*)primitiveCreatedTutorial;
- (void)setPrimitiveCreatedTutorial:(NSMutableSet*)value;

- (NSMutableSet*)primitiveFollows;
- (void)setPrimitiveFollows:(NSMutableSet*)value;

- (NSMutableSet*)primitiveIsFollowedBy;
- (void)setPrimitiveIsFollowedBy:(NSMutableSet*)value;

- (NSMutableSet*)primitiveLikes;
- (void)setPrimitiveLikes:(NSMutableSet*)value;

@end
