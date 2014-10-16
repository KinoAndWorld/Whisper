//
//  LXArray.m
//  testLXfoundation
//
//  Created by kino on 14-8-14.
//  Copyright (c) 2014年 kino. All rights reserved.
//

#import "LXArray.h"

#ifdef NSArray
#undef NSArray
#endif

#if  !__has_feature(objc_arc)
#define __bridge
#endif

@implementation LXArray

- (id) init {
	return [self initWithObjects:NULL count:0];
}

- (id)initWithObjects:(const id [])objects count:(NSUInteger)cnt{
    if ((self = [super init]) == nil) return nil;
    
    array = CFArrayCreate(kCFAllocatorDefault, (void *)objects, cnt,  &kCFTypeArrayCallBacks);
    if (array) {
        return self;
    }
	return nil;
}

- (NSUInteger)count{
    return CFArrayGetCount(array);
}

- (NSEnumerator*)objectEnumerator
{
	return [(__bridge id)array objectEnumerator];
}

- (id)objectAtIndex:(NSUInteger)index{
    if (index<[self count]) {
        return (__bridge id)CFArrayGetValueAtIndex(array, index);
    }
    return nil;
}


- (void)dealloc {
	if(array)CFRelease(array);
    array = NULL;
#if  !__has_feature(objc_arc)
	[super dealloc];
#endif
}

@end
