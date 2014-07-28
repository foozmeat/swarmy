//
//  AFMeter.h
//
//  Created by James Moore on 7/4/12.
//

#import <UIKit/UIKit.h>
#define barSpacing 0.0
#define barWidth 2.0
#define padding 3.0
#define updateInterval 2;
#define pauseLength 10;

@interface SWAFMeter : UIView

@property float volume;
@property int pauseCount;
@property int maxNumBars;
@property int barHeight;
@property int maxBarNumber;
@property int updateCount;

@end
