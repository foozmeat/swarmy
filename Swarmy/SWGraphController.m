//
//  SWGraphController.m
//  Swarmy
//
//  Created by James Moore on 3/11/14.
//  Copyright (c) 2014 James Moore. All rights reserved.
//

#import "SWGraphController.h"
#import "SWHiveStore.h"
#import "CorePlot-CocoaTouch.h"
#import "SWSampleSet.h"

@interface SWGraphController()

@property (nonatomic, strong) IBOutlet CPTGraphHostingView *hostView;
@property (nonatomic, strong) CPTTheme *selectedTheme;
@property (nonatomic, strong) NSArray *sampleSets;

@end

@implementation SWGraphController

#pragma mark - Chart behavior

- (void)initPlot
{
	[self configureGraph];
	[self configureChart];
	[self configureLegend];
}

- (void)configureGraph
{
	// Create a CPTGraph object and add to hostView
	CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
	graph.paddingLeft = 10.0;
	graph.paddingTop = 10.0;
	graph.paddingRight = 10.0;
	graph.paddingBottom = 10.0;

	self.hostView.hostedGraph = graph;
}

- (void)configureChart
{

	// Get the (default) plotspace from the graph so we can set its x/y ranges
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) self.hostView.hostedGraph.defaultPlotSpace;

	// Note that these CPTPlotRange are defined by START and LENGTH (not START and END) !!
	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( -50 ) length:CPTDecimalFromFloat( 50 )];
	plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( 0 ) length:CPTDecimalFromFloat( 10 )];

	// Create the plot (we do not define actual x/y values yet, these will be supplied by the datasource...)
	CPTScatterPlot *plot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];

	// Let's keep it simple and let this class act as datasource (therefore we implemtn <CPTPlotDataSource>)
	plot.dataSource = self;

	// Finally, add the created plot to the default plot space of the CPTGraph object we created before
	[self.hostView.hostedGraph addPlot:plot toPlotSpace:self.hostView.hostedGraph.defaultPlotSpace];
}

- (void)configureLegend
{
}

#pragma mark - CPTPlotDataSource

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plotnumberOfRecords
{
	return 9; // Our sample graph contains 9 'points'
}

// This method is here because this class also functions as datasource for our graph
// Therefore this class implements the CPTPlotDataSource protocol
- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
	// We need to provide an X or Y (this method will be called for each) value for every index
	NSUInteger x = index - 4;

	// This method is actually called twice per point in the plot, one for the X and one for the Y value
	if (fieldEnum == CPTScatterPlotFieldX) {
		// Return x value, which will, depending on index, be between -4 to 4
		return [NSNumber numberWithUnsignedInteger: x];
	} else {
		// Return y value, for this example we'll be plotting y = x * x
		return [NSNumber numberWithUnsignedInteger: x * x];
	}
}

#pragma mark - view lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];

	NSPredicate *hive = [NSPredicate predicateWithFormat:@"hive == %@", [[SWHiveStore defaultStore] activeHive]];

//	NSPredicate *class = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@",[SWSampleSet class]];

	NSCompoundPredicate *predicates = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType subpredicates:@[hive]];

	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SWHiveRecord"];

	fetchRequest.predicate = predicates;

	self.sampleSets = [SWHiveRecord MR_executeFetchRequest:fetchRequest];

	DLog(@"%@", self.sampleSets);
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	// The plot is initialized here, since the view bounds have not transformed for landscape until now
	[self initPlot];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[[NSNotificationCenter defaultCenter] addObserver:self
																					 selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification
																						 object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

	[[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)orientationChanged:(NSNotification *)notification
{

	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];

	if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
		[self dismissViewControllerAnimated:YES completion:nil];
		DLog(@"Rotating to portrait");
	} else {

	}

}

- (void)canRotate
{ }

@end
