//
//  Memories.h
//  PensieveMVP
//
//  Created by Miles Johnson on 6/23/15.
//  Copyright (c) 2015 StarshipEnterprise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Memories : NSManagedObject

@property (nonatomic, retain) NSString  * memoryNote;
@property (nonatomic, retain) NSDate    * memoryDate;
@property (nonatomic, retain) NSDate    * dateEntered;
@property (nonatomic, retain) NSDate    * dateUpdated;

@end
