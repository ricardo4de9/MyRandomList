/**
 *  URLConnectionDelegate.h
 *  Protocol to be implemented by classes in need of the URLConnectionFacade
 *
 *  @author Ricardo Lunar
 *  @version 1.0.0
 *  @since 2015-08-05
 */

#ifndef RandomUserList_URLConnectionDelegate_h
#define RandomUserList_URLConnectionDelegate_h

#import "URLConnectionFacade.h"

/**
 *  Defines a protocol to be implemented by the classes in need of
 *  the URLConnectionFacade.
 *  All classes must implement the method in order to receive the data
 *  collected after executing the request.
 */
@protocol URLConnectionDelegate <NSObject>

/**
 *  Callback function to allow the receiving class to sort out what to do
 *  with the request response
 *
 *  @param json is the received response in NSMutableData format.
 */
- (void)didFinishDownload:(NSMutableData*)json;

@end

#endif
