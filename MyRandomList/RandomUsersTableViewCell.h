/**
 *  RandomUsersTableViewCell.h
 *
 *  @author Ricardo Lunar
 *  @version 1.0.0
 *  @since 2015-08-05
 */

#import <UIKit/UIKit.h>

/**
 *  TableView cell outline for custom style cells data handling
 *  No methods of this view controller need to be implemented since
 *  the cells are not required to have an action attach to them.
 */
@interface RandomUsersTableViewCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UILabel       *fullname;
@property (nonatomic,retain) IBOutlet UILabel       *phone;
@property (nonatomic,retain) IBOutlet UILabel       *email;
@property (nonatomic,retain) IBOutlet UIImageView   *thumbnail;

@end
