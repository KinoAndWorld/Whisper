//
//  LXArray.h
//  testLXfoundation
//
//  Created by kino on 14-8-14.
//  Copyright (c) 2014年 kino. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef NSArray
#undef NSArray
#endif

@interface LXArray : NSArray{
    CFArrayRef array;
}

- (id)init;
- (id)initWithObjects:(const id [])objects count:(NSUInteger)cnt;

- (NSUInteger)count;
- (id)objectAtIndex:(NSUInteger)index;


@end
