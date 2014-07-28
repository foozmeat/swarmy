//
//  ListenTableViewController.h
//  Swarmy
//
//  Created by James Moore on 7/19/12.
//  Copyright (c) 2012 Panic. All rights reserved.
//

#import <EZAudio/EZAudio.h>

@interface ListenTableViewController : UITableViewController <UITextViewDelegate, EZMicrophoneDelegate, EZOutputDataSource>

@end
