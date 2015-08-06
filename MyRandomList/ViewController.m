/**
 *  VideoController.m
 *  Main view controller for the application.
 *  Conforms to protocols for both TableView and SearchBar delegates,
 *  as well as for the custom URLConnection delegate.
 *
 *  @author Ricardo Lunar
 *  @version 1.0.0
 *  @since 2015-08-05
 */

#import <SDWebImage/UIImageView+WebCache.h> // SDWebImage

#import "ViewController.h"
#import "RandomUser.h"
#import "RandomUsersTableViewCell.h"


/**
 *  Automatically created class to control main view of the application.
 *  Conforms to protocols for both TableView and SearchBar delegates,
 *  as well as for the custom URLConnection delegate.
 */
@implementation ViewController


/**
 *  This method initializes all the required objects to control the main view.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Initializing the URLConnection facade object
    facade = [[URLConnectionFacade alloc] init];
    [facade setDelegate:self];
    
    // Loading RandomUsers...
    [self getRandomUsers:nil];
    
    // Setting delegate and data source to link the controller to the table view
    [mTableView setDelegate:self];
    [mTableView setDataSource:self];
    
    // Initializing filtered data array to avoid null attempts to access this content
    filteredDataArray = [[NSMutableArray alloc] init];
    searchIsActive = false;
    
    
}


/**
 *  Method gets called before the application exits.
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  Method gets called after the view appears
 *
 *  @param animated boolean to indicate default appearing mode
 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Registering notifications to resize TableView when keyboard shows/hides
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}



/**
 *  Method gets called just after the view disappears
 *
 *  @param animated boolean to indicate default disappearing mode
 */
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // De-registering the keyboard observers
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


#pragma Data Source Methods


/**
 *  Establishes how many rows will be displayed in the TableView.
 *  for every section.
 *
 *  @param tableView is the UI element sent as a parameter each time this function executes.
 *  @param section   is the index of the current section.
 *
 *  @return the number of rows to be displayed.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numOfRows = [dataArray count];
    
    // if search is active, count the elements in the filtered array.
    if(searchIsActive) {
        numOfRows = [filteredDataArray count];
    }
    
    return numOfRows;
}


/**
 *  Cell updating function for TableView observer.
 *
 *  @param tableView the UI element to be modified
 *  @param indexPath the NSIndexPath of the cell to be modified in the table.
 *
 *  @return cell with contents of dataArray element (RandomUser) for the given indexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RandomUsersTableViewCell * cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"RandomUsersListCell" forIndexPath:indexPath];
    
    RandomUser *user;
    
    // If search is active, get data from filtered array. Doing normally, otherwise.
    if(searchIsActive) {
        user = (RandomUser *) [filteredDataArray objectAtIndex:indexPath.row];
    }else {
        user = (RandomUser *) [dataArray objectAtIndex:indexPath.row];
    }
    
    cell.fullname.text   = [NSString stringWithFormat:@"%@ %@",user.firstname,user.lastname];
    cell.phone.text      = user.phone;
    cell.email.text      = user.email;
    
    // Using SDWebImage Library to optimize photo loading...
    [cell.thumbnail sd_setImageWithURL:[NSURL URLWithString:user.thumnailURL]];
    
    return cell;
}


#pragma Enpoint requesting Method


/**
 *  Load button observer handler.
 *  Executes after the Load button of the view is pressed.
 *
 *  @param sender is the UIBarButtonItem placed in the UI to make request.
 */
- (IBAction)getRandomUsers:(id)sender {
    
    // Executing request to API endpoint...
    [facade get:@"http://api.randomuser.me/?results=50"];
}



#pragma URLConnectionDelegate Method


/**
 *  URLConnectionDelegate protocol method to handle request response.
 *
 *  @param json is the request response parsed into a NSMutableData object.
 */
- (void)didFinishDownload:(NSMutableData*)json {
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    // Verify if NSJSONSerialization class exists in this iOS version
    if(NSClassFromString(@"NSJSONSerialization"))
    {
        NSError *error = nil;
        id object = [NSJSONSerialization
                     JSONObjectWithData:json
                     options:0
                     error:&error];
        
        // Verifying if there was any error, handling appropriately.
        if(error) { /* JSON was malformed, act appropriately here */ }
        
        // Verifying if the parsed object is a properly formed NSDictionary
        if([object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* results = [object objectForKey:@"results"];
            
            // Filling up the resulting array with RandomUser objects from the received data.
            for (NSDictionary* jsonUser in results) {
                RandomUser* user = [RandomUser parseRandomUserFromJSON:[jsonUser objectForKey:@"user"]];
                [data addObject:user];
            }
        }
    }
    dataArray = [NSMutableArray arrayWithArray:data];
    [mTableView reloadData];
}


#pragma Search Bar Methods


/**
 *  Method to handle search bar inputs and list filtering each time the user
 *  writes a new letter.
 *
 *  @param searchBar is sent as a parameter every time the method gets called.
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // Only filter if there is some text to do it. Reload back original, otherwise.
    if (![searchText isEqualToString:@""]) {
        searchIsActive = true;
        
        NSLog(@"[ViewController] Searching for: %@",searchText);
        
        // Remove all previous objects from the filtered search array
        [filteredDataArray removeAllObjects];
        
        // Filter the array using NSPredicate
        NSString* filterStr = @"(SELF.firstname CONTAINS[cd] %@) OR (SELF.lastname CONTAINS[cd] %@)";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:filterStr, searchText, searchText];
        
        filteredDataArray = [NSMutableArray arrayWithArray:[dataArray filteredArrayUsingPredicate:predicate]];
    }else {
        searchIsActive = false;
        
    }
    
    [mTableView reloadData];
}


#pragma Keyboard Event Methods


/**
 *  This method runs when the UIKeyboardWillShowNotification is triggered.
 *  It resizes the TableView in order to be able to see all the items in the list.
 *
 *  @param notification a UIKeyboardWillShowNotification.
 */
- (void)keyboardWillShow:(NSNotification *)notification {
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect newTableFrame = mTableView.frame;
    //Here make adjustments to the tableview frame based on the value in keyboard size
    
    newTableFrame.size.height = newTableFrame.size.height - keyboardSize.height;
    
    mTableView.frame = newTableFrame;
}


/**
 *  This method runs when the UIKeyboardWillHideNotification is triggered.
 *  It resizes the TableView back to its original size.
 *
 *  @param notification a UIKeyboardWillHideNotification.
 */
- (void)keyboardWillHide:(NSNotification *)notification {
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect newTableFrame = mTableView.frame;
    
    // Resize frame back to original height
    newTableFrame.size.height = newTableFrame.size.height + keyboardSize.height;
    
    mTableView.frame = newTableFrame;
}

@end
