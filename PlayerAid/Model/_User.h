// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.h instead.

@import CoreData;

extern const struct UserAttributes {
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *pictureURL;
	__unsafe_unretained NSString *serverID;
	__unsafe_unretained NSString *userDescription;
} UserAttributes;

extern const struct UserRelationships {
	__unsafe_unretained NSString *createdTutorial;
} UserRelationships;

@class Tutorial;

@interface UserID : NSManagedObjectID {}
@end

@interface _User : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) UserID* objectID;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* pictureURL;

//- (BOOL)validatePictureURL:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* serverID;

//- (BOOL)validateServerID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* userDescription;

//- (BOOL)validateUserDescription:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *createdTutorial;

- (NSMutableSet*)createdTutorialSet;

@end

@interface _User (CreatedTutorialCoreDataGeneratedAccessors)
- (void)addCreatedTutorial:(NSSet*)value_;
- (void)removeCreatedTutorial:(NSSet*)value_;
- (void)addCreatedTutorialObject:(Tutorial*)value_;
- (void)removeCreatedTutorialObject:(Tutorial*)value_;

@end

@interface _User (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitivePictureURL;
- (void)setPrimitivePictureURL:(NSString*)value;

- (NSString*)primitiveServerID;
- (void)setPrimitiveServerID:(NSString*)value;

- (NSString*)primitiveUserDescription;
- (void)setPrimitiveUserDescription:(NSString*)value;

- (NSMutableSet*)primitiveCreatedTutorial;
- (void)setPrimitiveCreatedTutorial:(NSMutableSet*)value;

@end
