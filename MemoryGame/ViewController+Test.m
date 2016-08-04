//
//  ViewController+Test.m
//  MemoryGame
//
//  Created by Amr AbulAzm on 14/07/2016.
//  Copyright © 2016 Amr AbulAzm. All rights reserved.
//

#import "ViewController+Test.h"
#import "NSMutableArray+Shuffle.h"

@implementation ViewController (Test)

- (NSArray *)createRandomArray:(NSArray*)array
{
    // Create a 2*8 Array for the game.
    NSMutableArray *randomizedArray = [[array subarrayWithRange:NSMakeRange(0, 8)] mutableCopy];
    [randomizedArray doubleArray];
    [randomizedArray shuffle];
    array = randomizedArray;
    return array;
}

- (NSMutableArray *)resetArray:(NSMutableArray *)array
{
    // Reset matched and selected array
    [array removeAllObjects];
    return array;
}

- (NSInteger)resetScore:(NSInteger)score
{
    // Reset Score.
    score = 0;
    return score;
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval
{
    // Convert Timer to human readable values.
    NSInteger time = (NSInteger)interval;
    NSInteger seconds = time % 60;
    NSInteger minutes = (time / 60) % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
}


- (BOOL)annouceEndGame:(NSMutableArray *)array
{
    // Check if game ended.
    if (array.count == 16){
        return true;
    } else {
        return false;
    }
}

- (BOOL)chooseWhether:(NSInteger)currentScore or:(NSInteger)highScore
{
    // Checks if new score is higher the current Highscore.
    if (currentScore > highScore){
        return true;
    } else {
        return false;
    }
}

- (BOOL) chooseWether:(NSTimeInterval)currentTime or:(NSTimeInterval)bestTime
{
    // Checks if new time is better than current best time
    if (currentTime < bestTime)
    {
        return true;
    } else {
        return false;
    }
}



@end
