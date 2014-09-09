// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SearchEngine.h instead.

#import <CoreData/CoreData.h>
#import "Record.h"

extern const struct SearchEngineAttributes {
	__unsafe_unretained NSString *domainPart;
	__unsafe_unretained NSString *icon;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *mutable;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *order;
	__unsafe_unretained NSString *queryPart;
	__unsafe_unretained NSString *redirectURL;
} SearchEngineAttributes;

extern const struct SearchEngineUserInfo {
	__unsafe_unretained NSString *relatedByAttribute;
} SearchEngineUserInfo;

@class UIImage;

@interface SearchEngineID : NSManagedObjectID {}
@end

@interface _SearchEngine : Record {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SearchEngineID* objectID;

@property (nonatomic, strong) NSString* domainPart;

//- (BOOL)validateDomainPart:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) UIImage* icon;

//- (BOOL)validateIcon:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* id;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* mutable;

@property (atomic) BOOL mutableValue;
- (BOOL)mutableValue;
- (void)setMutableValue:(BOOL)value_;

//- (BOOL)validateMutable:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* order;

@property (atomic) int16_t orderValue;
- (int16_t)orderValue;
- (void)setOrderValue:(int16_t)value_;

//- (BOOL)validateOrder:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* queryPart;

//- (BOOL)validateQueryPart:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* redirectURL;

//- (BOOL)validateRedirectURL:(id*)value_ error:(NSError**)error_;

@end

@interface _SearchEngine (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveDomainPart;
- (void)setPrimitiveDomainPart:(NSString*)value;

- (UIImage*)primitiveIcon;
- (void)setPrimitiveIcon:(UIImage*)value;

- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;

- (NSNumber*)primitiveMutable;
- (void)setPrimitiveMutable:(NSNumber*)value;

- (BOOL)primitiveMutableValue;
- (void)setPrimitiveMutableValue:(BOOL)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSNumber*)primitiveOrder;
- (void)setPrimitiveOrder:(NSNumber*)value;

- (int16_t)primitiveOrderValue;
- (void)setPrimitiveOrderValue:(int16_t)value_;

- (NSString*)primitiveQueryPart;
- (void)setPrimitiveQueryPart:(NSString*)value;

- (NSString*)primitiveRedirectURL;
- (void)setPrimitiveRedirectURL:(NSString*)value;

@end
