//
//  ContactManager.m
//  Whisper
//
//  Created by kino on 14-10-11.
//
//

#import "ContactManager.h"

#import <CoreData/CoreData.h>

#import "XmppManager.h"



@interface ContactManager()<NSFetchedResultsControllerDelegate>{
    NSMutableArray *_allContacts;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation ContactManager

@synthesize allContacts = _allContacts;


static ContactManager *sharedInstance = nil;
+ (ContactManager *)sharedInstance
{
    @synchronized(self){
        if (sharedInstance == nil){
            sharedInstance = [[self alloc] init];
            [sharedInstance customInit];
        }
    }
    return sharedInstance;
}

- (NSMutableArray *)allContacts{
//    if (! _allContacts) {
        _allContacts = [[self fetchedResultsController].fetchedObjects mutableCopy];
//    }
    return _allContacts;
    
}


- (void)customInit{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(allContactHasFetched)
                                                 name:kAllContactHasFetched object:nil];
}

///获取到了所有联系人
- (void)allContactHasFetched{
    NSLog(@"当前联系人：%d",_allContacts.count);
//    _allContacts = [[self fetchedResultsController].fetchedObjects mutableCopy];
    NSLog(@"当前联系人：%d",_allContacts.count);
}

#pragma mark NSFetchedResultsController
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSFetchedResultsController *)fetchedResultsController{
    if (_fetchedResultsController == nil){
        NSManagedObjectContext *moc = [[XmppManager sharedInstance] managedObjectContext_roster];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
                                                  inManagedObjectContext:moc];
        
        NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
        NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
        
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        [fetchRequest setSortDescriptors:sortDescriptors];
        [fetchRequest setFetchBatchSize:10];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:moc
                                                                          sectionNameKeyPath:@"sectionNum"
                                                                                   cacheName:nil];
        [_fetchedResultsController setDelegate:self];
        
        
        NSError *error = nil;
        if (![_fetchedResultsController performFetch:&error]){
            //            DDLogError(@"Error performing fetch: %@", error);
        }
    }
    
    return _fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    if (self.contactHasBeenRefresh) {
        NSLog(@"%d",_allContacts.count);
        self.contactHasBeenRefresh();
    }
//    [[self tableView] reloadData];
}


@end
