// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SearchEngine.h instead.

#import <CoreData/CoreData.h>
#import "Record.h"

extern const struct SearchEngineAttributes {
	__unsafe_unretained NSString *icon;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *urlPattern;
} SearchEngineAttributes;

@class UIImage;

@interface SearchEngineID : NSManagedObjectID {}
@end

@interface _SearchEngine : Record {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SearchEngineID* objectID;

@property (nonatomic, strong) UIImage* icon;

//- (BOOL)validateIcon:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* urlPattern;

//- (BOOL)validateUrlPattern:(id*)value_ error:(NSError**)error_;

@end

@interface _SearchEngine (CoreDataGeneratedPrimitiveAccessors)

- (UIImage*)primitiveIcon;
- (void)setPrimitiveIcon:(UIImage*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveUrlPattern;
- (void)setPrimitiveUrlPattern:(NSString*)value;

@end
