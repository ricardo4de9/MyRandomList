/**
 *  RandomUser.m
 *  Random User object based on data to be parsed from the endpoint request
 *
 *  @author Ricardo Lunar
 *  @version 1.0.0
 *  @since 2015-08-05
 */

#import <Foundation/Foundation.h>
#import "RandomUser.h"

/**
 *  Defines accessible properties of the object given the data needed to be
 *  shown after making endpoint request.
 */
@implementation RandomUser

@synthesize firstname,lastname,email,phone,thumnailURL;

/**
 *  Class function to parse a new RandomUser from a given JSON object
 *
 *  @param json NSDictionary created from endpoint request resulting array.
 *
 *  @return a new RandomUser with the JSON object contents
 */
+ (RandomUser *)parseRandomUserFromJSON: (NSDictionary *)json {
    RandomUser *user = [[RandomUser alloc] init];
    
    user.firstname   = [[json objectForKey:@"name"] objectForKey:@"first"];
    user.lastname    = [[json objectForKey:@"name"] objectForKey:@"last"];
    user.phone       = [json objectForKey:@"phone"];
    user.email       = [json objectForKey:@"email"];
    user.thumnailURL = [[json objectForKey:@"picture"] objectForKey:@"thumbnail"];
    
    return user;
}

@end