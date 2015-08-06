/**
 *  VideoController.h
 *  Main view controller for the application.
 *
 *  @author Ricardo Lunar
 *  @version 1.0.0
 *  @since 2015-08-05
 */

#import <UIKit/UIKit.h>
#import "URLConnectionDelegate.h"

/**
 *  Automatically created class to control main view of the application.
 *  Conforms to protocols for both TableView and SearchBar delegates,
 *  as well as for the custom URLConnection delegate.
 */
@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, URLConnectionDelegate> {
    NSMutableArray *dataArray;
    NSMutableArray *filteredDataArray;
    URLConnectionFacade *facade;
    IBOutlet UITableView *mTableView;
    IBOutlet UISearchBar *mSearchBar;
    BOOL searchIsActive;
}


#pragma Enpoint requesting Method


/**
 *  Load button observer handler.
 *  Executes after the Load button of the view is pressed.
 *
 *  @param sender is the UIBarButtonItem placed in the UI to make request.
 */
- (IBAction)getRandomUsers:(id)sender;


#pragma URLConnectionDelegate Method


/**
 *  URLConnectionDelegate protocol method to handle request response.
 *
 *  @param json is the request response parsed into a NSMutableData object.
 */
- (void)didFinishDownload:(NSMutableData*)json;

@end

