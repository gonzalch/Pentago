//
//  PentagoBrain.h
//  Pentago
//
//  Created by Ali Kooshesh on 2/5/13.
//  Copyright (c) 2013 SSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Marble.h"

# define ROW_LENGTH = 3;

@interface PentagoBrain : NSObject


+(PentagoBrain *) sharedInstance;
-(id) init;
-(void) setPlayerTurn: (BOOL) playerTurnVar;
-(BOOL) getPlayerTurn;
-(void) setPlayerRotate: (BOOL) playerRotateVar;
-(BOOL) getPlayerRotate;
-(NSMutableArray *) getGrid: (int) gridNumber;
-(void) addMarbleToGrid: (Marble *) marbleObject : (int) gridNumber;
-(void) replaceMarbleOnGrid: (NSUInteger) marbleIndex : (Marble *) marbleObject : (int) gridNumber : (int) oldRow : (int) oldColumn;
-(void) checkWinner;
-(void) setGridState: (int) rowVar : (int) columnVar : (int) stateInt : (int) subsquare;
-(BOOL)getRedWin;
-(BOOL)getGreenWin;
-(BOOL)getDraw;
@end
