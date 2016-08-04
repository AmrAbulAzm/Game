//
//  CollectionViewCell.h
//  MemoryGame
//
//  Created by Amr AbulAzm on 12/07/2016.
//  Copyright © 2016 Amr AbulAzm. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *CollectionViewCellIdentifier = @"CollectionViewCellIdentifier";

@interface CollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *artworkImage;

@end
