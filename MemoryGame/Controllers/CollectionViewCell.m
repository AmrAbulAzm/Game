//
//  CollectionViewCell.m
//  MemoryGame
//
//  Created by Amr AbulAzm on 12/07/2016.
//  Copyright © 2016 Amr AbulAzm. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected
{
    // Handles selection and unselection state changes
    [super setSelected:selected];
    
    if (selected) {
        self.artworkImage.hidden = NO;
        self.contentView.backgroundColor = [UIColor clearColor];
        [self setUserInteractionEnabled:false];
    } else {
        self.artworkImage.hidden = YES;
        self.contentView.backgroundColor = [UIColor blackColor];
        [self setUserInteractionEnabled:true];
    }
}


@end
