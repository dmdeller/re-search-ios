//
//  Record.h
//  Re-Search
//
//  Created by David on 7/19/14.
//  Copyright (c) 2014 David Deller. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Record : NSManagedObject

- (NSDictionary *)serializedData;

@end
