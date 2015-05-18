// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.h instead.

@import CoreData;

extern const struct UserAttributes {
	__unsafe_unretained NSString *avatar;
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

@property (nonatomic, strong) NSString* username;

//- (BOOL)validateUsername:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Tutorial *createdTutorial;

//- (BOOL)validateCreatedTutorial:(id*)value_ error:(NSError**)error_;

@end

@interface _User (CoreDataGeneratedPrimitiveAccessors)

- (id)primitiveAvatar;
- (void)setPrimitiveAvatar:(id)value;

- (NSString*)primitiveUsername;
- (void)setPrimitiveUsername:(NSString*)value;

- (Tutorial*)primitiveCreatedTutorial;
- (void)setPrimitiveCreatedTutorial:(Tutorial*)value;

@end
