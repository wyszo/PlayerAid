// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.h instead.

@import CoreData;

extern const struct UserAttributes {
	__unsafe_unretained NSString *avatar;
	__unsafe_unretained NSString *userDescription;
	__unsafe_unretained NSString *username;
} UserAttributes;

extern const struct UserRelationships {
	__unsafe_unretained NSString *createdTutorial;
} UserRelationships;

@class Tutorial;

@class NSObject;

@interface UserID : NSManagedObjectID {}
@end

@interface _User : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) UserID* objectID;

@property (nonatomic, strong) id avatar;

//- (BOOL)validateAvatar:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* userDescription;

//- (BOOL)validateUserDescription:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* username;

//- (BOOL)validateUsername:(id*)value_ error:(NSError**)error_;

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

- (id)primitiveAvatar;
- (void)setPrimitiveAvatar:(id)value;

- (NSString*)primitiveUserDescription;
- (void)setPrimitiveUserDescription:(NSString*)value;

- (NSString*)primitiveUsername;
- (void)setPrimitiveUsername:(NSString*)value;

- (NSMutableSet*)primitiveCreatedTutorial;
- (void)setPrimitiveCreatedTutorial:(NSMutableSet*)value;

@end
