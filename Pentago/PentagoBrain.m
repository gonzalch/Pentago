//
//  PentagoBrain.m
//  Pentago
//
//  Created by Ali Kooshesh on 2/5/13.
//  Copyright (c) 2013 SSU. All rights reserved.
//

#import "PentagoBrain.h"

@interface PentagoBrain() {
    BOOL playerTurn;
    BOOL playerRotate;
    BOOL redWin;
    BOOL greenWin;
    BOOL draw;
    NSMutableArray *gridZero;
    NSMutableArray *gridOne;
    NSMutableArray *gridTwo;
    NSMutableArray *gridThree;
    
    NSNumber *gridState[6][6];
}
@end


@implementation PentagoBrain

+(PentagoBrain *) sharedInstance
{
    static PentagoBrain *sharedObject = nil;
    
    if( sharedObject == nil ){
        sharedObject = [[PentagoBrain alloc] init];
    }
    
    return sharedObject;
}

-(BOOL)getRedWin
{
    return redWin;
}

-(BOOL)getGreenWin
{
    return greenWin;
}

-(BOOL)getDraw
{
    return draw;
}

- (void)sendWinNotification:(id)sender
{
    //NSLog(@"Notification sent");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"winAlert" object:nil];
}

-(id) init
{
    self = [super init];
    
    if (self) {
        playerTurn = YES;
        playerRotate = NO;
        redWin = NO;
        greenWin = NO;
        draw = NO;
        gridZero = [NSMutableArray new];
        gridOne = [NSMutableArray new];
        gridTwo = [NSMutableArray new];
        gridThree = [NSMutableArray new];
        
        for (int i = 0; i < 6; i++) {
            for (int j = 0; j < 6; j++) {
                gridState[i][j] = [NSNumber numberWithInteger:0];
            }
        }
    }
    
    return self;
}

-(void) setGridState: (int) rowVar : (int) columnVar : (int) stateInt : (int) subsquare
{
    if (subsquare == 0) {
        gridState[rowVar][columnVar] = [NSNumber numberWithInteger:stateInt];
    }
    
    if (subsquare == 1) {
        gridState[rowVar][columnVar + 3] = [NSNumber numberWithInteger:stateInt];
    }
    
    if (subsquare == 2) {
        gridState[rowVar + 3][columnVar] = [NSNumber numberWithInteger:stateInt];
    }
    
    if (subsquare == 3) {
        gridState[rowVar + 3][columnVar + 3] = [NSNumber numberWithInteger:stateInt];
    }
}

-(void) setPlayerTurn: (BOOL) playerTurnVar
{
    playerTurn = playerTurnVar;
}

-(BOOL) getPlayerTurn
{
    return playerTurn;
}

-(void) setPlayerRotate: (BOOL) playerRotateVar
{
    playerRotate = playerRotateVar;
}

-(BOOL) getPlayerRotate
{
    return playerRotate;
}

-(NSMutableArray *) getGrid: (int) gridNumber
{
    switch (gridNumber) {
        case 0:
            return gridZero;
            break;
            
        case 1:
            return gridOne;
            break;
            
        case 2:
            return gridTwo;
            break;
            
        case 3:
            return gridThree;
            break;
            
        default:
            break;
    }
}

-(void) addMarbleToGrid: (Marble *) marbleObject : (int) gridNumber
{
    switch (gridNumber) {
        case 0:
            [gridZero addObject:marbleObject];
            break;
            
        case 1:
            [gridOne addObject:marbleObject];
            break;
            
        case 2:
            [gridTwo addObject:marbleObject];
            break;
            
        case 3:
            [gridThree addObject:marbleObject];
            break;
            
        default:
            break;
    }
}

