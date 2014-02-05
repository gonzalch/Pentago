//
//  Marble.h
//  Pentago
//
//  Created by Chris Gonzalez on 2/15/13.
//  Copyright (c) 2013 SSU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Marble : NSObject

-(id) initWithValues: (int) rowVar : (int) columnVar : (BOOL) colorVar : (UIImageView *) marbleObject;
-(UIImageView *) getMarbleImageView;
-(int) getRow;
-(int) getColumn;
-(BOOL) getColor;

@end
