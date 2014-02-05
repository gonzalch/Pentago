//
//  Marble.m
//  Pentago
//
//  Created by Chris Gonzalez on 2/15/13.
//  Copyright (c) 2013 SSU. All rights reserved.
//

#import "Marble.h"

@interface Marble() {
    int row;
    int column;
    BOOL color;
}
@property (nonatomic, strong) UIImageView *marblePlaced;

@end

@implementation Marble

@synthesize marblePlaced = _marblePlaced;

-(id) initWithValues: (int) rowVar : (int) columnVar : (BOOL) colorVar : (UIImageView *) marbleImageView {
    
    self = [super init];
    
    if (self) {
        row = rowVar;
        column = columnVar;
        color = colorVar;
        self.marblePlaced = marbleImageView;
    }
    
    return self;
}

-(UIImageView *)getMarbleImageView
{
    return _marblePlaced;
}

-(int)getRow
{
    return row;
}

-(int)getColumn
{
    return column;
}

-(BOOL)getColor
{
    return color;
}

@end