-(void) replaceMarbleOnGrid: (NSUInteger) marbleIndex : (Marble *) marbleObject : (int) gridNumber : (int) oldRow : (int) oldColumn
{
    switch (gridNumber) {
        case 0:
            [gridZero replaceObjectAtIndex:marbleIndex withObject:marbleObject];
            //gridState[[marbleObject getRow]][[marbleObject getColumn]] = ([marbleObject getColor] == YES) ? [NSNumber numberWithInteger:1] : [NSNumber numberWithInteger:2];
            
            gridState[oldRow][oldColumn] = [NSNumber numberWithInteger:0];
            
            if ([marbleObject getColor] == YES ) {
                gridState[[marbleObject getRow]][[marbleObject getColumn]] = [NSNumber numberWithInteger:1];
            }
            
            if ([marbleObject getColor] == NO) {
                gridState[[marbleObject getRow]][[marbleObject getColumn]] = [NSNumber numberWithInteger:2];
            }
            break;
            
        case 1:
            [gridOne replaceObjectAtIndex:marbleIndex withObject:marbleObject];
            //gridState[[marbleObject getRow]][[marbleObject getColumn] + 3] = ([marbleObject getColor] == YES) ? [NSNumber numberWithInteger:1] : [NSNumber numberWithInteger:2];
            gridState[oldRow][oldColumn + 3] = [NSNumber numberWithInteger:0];
            if ([marbleObject getColor] == YES ) {
                gridState[[marbleObject getRow]][[marbleObject getColumn] + 3] = [NSNumber numberWithInteger:1];
            }
            
            if ([marbleObject getColor] == NO) {
                gridState[[marbleObject getRow]][[marbleObject getColumn] + 3] = [NSNumber numberWithInteger:2];
            }
            break;
            
        case 2:
            [gridTwo replaceObjectAtIndex:marbleIndex withObject:marbleObject];
            //gridState[[marbleObject getRow] + 3][[marbleObject getColumn]] = ([marbleObject getColor] == YES) ? [NSNumber numberWithInteger:1] : [NSNumber numberWithInteger:2];
            gridState[oldRow + 3][oldColumn] = [NSNumber numberWithInteger:0];
            if ([marbleObject getColor] == YES ) {
                gridState[[marbleObject getRow] + 3][[marbleObject getColumn]] = [NSNumber numberWithInteger:1];
            }
            
            if ([marbleObject getColor] == NO) {
                gridState[[marbleObject getRow] + 3][[marbleObject getColumn]] = [NSNumber numberWithInteger:2];
            }
            break;
            
        case 3:
            [gridThree replaceObjectAtIndex:marbleIndex withObject:marbleObject];
            //gridState[[marbleObject getRow] + 3][[marbleObject getColumn] + 3] = ([marbleObject getColor] == YES) ? [NSNumber numberWithInteger:1] : [NSNumber numberWithInteger:2];
            gridState[oldRow + 3][oldColumn + 3] = [NSNumber numberWithInteger:0];
            if ([marbleObject getColor] == YES ) {
                gridState[[marbleObject getRow] + 3][[marbleObject getColumn] + 3] = [NSNumber numberWithInteger:1];
            }
            
            if ([marbleObject getColor] == NO) {
                gridState[[marbleObject getRow] + 3][[marbleObject getColumn] + 3] = [NSNumber numberWithInteger:2];
            }
            break;
            
        default:
            break;
    }
}

