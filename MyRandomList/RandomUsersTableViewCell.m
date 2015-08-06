/**
 *  RandomUsersTableViewCell.m
 *  TableView cell outline for custom style cells data handling
 *
 *  @author Ricardo Lunar
 *  @version 1.0.0
 *  @since 2015-08-05
 */

#import "RandomUsersTableViewCell.h"

/**
 *  TableView cell outline for custom style cells data handling
 */
@implementation RandomUsersTableViewCell

@synthesize fullname,phone,email,thumbnail;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
