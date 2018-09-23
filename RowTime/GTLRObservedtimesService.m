// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   observedtimes/v1
// Description:
//   ObservedTimes API v1. This API allows the GET method to get a collection of
//   observed times since the last time the user asked for a list and a POST
//   method
//   to record new times

#import "GTLRObservedtimes.h"

// ----------------------------------------------------------------------------
// Authorization scope

NSString * const kGTLRAuthScopeObservedtimesUserinfoEmail = @"https://www.googleapis.com/auth/userinfo.email";

// ----------------------------------------------------------------------------
//   GTLRObservedtimesService
//

@implementation GTLRObservedtimesService

- (instancetype)init {
  self = [super init];
  if (self) {
    // From discovery.
    self.rootURLString = @"https://rowtime-26.appspot.com/_ah/api/";
    self.servicePath = @"observedtimes/v1/";
    self.batchPath = @"batch";
    self.prettyPrintQueryParameterNames = @[ @"prettyPrint" ];
  }
  return self;
}

@end
