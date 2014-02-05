//
//  PentagoSubboardViewController.m
//  Pentago
//
//  Created by Ali Kooshesh on 2/5/13.
//  Copyright (c) 2013 SSU. All rights reserved.
//

#import "PentagoSubboardViewController.h"

const int BORDER_WIDTH = 10;
const int TOP_MARGIN = 50;

@interface PentagoSubboardViewController () {
    int subsquareNumber;
    int widthOfSubsquare;
}

@property (nonatomic, strong) PentagoBrain *pBrain;
@property (nonatomic, strong) UIImageView *gridImageView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGest;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipe;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipe;
//@property (nonatomic, strong) NSMutableArray *marbleObjects;

-(void) didTapTheView: (UITapGestureRecognizer *) tapObject;

@end

@implementation PentagoSubboardViewController

@synthesize pBrain = _pBrain;
@synthesize gridImageView = _gridImageView;
@synthesize tapGest = _tapGest;
@synthesize leftSwipe = _leftSwipe;
@synthesize rightSwipe = _rightSwipe;
//@synthesize marbleObjects = _marbleObjects;
//BOOL playerTurn = YES;
//BOOL waitForRotate = NO;
//BOOL playerRotate = YES;
BOOL whichSwipe = YES;
//int swipeCounterLeft = 0;
//int swipeCounterRight = 0;

-(UITapGestureRecognizer *) tapGest
{
    if( ! _tapGest ) {
        _tapGest = [[UITapGestureRecognizer alloc]
                    initWithTarget:self action:@selector(didTapTheView:)];
        
        [_tapGest setNumberOfTapsRequired:1];
        [_tapGest setNumberOfTouchesRequired:1];
    }
    return _tapGest;
}

-(UIGestureRecognizer *) leftSwipe
{
    if ( ! _leftSwipe ) {
        _leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
        [_leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    }
    
    return _leftSwipe;
}


-(void) didSwipeLeft: (UIGestureRecognizer *) swipeObject
{
    //NSLog(@"in didRoateView %@", swipeObject);
    
    //animationActive = YES;
    if ([self.pBrain getPlayerRotate] == YES) {
        whichSwipe = YES;
        CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        [rotate setFromValue:[NSNumber numberWithDouble:0.0]];
        [rotate setToValue: [NSNumber numberWithDouble: M_PI / -2.0]];
        [rotate setDuration:1.5];
        [rotate setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]];
        [rotate setDelegate:self];
        
        [[self.view layer] addAnimation:rotate forKey:@"counter-clockwise rotation"];
    }
}


-(UIGestureRecognizer *) rightSwipe
{
    if (! _rightSwipe) {
        _rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight:)];
        
        [_rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    }
    
    return _rightSwipe;
}

-(void) didSwipeRight: (UIGestureRecognizer *) swipeObject
{
    //NSLog(@"in didRoateView %@", swipeObject);
    
    //animationActive = YES;
    if ([self.pBrain getPlayerRotate] == YES) {
        whichSwipe = NO;
        CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        [rotate setFromValue:[NSNumber numberWithDouble:0.0]];
        [rotate setToValue: [NSNumber numberWithDouble: M_PI / 2.0]];
        [rotate setDuration:1.5];
        [rotate setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]];
        [rotate setDelegate:self];
        
        [[self.view layer] addAnimation:rotate forKey:@"clockwise rotation"];
    }
    
}

