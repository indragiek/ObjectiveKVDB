//
//  KVDBDatabase_Tests.h
//  ObjectiveKVDB
//
//  Created by Indragie Karunaratne on 12/15/2013.
//  Copyright (c) 2013 Indragie Karunaratne. All rights reserved.
//

#import <ObjectiveKVDB/ObjectiveKVDB.h>

/**
 *  Methods only to be used in tests.
 */
@interface KVDBDatabase ()
/**
 *  Close file descriptors so that the database file can be deleted in tests.
 */
- (void)close;
@end
