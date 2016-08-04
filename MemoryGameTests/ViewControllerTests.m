//
//  ViewControllerTests.m
//  MemoryGame
//
//  Created by Amr AbulAzm on 14/07/2016.
//  Copyright © 2016 Amr AbulAzm. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"
#import "ViewController+Test.h"

@interface ViewControllerTests : XCTestCase

@property (nonatomic) ViewController *memoryViewController;

@end

@implementation ViewControllerTests

- (void)setUp
{
    [super setUp];
    self.memoryViewController = [[ViewController alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateRandomArray
{
    NSArray *originalArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"1",@"2",@"3",@"4",@"1",@"2",@"3",@"4", nil];
    NSArray *randomizedArray = [self.memoryViewController createRandomArray:originalArray];
    NSArray *expectedArray = [NSMutableArray arrayWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1", nil];
    XCTAssertNotEqualObjects(randomizedArray, expectedArray);
    XCTAssertEqual(randomizedArray.count, expectedArray.count);
}


- (void)testResetArray
{
    NSMutableArray *originalArray = [NSMutableArray arrayWithObjects:@"1",@"2", nil];
    NSMutableArray *expectedArray = [NSMutableArray arrayWithObjects:@"1",@"2", nil];
    [expectedArray removeAllObjects];
    NSMutableArray *resetArray = [self.memoryViewController resetArray:originalArray];
    XCTAssertEqualObjects(resetArray, expectedArray);
}

- (void)testResetScore
{
    NSInteger input = 10;
    NSInteger expectedOutput = 0;
    NSInteger resetValue = [self.memoryViewController resetScore:input];
    XCTAssertEqual(expectedOutput, resetValue);
}

- (void)testAnnouceEndGame
{
    NSMutableArray *input = [NSMutableArray arrayWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1", nil];
    XCTAssertTrue([self.memoryViewController annouceEndGame:input]);
}

- (void)testChooseWetherCurrentScoreOrHighScore
{
    NSInteger firstInput = 15;
    NSInteger secondInput = 10;
    XCTAssertTrue([self.memoryViewController chooseWhether:firstInput or:secondInput]);
}

- (void)testChooseWetherCurrentTimeOrBestTime
{
    NSTimeInterval firstInput = 10;
    NSTimeInterval secondInput = 15;
    XCTAssertTrue([self.memoryViewController chooseWether:firstInput or:secondInput]);
}

@end
