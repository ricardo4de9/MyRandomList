/**
 *  RandomUser.h
 *  Random User object based on data to be parsed from the endpoint request
 *
 *  @author Ricardo Lunar
 *  @version 1.0.0
 *  @since 2015-08-05
 */

#ifndef MyRandomList_RandomUser_h
#define MyRandomList_RandomUser_h

/**
 *  Defines accessible properties of the object given the data needed to be
 *  shown after making endpoint request.
 */
@interface RandomUser : NSObject

@property (nonatomic,retain) NSString *firstname;
@property (nonatomic,retain) NSString *lastname;
@property (nonatomic,retain) NSString *phone;
@property (nonatomic,retain) NSString *email;
@property (nonatomic,retain) NSString *thumnailURL;

/**
 *  Class function to parse a new RandomUser from a given JSON object
 *
 *  @param json NSDictionary created from endpoint request resulting array.
 *
 *  @return a new RandomUser with the JSON object contents
 */
+ (RandomUser *)parseRandomUserFromJSON: (NSDictionary *)json;

@end
#endif