-(void) checkWinner
{
    int countRed, countGreen;
    //BOOL redWin = NO;
    //BOOL greenWin = NO;
    
    // check rows for winner
    for (int i = 0; i < 6; i++) {
        countRed = countGreen = 0;
        
        for (int j = 0; j < 6; j++) {
            if ([gridState[i][j] intValue] == 1){
                countRed++;
                countGreen = 0;
                //NSLog(@"Marble at position %d, %d is color %d", i, j, [gridState[i][j] intValue]);
                //NSLog(@"countRed at %d", countRed);
            }
            
            else if ([gridState[i][j] intValue] == 2) {
                countRed = 0;
                countGreen++;
                //NSLog(@"Marble at position %d, %d is color %d", i, j, [gridState[i][j] intValue]);
                //NSLog(@"countGreen at %d", countGreen);
            }
            
            else {
                countRed = 0;
                countGreen = 0;
                //NSLog(@"Chain broken");
            }
        }
        
        //if (countRed >= 5 && countGreen >= 5)
           // NSLog(@"Draw!");
        
        if (countRed >= 5) {
            redWin = YES;
            //NSLog(@"Red wins!");
        }
        
        if (countGreen >= 5) {
            greenWin = YES;
            //NSLog(@"Green wins");
        }
    }
    
    // check columns for winner
    for (int j = 0; j < 6; j++) {
        countRed = countGreen = 0;
        
        for (int i = 0; i < 6; i++) {
            if ([gridState[i][j] intValue] == 1){
                countRed++;
                countGreen = 0;
                //NSLog(@"Marble at position %d, %d is color %d", i, j, [gridState[i][j] intValue]);
                //NSLog(@"countRed at %d", countRed);
            }
            
            else if ([gridState[i][j] intValue] == 2) {
                countRed = 0;
                countGreen++;
                //NSLog(@"Marble at position %d, %d is color %d", i, j, [gridState[i][j] intValue]);
                //NSLog(@"countGreen at %d", countGreen);
            }
            
            else {
                countRed = 0;
                countGreen = 0;
                //NSLog(@"Chain broken");
            }
            
            if (countRed >= 5)
                redWin = YES;
            
            if (countGreen >= 5) {
                greenWin = YES;
            }
            
        }
    }
    
    // check diagonal 0,0 to 5,5
    for (int i = 0; i < 6; i++) {
        if ([gridState[i][i] intValue] == 1){
            countRed++;
            countGreen = 0;
            //NSLog(@"Marble at position %d, %d is color %d", i, j, [gridState[i][j] intValue]);
            //NSLog(@"countRed at %d", countRed);
        }
        
        else if ([gridState[i][i] intValue] == 2) {
            countRed = 0;
            countGreen++;
            //NSLog(@"Marble at position %d, %d is color %d", i, j, [gridState[i][j] intValue]);
            //NSLog(@"countGreen at %d", countGreen);
        }
        
        else {
            countRed = 0;
            countGreen = 0;
            //NSLog(@"Chain broken");
        }
        
        if (countRed >= 5)
            redWin = YES;
        
        if (countGreen >= 5) {
            greenWin = YES;
        }

    }
    
    // check diagonal 1,0 to 5,4
    for (int i = 0; i < 5; i++) {
        if ([gridState[i+1][i] intValue] == 1){
            countRed++;
            countGreen = 0;
            //NSLog(@"Marble at position %d, %d is color %d", i, j, [gridState[i][j] intValue]);
            //NSLog(@"countRed at %d", countRed);
        }
        
        else if ([gridState[i+1][i] intValue] == 2) {
            countRed = 0;
            countGreen++;
            //NSLog(@"Marble at position %d, %d is color %d", i, j, [gridState[i][j] intValue]);
            //NSLog(@"countGreen at %d", countGreen);
        }
        
        else {
            countRed = 0;
            countGreen = 0;
            //NSLog(@"Chain broken");
        }
        
        if (countRed >= 5)
            redWin = YES;
        
        if (countGreen >= 5) {
            greenWin = YES;
        }
        
    }
    
    // check diagonal from 0,1 to 4,5
    for (int i = 0; i < 5; i++) {
        if ([gridState[i][i+1] intValue] == 1){
            countRed++;
            countGreen = 0;
            //NSLog(@"Marble at position %d, %d is color %d", i, j, [gridState[i][j] intValue]);
            //NSLog(@"countRed at %d", countRed);
        }
        
        else if ([gridState[i][i+1] intValue] == 2) {
            countRed = 0;
            countGreen++;
            //NSLog(@"Marble at position %d, %d is color %d", i, j, [gridState[i][j] intValue]);
            //NSLog(@"countGreen at %d", countGreen);
        }
        
        else {
            countRed = 0;
            countGreen = 0;
            //NSLog(@"Chain broken");
        }
        
        if (countRed >= 5)
            redWin = YES;
        
        if (countGreen >= 5) {
            greenWin = YES;
        }
        
    }
    
    // check diagonal from 5,0 to 0,5
    for (int i = 5; i >= 0; i--) {
        if ([gridState[i][5-i] intValue] == 1) {
            countRed++;
            countGreen = 0;
            //NSLog(@"Marble at position %d, %d is color %d", i, 5-i, [gridState[i][5-i] intValue]);
            //NSLog(@"countRed at %d", countRed);
        }
        
        else if ([gridState[i][5-i] intValue] == 2) {
            countRed = 0;
            countGreen++;
            //NSLog(@"Marble at position %d, %d is color %d", i, 5-i, [gridState[i][5-i] intValue]);
            //NSLog(@"countGreen at %d", countGreen);
        }
        
        else {
            countRed = 0;
            countGreen = 0;
            //NSLog(@"Chain broken");
        }
        
        if (countRed >= 5)
            redWin = YES;
        
        if (countGreen >= 5) {
            greenWin = YES;
        }

    }
    
    // check diagonal from 4,0 to 0,4
    for (int i = 4; i >= 0; i--) {
        if ([gridState[i][4-i] intValue] == 1) {
            countRed++;
            countGreen = 0;
            //NSLog(@"Marble at position %d, %d is color %d", i, 5-i, [gridState[i][5-i] intValue]);
            //NSLog(@"countRed at %d", countRed);
        }
        
        else if ([gridState[i][4-i] intValue] == 2) {
            countRed = 0;
            countGreen++;
            //NSLog(@"Marble at position %d, %d is color %d", i, 5-i, [gridState[i][5-i] intValue]);
            //NSLog(@"countGreen at %d", countGreen);
        }
        
        else {
            countRed = 0;
            countGreen = 0;
            //NSLog(@"Chain broken");
        }
        
        if (countRed >= 5)
            redWin = YES;
        
        if (countGreen >= 5) {
            greenWin = YES;
        }
        
    }
    
    // check diagonal from 5,1 to 1,5
    for (int i = 5; i > 0; i--) {
        if ([gridState[i][6-i] intValue] == 1) {
            countRed++;
            countGreen = 0;
            //NSLog(@"Marble at position %d, %d is color %d", i, 5-i, [gridState[i][5-i] intValue]);
            //NSLog(@"countRed at %d", countRed);
        }
        
        else if ([gridState[i][6-i] intValue] == 2) {
            countRed = 0;
            countGreen++;
            //NSLog(@"Marble at position %d, %d is color %d", i, 5-i, [gridState[i][5-i] intValue]);
            //NSLog(@"countGreen at %d", countGreen);
        }
        
        else {
            countRed = 0;
            countGreen = 0;
            //NSLog(@"Chain broken");
        }
        
        if (countRed >= 5)
            redWin = YES;
        
        if (countGreen >= 5) {
            greenWin = YES;
        }
        
    }
    
    if (redWin && greenWin){
        //NSLog(@"Draw!");
        draw = YES;
       
        
        [self sendWinNotification:self];
    }
    
    else if (redWin){
        //NSLog(@"Red wins!");
       
        [self sendWinNotification:self];
    }
    else if (greenWin){
        //NSLog(@"Green wins");
        
        [self sendWinNotification:self];
    }
}

@end
