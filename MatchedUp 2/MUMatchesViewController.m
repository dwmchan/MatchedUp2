//
//  MUMatchesViewController.m
//  MatchedUp 2
//
//  Created by Donald Chan on 3/03/2014.
//  Copyright (c) 2014 iEndeavour. All rights reserved.
//

#import "MUMatchesViewController.h"
#import "MUChatViewController.h"

@interface MUMatchesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *availableChatRooms;

@end

@implementation MUMatchesViewController

#pragma mark - Lazy Instantiation
-(NSMutableArray *)availableChatRooms
{
    if (!_availableChatRooms) {
        _availableChatRooms = [[NSMutableArray alloc] init];
    }
    return _availableChatRooms;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self updateAvailableChatRooms];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MUChatViewController *chatVC = segue.destinationViewController;
    NSIndexPath *indexPath = sender;
    chatVC.chatRoom = [self.availableChatRooms objectAtIndex:indexPath.row];
}

#pragma mark - Helper Methods

-(void) updateAvailableChatRooms
{
    PFQuery *query = [PFQuery queryWithClassName:kCCChatRoomClassKey];
    [query whereKey:kCCChatRoomUser1Key equalTo:[PFUser currentUser]];
    PFQuery *queryInverse = [PFQuery queryWithClassName:kCCChatRoomClassKey];
    [query whereKey:kCCChatRoomUser2Key equalTo:[PFUser currentUser]];
    PFQuery *queryCombined = [PFQuery orQueryWithSubqueries:@[query, queryInverse]];
    [queryCombined includeKey:kCCChatClassKey];
    [queryCombined includeKey:kCCChatRoomUser1Key];
    [queryCombined includeKey:kCCChatRoomUser2Key];
    [queryCombined findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.availableChatRooms removeAllObjects];
            self.availableChatRooms = [objects mutableCopy];
            [self.tableView reloadData];
        }
    }];

}



#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.availableChatRooms count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *chatRoom = [self.availableChatRooms objectAtIndex:indexPath.row];
    
    PFUser *likedUser;
    PFUser *currentUser = [PFUser currentUser];
    
    PFUser *testUser1 = chatRoom[kCCChatRoomUser1Key];
    
    NSLog(@"%@, %@", testUser1.objectId, likedUser.objectId);
    
    if ([testUser1.objectId isEqual:currentUser.objectId]) {
        likedUser = [chatRoom objectForKey:kCCChatRoomUser2Key];
    }
    else {
        likedUser = [chatRoom objectForKey:kCCChatRoomUser1Key];
    }
    cell.textLabel.text = likedUser[kCCUserProfileKey][kCCUserProfileFirstNameKey];
    cell.detailTextLabel.text = chatRoom[@"createdAt"];
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    PFQuery *queryForPhoto = [[PFQuery alloc] initWithClassName:kCCPhotoClassKey];
    [queryForPhoto whereKey:kCCPhotoUserKey equalTo:likedUser];
    [queryForPhoto findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0) {
            PFObject *photo = objects[0];
            PFFile *pictureFile = photo[kCCPhotoPictureKey];
            [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                cell.imageView.image = [UIImage imageWithData:data];
                cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
            }];
        }
    }];
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //See Lecture 347 for reason why sender is set to indexPath and not nil.
    [self performSegueWithIdentifier:@"matchesToChatSegue" sender:indexPath];
}













@end
