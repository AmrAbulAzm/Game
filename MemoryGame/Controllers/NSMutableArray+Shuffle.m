//
//  NSMutableArray+Shuffle.m
//  MemoryGame
//
//  Created by Amr AbulAzm on 12/07/2016.
//  Copyright © 2016 Amr AbulAzm. All rights reserved.
//

#import "NSMutableArray+Shuffle.h"

@implementation NSMutableArray (Shuffle)

- (void)shuffle
{
    // Shuffles Array.
    NSUInteger count = [self count];
    if (count < 1) return;
    for (NSUInteger i = 0; i < count - 1; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [self exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

- (void)doubleArray
{
    // Creates an array double in size with a pair of each of the original array.
    NSMutableArray *tempArray = [self mutableCopy];
    [self addObjectsFromArray:tempArray];
}

@end
