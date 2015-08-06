/**
 *  URLConnectionFacade.h
 *  Class to handle HTTP requests
 *
 *  @author Ricardo Lunar
 *  @version 1.0.0
 *  @since 2015-08-05
 */

#ifndef RandomUserList_URLConnectionFacade_h
#define RandomUserList_URLConnectionFacade_h

/**
 *  A facade class to handle HTTP requests
 */
@interface URLConnectionFacade : NSObject {
    id             delegate;
    NSMutableData *receivedData;
    NSURL         *url;
}

@property (nonatomic,retain) NSMutableData *receivedData;
@property (retain) id delegate;

/**
 *  This method performs a HTTP request to the given URL string, using GET Method
 *
 *  @param urlString is the URL to execute the request
 */
- (void)get:(NSString *)urlString;

@end

#endif
