//
//  AsWord.h
//  ActionSomething
//
//  Created by Tang Xiaomin on 6/8/13.
//  Copyright (c) 2013 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsWord : NSObject

@property(weak, nonatomic) NSString* name;
@property(weak, nonatomic) NSNumber* level;

-(id) initWithName:(NSString*)name level:(NSNumber*)level;

@end