-(void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    // counter-clockwise rotation
    if (whichSwipe) {
        
        //NSLog(@"counterclockwise rotation whichSwipe = %d", whichSwipe);
        //if (swipeCounterLeft % 2 == 0) {
        for (int i = 0; i < [[self.pBrain getGrid:subsquareNumber] count]; i++) {
            Marble *tempMarble = [Marble new];
            tempMarble = [[self.pBrain getGrid:subsquareNumber] objectAtIndex:i];
            
            int onePosition = widthOfSubsquare / 3;
            
            // position 0,0
            // becomes  2,0
            if ([tempMarble getRow] == 0 && [tempMarble getColumn] == 0) {
                
                UIImageView *temp = [tempMarble getMarbleImageView];
                CGPoint p = temp.center;
                p.y += onePosition * 2;
                temp.center = p;
                
                // replace marble in array with new position
                Marble *tempM2 = [[Marble alloc] initWithValues:2 :0 :[tempMarble getColor] :temp];
                
                
                [self.pBrain replaceMarbleOnGrid:i :tempM2 :subsquareNumber :0 :0];
                
                CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                [rotate setFromValue:[NSNumber numberWithDouble:M_PI / 2.0]];
                [rotate setToValue: [NSNumber numberWithDouble: 0]];
                [rotate setDuration:0.5];
                [rotate setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]];
                [[temp layer] addAnimation:rotate forKey:@"marble unroates"];
            }
            
            // position 0,1
            // becomes  1,0
            if ([tempMarble getRow] == 0 && [tempMarble getColumn] == 1) {
                UIImageView *temp = [tempMarble getMarbleImageView];
                CGPoint p = temp.center;
                p.x -= onePosition;
                p.y += onePosition;
                temp.center = p;
                
                // replace marble in array with new position
                Marble *tempM2 = [[Marble alloc] initWithValues:1 :0 :[tempMarble getColor] :temp];
                [self.pBrain replaceMarbleOnGrid:i :tempM2 :subsquareNumber :0 :1];
                
                CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                [rotate setFromValue:[NSNumber numberWithDouble:M_PI / 2.0]];
                [rotate setToValue: [NSNumber numberWithDouble: 0]];
                [rotate setDuration:0.5];
                [rotate setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]];
                [[temp layer] addAnimation:rotate forKey:@"marble unroates"];
            }
            
            // position 0,2
            // becomes 0,0
            if ([tempMarble getRow] == 0 && [tempMarble getColumn] == 2) {
                UIImageView *temp = [tempMarble getMarbleImageView];
                CGPoint p = temp.center;
                p.x -= onePosition * 2;
                temp.center = p;
                
                // replace marble in array with new position
                Marble *tempM2 = [[Marble alloc] initWithValues:0 :0 :[tempMarble getColor] :temp];
                [self.pBrain replaceMarbleOnGrid:i :tempM2 :subsquareNumber :0 :2];
                
                CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                [rotate setFromValue:[NSNumber numberWithDouble:M_PI / 2.0]];
                [rotate setToValue: [NSNumber numberWithDouble: 0]];
                [rotate setDuration:0.5];
                [rotate setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]];
                [[temp layer] addAnimation:rotate forKey:@"marble unroates"];
            }
            
            // position 1,0
            // becomes  2,1
            if ([tempMarble getRow] == 1 && [tempMarble getColumn] == 0) {
                UIImageView *temp = [tempMarble getMarbleImageView];
                CGPoint p = temp.center;
                p.x += onePosition;
                p.y += onePosition;
                temp.center = p;
                
                // replace marble in array with new position
                Marble *tempM2 = [[Marble alloc] initWithValues:2 :1 :[tempMarble getColor] :temp];
                [self.pBrain replaceMarbleOnGrid:i :tempM2 :subsquareNumber :1 :0];
                
                CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                [rotate setFromValue:[NSNumber numberWithDouble:M_PI / 2.0]];
                [rotate setToValue: [NSNumber numberWithDouble: 0]];
                [rotate setDuration:0.5];
                [rotate setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]];
                [[temp layer] addAnimation:rotate forKey:@"marble unroates"];
            }
            
            // position 1,1
            // becomes  1,1
            if ([tempMarble getRow] == 1 && [tempMarble getColumn] == 1) {
                UIImageView *temp = [tempMarble getMarbleImageView];
                
                CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                [rotate setFromValue:[NSNumber numberWithDouble:M_PI / 2.0]];
                [rotate setToValue: [NSNumber numberWithDouble: 0]];
                [rotate setDuration:0.5];
                [rotate setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]];
                [[temp layer] addAnimation:rotate forKey:@"marble unroates"];
            }
            
            // position 1,2
            // becomes  0,1
            if ([tempMarble getRow] == 1 && [tempMarble getColumn] == 2) {
                UIImageView *temp = [tempMarble getMarbleImageView];
                CGPoint p = temp.center;
                p.x -= onePosition;
                p.y -= onePosition;
                temp.center = p;
                
                // replace marble in array with new position
                Marble *tempM2 = [[Marble alloc] initWithValues:0 :1 :[tempMarble getColor] :temp];
                [self.pBrain replaceMarbleOnGrid:i :tempM2 :subsquareNumber :1 :2];
                
                CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                [rotate setFromValue:[NSNumber numberWithDouble:M_PI / 2.0]];
                [rotate setToValue: [NSNumber numberWithDouble: 0]];
                [rotate setDuration:0.5];
                [rotate setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]];
                [[temp layer] addAnimation:rotate forKey:@"marble unroates"];
            }
            
            // position 2,0
            // becomes  2,2
            if ([tempMarble getRow] == 2 && [tempMarble getColumn] == 0) {
                UIImageView *temp = [tempMarble getMarbleImageView];
                CGPoint p = temp.center;
                p.x += onePosition * 2;
                temp.center = p;
                
                // replace marble in array with new position
                Marble *tempM2 = [[Marble alloc] initWithValues:2 :2 :[tempMarble getColor] :temp];
                [self.pBrain replaceMarbleOnGrid:i :tempM2 :subsquareNumber :2 :0];
                
                CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                [rotate setFromValue:[NSNumber numberWithDouble:M_PI / 2.0]];
                [rotate setToValue: [NSNumber numberWithDouble: 0]];
                [rotate setDuration:0.5];
                [rotate setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]];
                [[temp layer] addAnimation:rotate forKey:@"marble unroates"];
            }
            
            // position 2,1
            // becomes  1,2
            if ([tempMarble getRow] == 2 && [tempMarble getColumn] == 1) {
                UIImageView *temp = [tempMarble getMarbleImageView];
                CGPoint p = temp.center;
                p.x += onePosition;
                p.y -= onePosition;
                temp.center = p;
                
                // replace marble in array with new position
                Marble *tempM2 = [[Marble alloc] initWithValues:1 :2 :[tempMarble getColor] :temp];
                [self.pBrain replaceMarbleOnGrid:i :tempM2 :subsquareNumber :2 :1];
                
                CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                [rotate setFromValue:[NSNumber numberWithDouble:M_PI / 2.0]];
                [rotate setToValue: [NSNumber numberWithDouble: 0]];
                [rotate setDuration:0.5];
                [rotate setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]];
                [[temp layer] addAnimation:rotate forKey:@"marble unroates"];
            }
            
            // position 2,2
            // becomes  0,2
            if ([tempMarble getRow] == 2 && [tempMarble getColumn] == 2) {
                UIImageView *temp = [tempMarble getMarbleImageView];
                CGPoint p = temp.center;
                p.y -= onePosition * 2;
                temp.center = p;
                
                // replace marble in array with new position
                Marble *tempM2 = [[Marble alloc] initWithValues:0 :2 :[tempMarble getColor] :temp];
                [self.pBrain replaceMarbleOnGrid:i :tempM2 :subsquareNumber :2 :2];
                
                CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                [rotate setFromValue:[NSNumber numberWithDouble:M_PI / 2.0]];
                [rotate setToValue: [NSNumber numberWithDouble: 0]];
                [rotate setDuration:0.5];
                [rotate setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]];
                [[temp layer] addAnimation:rotate forKey:@"marble unroates"];
            }
        }
        [self.pBrain setPlayerRotate:NO];
        [self sendLabelNotification:self];
        [self.pBrain checkWinner];
    }
    
    // clockwise rotation
    else {
        //NSLog(@"clockwise rotation whichSwipe = %d", whichSwipe);
        for (int i = 0; i < [[self.pBrain getGrid:subsquareNumber] count]; i++) {
            Marble *tempMarble = [Marble new];
            tempMarble = [[self.pBrain getGrid:subsquareNumber] objectAtIndex:i];
            
            int onePosition = widthOfSubsquare / 3;
            
            // position 0,0
            // becomes  0,2
            if ([tempMarble getRow] == 0 && [tempMarble getColumn] == 0) {
                
                UIImageView *temp = [tempMarble getMarbleImageView];
                CGPoint p = temp.center;
                p.x += onePosition * 2;
                temp.center = p;
                
                // replace marble in array with new position
                Marble *tempM2 = [[Marble alloc] initWithValues:0 :2 :[tempMarble getColor] :temp];
                [self.pBrain replaceMarbleOnGrid:i :tempM2 :subsquareNumber :0 :0];
                
                CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                [rotate setFromValue:[NSNumber numberWithDouble:M_PI / 2.0]];
                [rotate setToValue: [NSNumber numberWithDouble: 0]];
                [rotate setDuration:0.5];
                [rotate setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]];
                [[temp layer] addAnimation:rotate forKey:@"marble unroates"];
            }
            
            // position 0,1
            // becomes  1,2
            if ([tempMarble getRow] == 0 && [tempMarble getColumn] == 1) {
                UIImageView *temp = [tempMarble getMarbleImageView];
                CGPoint p = temp.center;
                p.x += onePosition;
                p.y += onePosition;
                temp.center = p;
                
                // replace marble in array with new position
                Marble *tempM2 = [[Marble alloc] initWithValues:1 :2 :[tempMarble getColor] :temp];
                [self.pBrain replaceMarbleOnGrid:i :tempM2 :subsquareNumber :0 :1];
                
                CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                [rotate setFromValue:[NSNumber numberWithDouble:M_PI / 2.0]];
                [rotate setToValue: [NSNumber numberWithDouble: 0]];
                [rotate setDuration:0.5];
                [rotate setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]];
                [[temp layer] addAnimation:rotate forKey:@"marble unroates"];
            }
            
            // position 0,2
            // becomes  2,2
            if ([tempMarble getRow] == 0 && [tempMarble getColumn] == 2) {
                UIImageView *temp = [tempMarble getMarbleImageView];
                CGPoint p = temp.center;
                p.y += onePosition * 2;
                temp.center = p;
                
                // replace marble in array with new position
                Marble *tempM2 = [[Marble alloc] initWithValues:2 :2 :[tempMarble getColor] :temp];
                [self.pBrain replaceMarbleOnGrid:i :tempM2 :subsquareNumber :0 :2];
                
                CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                [rotate setFromValue:[NSNumber numberWithDouble:M_PI / 2.0]];
                [rotate setToValue: [NSNumber numberWithDouble: 0]];
                [rotate setDuration:0.5];
                [rotate setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]];
                [[temp layer] addAnimation:rotate forKey:@"marble unroates"];
            }
            
            // position 1,0
            // becomes  0,1
            if ([tempMarble getRow] == 1 && [tempMarble getColumn] == 0) {
                UIImageView *temp = [tempMarble getMarbleImageView];
                CGPoint p = temp.center;
                p.x += onePosition;
                p.y -= onePosition;
                temp.center = p;
                
                // replace marble in array with new position
                Marble *tempM2 = [[Marble alloc] initWithValues:0 :1 :[tempMarble getColor] :temp];
                [self.pBrain replaceMarbleOnGrid:i :tempM2 :subsquareNumber :1 :0];
                
                CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                [rotate setFromValue:[NSNumber numberWithDouble:M_PI / 2.0]];
                [rotate setToValue: [NSNumber numberWithDouble: 0]];
                [rotate setDuration:0.5];
                [rotate setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]];
                [[temp layer] addAnimation:rotate forKey:@"marble unroates"];
            }
            
            // position 1,1
            // becomes  1,1
            if ([tempMarble getRow] == 1 && [tempMarble getColumn] == 1) {
                UIImageView *temp = [tempMarble getMarbleImageView];
                
                CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                [rotate setFromValue:[NSNumber numberWithDouble:M_PI / 2.0]];
                [rotate setToValue: [NSNumber numberWithDouble: 0]];
                [rotate setDuration:0.5];
                [rotate setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]];
                [[temp layer] addAnimation:rotate forKey:@"marble unroates"];
            }
            
            // position 1,2
            // becomes  2,1
            if ([tempMarble getRow] == 1 && [tempMarble getColumn] == 2) {
                UIImageView *temp = [tempMarble getMarbleImageView];
                CGPoint p = temp.center;
                p.x -= onePosition;
                p.y += onePosition;
                temp.center = p;
                
                // replace marble in array with new position
                Marble *tempM2 = [[Marble alloc] initWithValues:2 :1 :[tempMarble getColor] :temp];
                [self.pBrain replaceMarbleOnGrid:i :tempM2 :subsquareNumber :1 :2];
                
                CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                [rotate setFromValue:[NSNumber numberWithDouble:M_PI / 2.0]];
                [rotate setToValue: [NSNumber numberWithDouble: 0]];
                [rotate setDuration:0.5];
                [rotate setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]];
                [[temp layer] addAnimation:rotate forKey:@"marble unroates"];
            }
            
            // position 2,0
            // becomes  0,0
            if ([tempMarble getRow] == 2 && [tempMarble getColumn] == 0) {
                UIImageView *temp = [tempMarble getMarbleImageView];
                CGPoint p = temp.center;
                p.y -= onePosition * 2;
                temp.center = p;
                
                // replace marble in array with new position
                Marble *tempM2 = [[Marble alloc] initWithValues:0 :0 :[tempMarble getColor] :temp];
                [self.pBrain replaceMarbleOnGrid:i :tempM2 :subsquareNumber :2 :0];
                
                CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                [rotate setFromValue:[NSNumber numberWithDouble:M_PI / 2.0]];
                [rotate setToValue: [NSNumber numberWithDouble: 0]];
                [rotate setDuration:0.5];
                [rotate setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]];
                [[temp layer] addAnimation:rotate forKey:@"marble unroates"];
            }
            
            // position 2,1
            // becomes  1,0
            if ([tempMarble getRow] == 2 && [tempMarble getColumn] == 1) {
                UIImageView *temp = [tempMarble getMarbleImageView];
                CGPoint p = temp.center;
                p.x -= onePosition;
                p.y -= onePosition;
                temp.center = p;
                
                // replace marble in array with new position
                Marble *tempM2 = [[Marble alloc] initWithValues:1 :0 :[tempMarble getColor] :temp];
                [self.pBrain replaceMarbleOnGrid:i :tempM2 :subsquareNumber :2 :1];
                
                CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                [rotate setFromValue:[NSNumber numberWithDouble:M_PI / 2.0]];
                [rotate setToValue: [NSNumber numberWithDouble: 0]];
                [rotate setDuration:0.5];
                [rotate setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]];
                [[temp layer] addAnimation:rotate forKey:@"marble unroates"];
            }
            
            // position 2,2
            // becomes  2,0
            if ([tempMarble getRow] == 2 && [tempMarble getColumn] == 2) {
                UIImageView *temp = [tempMarble getMarbleImageView];
                CGPoint p = temp.center;
                p.x -= onePosition * 2;
                temp.center = p;
                
                // replace marble in array with new position
                Marble *tempM2 = [[Marble alloc] initWithValues:2 :0 :[tempMarble getColor] :temp];
                [self.pBrain replaceMarbleOnGrid:i :tempM2 :subsquareNumber :2 :2];
                
                CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                [rotate setFromValue:[NSNumber numberWithDouble:M_PI / 2.0]];
                [rotate setToValue: [NSNumber numberWithDouble: 0]];
                [rotate setDuration:0.5];
                [rotate setTimingFunction:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]];
                [[temp layer] addAnimation:rotate forKey:@"marble unroates"];
            }
        }
        
        [self.pBrain setPlayerRotate:NO];
        [self sendLabelNotification:self];
        [self.pBrain checkWinner];
    }

}


