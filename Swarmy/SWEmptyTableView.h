//
//  EmptyTableView.h
//  Swarmy
//
//  Created by James Moore on 1/22/13.
//  Copyright (c) 2013 Panic. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface SWEmptyTableView : UITableView

@property (strong, nonatomic)  NSString *labelText;
- (bool)hasRows;

@end
