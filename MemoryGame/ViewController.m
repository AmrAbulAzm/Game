//
//  ViewController.m
//  MemoryGame
//
//  Created by Amr AbulAzm on 11/07/2016.
//  Copyright © 2016 Amr AbulAzm. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "CollectionViewCell.h"
#import "NSMutableArray+Shuffle.h"
#import "ViewController+Test.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) NSMutableArray *matchedArray;

@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSTimeInterval currentTimeInterval;
@property (nonatomic) NSTimeInterval bestTimeInterval;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger HighScore;

@property (nonatomic, strong) NSArray *urlsArray;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *highScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentHighScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentBestTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *startGameButton;




@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.score = 0 ;
    self.HighScore = 0;
    
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    self.imagesArray = [NSMutableArray array];
    self.selectedArray = [NSMutableArray array];
    self.matchedArray = [NSMutableArray array];
    
    self.startGameButton.backgroundColor = [UIColor orangeColor];
    [self.startGameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.collectionView.backgroundColor = [UIColor orangeColor];
    self.collectionView.allowsMultipleSelection = YES;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup a.k.a The Foreign Affairs

- (void) fetchData
{
    // Api call, set type to application/xml, extract urls, Error Handling.
    NSString *url = @"http://api.soundcloud.com/playlists/79670980?client_id=aa45989bb0c262788e2d11f1ea041b65";
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSArray *tracksArray = [responseObject objectForKey:@"tracks"];
        for (NSDictionary *track in tracksArray)
        {
            NSString *artWorkURL = [track objectForKey:@"artwork_url"];
            [self.imagesArray addObject:artWorkURL];
        }
        self.urlsArray = self.imagesArray;
        self.urlsArray = [self createRandomArray:self.urlsArray];
        [self.collectionView reloadData];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [self.timer invalidate];
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Oops"
                                      message:@"Internet problem! Try Again by starting a new game."
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
}


#pragma mark - CollectionView a.k.a The Bureaucracy

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 16;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Setup Images onto grid Async
    CollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    NSString *imageURL = self.urlsArray[indexPath.row];
    dispatch_async(dispatch_get_main_queue(), ^{
        cell.artworkImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
    });
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Setup 4*4 Grid
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 5.0;
    CGSize size = CGSizeMake(cellWidth, cellWidth);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Add selected objects to selected Array.
    [self.selectedArray addObject:indexPath];
    [self checkMatches];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove unselected objects from selected Array.
    [self.selectedArray removeObject:indexPath];
}

#pragma mark - Game Play a.k.a The "Engine"

- (IBAction)startNewGame:(id)sender
{
    // Start New Game.
    [self resetArray:self.matchedArray];
    [self resetArray:self.selectedArray];
    [self resetScore];
    [self fetchData];
    [self startTimer];
}

- (void)resetScore
{
    // Reset Score
    self.score = 0;
    self.currentHighScoreLabel.text = [NSString stringWithFormat:@"%ld",self.score];
}

- (void)endGame
{
    // Handle Game Ending.
    if ([self annouceEndGame:self.matchedArray])
    {
        [self calculateBestScore];
        [self calculateBestTime];
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Congrats"
                                      message:@"You finished the game!!"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        [self.timer invalidate];
    }
}


- (void)checkMatches
{
    // Check for matches in selected Array, update score, Error handling and different cases consideration and reactions.
    if (self.selectedArray.count == 2)
    {
        [self.collectionView setUserInteractionEnabled:NO];
        NSIndexPath *index1 = [self.selectedArray firstObject];
        NSIndexPath *index2 = [self.selectedArray lastObject];
        NSString *str1 = [self.urlsArray objectAtIndex:index1.row];
        NSString *str2 = [self.urlsArray objectAtIndex:index2.row];
        if ([str1 isEqualToString: str2])
        {
            self.score = self.score + 10;
            [self.matchedArray addObjectsFromArray:self.selectedArray];
            [self.collectionView setUserInteractionEnabled:YES];
        } else {
            self.score = self.score - 5;
            [self performSelector:@selector(delayedUnselection) withObject:self afterDelay:0.5];
        }
        [self.selectedArray removeAllObjects];
    }
    [self displayScore];
    [self endGame];
}

- (void) delayedUnselection
{
    // At wrong match, Unselects choices with a delay
    for(NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems) {
        if (![self.matchedArray containsObject:indexPath]) {
            [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
        }
    }
    [self.collectionView setUserInteractionEnabled:YES];
}

#pragma mark - Score & Time a.k.a The Numbers

- (void)timerTick:(NSTimer *)timer
{
    // Calculates Timer and displays it.
    self.currentTimeInterval = fabs([self.startTime timeIntervalSinceNow]);
    self.currentBestTimeLabel.text = [self stringFromTimeInterval:self.currentTimeInterval];
}

- (void)startTimer
{
    // Fire Timer at the beginning of each game and schedule its continouty.
    self.startTime = [NSDate date];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    [self.timer fire];
}

-(void)calculateBestTime
{
    // Display best time.
    if ([self chooseWether:self.currentTimeInterval or:self.bestTimeInterval] || (self.bestTimeInterval == 0))
    {
        self.bestTimeInterval = self.currentTimeInterval;
        self.bestTimeLabel.text = [self stringFromTimeInterval:self.currentTimeInterval];
    }
}

- (void)displayScore
{
    // Displays score.
    self.currentHighScoreLabel.text = [NSString stringWithFormat:@"%ld",self.score];
}

- (void)calculateBestScore
{
    // Displays best score.
    if ([self chooseWhether:self.score or:self.HighScore]){
        self.HighScore = self.score;
        self.highScoreLabel.text = [NSString stringWithFormat:@"%ld",self.score];
    }
}





@end