-(PentagoBrain *) pBrain
{
    if( ! _pBrain )
        _pBrain = [PentagoBrain sharedInstance];
    return _pBrain;
}

-(UIImageView *) gridImageView
{
    if( ! _gridImageView ) {
        _gridImageView = [[UIImageView alloc] initWithFrame: CGRectZero];
    }
    return _gridImageView;
}

-(id) initWithSubsquare: (int) position
{
    // 0 1
    // 2 3
    if( (self = [super init]) == nil )
        return nil;
    subsquareNumber = position;
    // appFrame is the frame of the entire screen so that appFrame.size.width
    // and appFrame.size.height contain the width and the height of the screen, respectively.
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    widthOfSubsquare = ( appFrame.size.width - 3 * BORDER_WIDTH ) / 2;
    return self;
}

-(void) didTapTheView: (UITapGestureRecognizer *) tapObject
{
    // p is the location of the tap in this view, not the view of the the view-controller that
    // includes the subboards.
    CGPoint p = [tapObject locationInView:self.view];
    // the board is divided into nine equally sized squares and thus width = height.
    int squareWidth = widthOfSubsquare / 3;
    int row = 0;
    int column = 0;
    BOOL marbleHere = NO;
    
    if (p.y <= squareWidth) {
        row = 0;
    }
    
    else if (p.y > squareWidth && p.y <= squareWidth*2) {
        row = 1;
    }
    
    else if (p.y > squareWidth*2 && p.y <= squareWidth*3) {
        row = 2;
    }
    
    if (p.x <= squareWidth) {
        column = 0;
    }
    
    else if (p.x > squareWidth && p.x <= squareWidth*2) {
        column = 1;
    }
    
    else if (p.x > squareWidth*2 && p.x <= squareWidth*3) {
        column = 2;
    }
    
    for (int i = 0; i < [[self.pBrain getGrid:subsquareNumber] count]; i++) {
        if ([[[self.pBrain getGrid:subsquareNumber] objectAtIndex:i] getRow] == row && [[[self.pBrain getGrid:subsquareNumber] objectAtIndex:i] getColumn] == column) {
            marbleHere = YES;
        }
    }
    
    // place a red marble
    if ([self.pBrain getPlayerTurn] == YES && [self.pBrain getPlayerRotate] == NO && marbleHere == NO) {
        
        UIImageView *iView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redMarble.png"]];
        iView.frame = CGRectMake((int) (p.x / squareWidth) * squareWidth,
                                 (int) (p.y / squareWidth) * squareWidth,
                                 squareWidth - BORDER_WIDTH / 3,
                                 squareWidth - BORDER_WIDTH / 3);
        
        [self.view addSubview:iView];
        [self.pBrain setPlayerRotate:YES];
        [self sendLabelNotification:self];
        [self.pBrain setPlayerTurn:NO];
        
        
        Marble *tempMarble = [[Marble alloc] initWithValues:row :column :YES :iView];
        //[tempMarble initWithValues:row :column :YES :iView];
        
        [self.pBrain addMarbleToGrid:tempMarble :subsquareNumber];
        [self.pBrain setGridState:row :column :1 :subsquareNumber];
        
        [self.pBrain checkWinner];
        //NSLog(@"marbleObjects contains %d objects", [self.marbleObjects count]);
    }
    
    // place a green marble
    else if ([self.pBrain getPlayerTurn] == NO && [self.pBrain getPlayerRotate] == NO && marbleHere == NO) {
        UIImageView *iView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"greenMarble.png"]];
        iView.frame = CGRectMake((int) (p.x / squareWidth) * squareWidth,
                                 (int) (p.y / squareWidth) * squareWidth,
                                 squareWidth - BORDER_WIDTH / 3,
                                 squareWidth - BORDER_WIDTH / 3);
        
        //topLeftImageView = iView;
        [self.view addSubview:iView];
        [self.pBrain setPlayerRotate:YES];
        [self sendLabelNotification:self];
        [self.pBrain setPlayerTurn:YES];
        
        Marble *tempMarble = [[Marble alloc] initWithValues:row :column :NO :iView];
        //[tempMarble initWithValues:row :column :NO :iView];
        
        [self.pBrain addMarbleToGrid:tempMarble :subsquareNumber];
        [self.pBrain setGridState:row :column :2 :subsquareNumber];
        [self.pBrain checkWinner];
        //NSLog(@"marbleObjects contains %d objects", [self.marbleObjects count]);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //_marbleObjects = [[NSMutableArray alloc] init];
    
    CGRect ivFrame = CGRectMake(0, 0, widthOfSubsquare, widthOfSubsquare);
    //CGRect tliv = CGRectMake(0, 0, widthOfSubsquare/3, widthOfSubsquare/3);
    self.gridImageView.frame = ivFrame;
    //topLeftImageView.frame = tliv;
    UIImage *image = [UIImage imageNamed:@"grid.png"];
    [self.gridImageView setImage:image];
    [self.view addSubview:self.gridImageView];
    [self.view addGestureRecognizer: self.tapGest];
    [self.view addGestureRecognizer: self.leftSwipe];
    [self.view addGestureRecognizer:self.rightSwipe];
    
    CGRect viewFrame = CGRectMake( (BORDER_WIDTH + widthOfSubsquare) * (subsquareNumber % 2) + BORDER_WIDTH,
                                  (BORDER_WIDTH + widthOfSubsquare) * (subsquareNumber / 2) + BORDER_WIDTH + TOP_MARGIN,
                                  widthOfSubsquare, widthOfSubsquare);
    self.view.frame = viewFrame;
}

-(PentagoBrain *)getPBrain
{
    return self.pBrain;
}

- (void)sendLabelNotification:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"theChange" object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
