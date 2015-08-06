/**
 *  URLConnectionFacade.m
 *  Class to handle HTTP requests
 *
 *  @author Ricardo Lunar
 *  @version 1.0.0
 *  @since 2015-08-05
 */

#import <Foundation/Foundation.h>
#import "URLConnectionDelegate.h"

@implementation URLConnectionFacade

@synthesize receivedData;

/**
 *  Constructor of class. Conventionally added.
 */
- init {
    if ((self = [super init])) {
        
    }
    return self;
}

/**
 *  Delegate setter for this class
 *
 *  @param val is the delegate class to callback after a successful request
 */
- (void)setDelegate:(id)val
{
    delegate = val;
}


/**
 *  Delegate getter for this class
 *
 *  @return the delegate of this class
 */
- (id)delegate
{
    return delegate;
}

/**
 *  This method performs a HTTP request to the given URL string, using GET Method
 *
 *  @param urlString is the URL to execute the request
 */
- (void)get:(NSString *)urlString {
    
    NSLog (@"[URLConnectionFacade] GET Request: %@", urlString );
    
    self.receivedData = [[NSMutableData alloc] init];
    
    // Initializing the request
    NSURLRequest *request = [[NSURLRequest alloc]
                                initWithURL: [NSURL URLWithString:urlString]
                                cachePolicy: NSURLRequestReloadIgnoringLocalCacheData
                                timeoutInterval: 10];
    
    // Initializing the connection
    NSURLConnection *connection = [[NSURLConnection alloc]
                                        initWithRequest:request
                                        delegate:self
                                        startImmediately:YES];
    
    // Checking if there is still a connection available
    if(!connection) {
        NSLog(@"[URLConnectionFacade] Connection failed");
    } else {
        NSLog(@"[URLConnectionFacade] Connection succeeded");
        
    }
}

#pragma mark NSURLConnection delegate methods

/**
 *  The following method are NSURLConnection CALLBACK METHODS.
 *  They handle the different states of the connection and allow to perform
 *  an action for each state.
 *
 *  @param connection       the current connection
 *  @param request          the request to execute
 *  @param redirectResponse the response
 *
 *  @return the executed request
 */
- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)redirectResponse {
    return request;
}

/**
 *  Callback executed when the request has been accepted by the server and has received a response
 *
 *  @param connection the current connection
 *  @param response   the received response
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [receivedData setLength:0];
}

/**
 *  Callback executed after the request has received data from the server
 *
 *  @param connection the current connection
 *  @param data       the received data
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

/**
 *  Callback executed after the request has failed and returns an error
 *
 *  @param connection the current connection
 *  @param error      the received error
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"[URLConnectionFacade] Error receiving response: %@", error);
}

/**
 *  Callback executed after the request has finished loading
 *
 *  @param connection the current connection
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"[URLConnectionFacade] Succeeded! Received %lu bytes of data", (unsigned long)[receivedData length]);
    
    // Verify if the delegate implements the protocol
    if ([delegate respondsToSelector:@selector(didFinishDownload:)]) {
        NSLog(@"[URLConnectionFacade] Calling the delegate");
        [delegate performSelector:@selector(didFinishDownload:) withObject: receivedData];
    }
}


@end