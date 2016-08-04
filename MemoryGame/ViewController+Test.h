//
//  ViewController+Test.h
//  MemoryGame
//
//  Created by Amr AbulAzm on 14/07/2016.
//  Copyright © 2016 Amr AbulAzm. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (Test)

- (NSMutableArray *)createRandomArray:(NSArray*)array;
- (NSMutableArray *)resetArray:(NSMutableArray *)array;
- (NSInteger)resetScore:(NSInteger)score;
- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval;
- (BOOL)annouceEndGame:(NSMutableArray *)array;
- (BOOL)chooseWhether:(NSInteger)currentScore or:(NSInteger)highScore;
- (BOOL)chooseWether:(NSTimeInterval)currentTime or:(NSTimeInterval)bestTime;

@end
