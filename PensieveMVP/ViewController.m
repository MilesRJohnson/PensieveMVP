//
//  ViewController.m
//  PensieveMVP
//
//  Created by Miles Johnson on 6/23/15.
//  Copyright (c) 2015 StarshipEnterprise. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Memories.h"
@interface ViewController ()

@property (nonatomic, strong)          AppDelegate                   * appDelegate;
@property (nonatomic, strong)          NSManagedObjectContext        * managedObjectContext;
@property (nonatomic, strong)          NSArray                       * memoryArray;
@property (nonatomic, strong) IBOutlet UITextView                    * noteTextView;
@property (nonatomic, strong) IBOutlet UILabel                       * dateLabel;
@property (nonatomic, strong) IBOutlet UISlider                      * timeLineSlider;
@property (nonatomic, strong)          Memories                      * currentMemory;
@property (nonatomic, strong) IBOutlet UIButton                      * beginMemoryButton;


@end

@implementation ViewController

#pragma mark - Interactivity Methods
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return false;
    }
    return true;
}

- (IBAction)changeSlider:(id)sender{
    _currentMemory = _memoryArray[(int)_timeLineSlider.value];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE MMM d"];
    _noteTextView.text = [_currentMemory memoryNote];
    _dateLabel.text = [formatter stringFromDate:[_currentMemory memoryDate]];
    
    //_dateLabel.text = [NSString stringWithFormat:@"%@",[_memoryArray[(int)_timeLineSlider.value] memoryDate]];
}

- (void)textViewDidChange:(NSNotification *)notification {
    [_currentMemory setMemoryNote:_noteTextView.text];
    [_appDelegate saveContext];
}

- (IBAction)newEntry:(id)sender{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //Current Day
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
//    NSInteger todayDay = [todayComponents day];
//    NSInteger todayMonth = [todayComponents month];
//    NSInteger todayYear = [todayComponents year];
    NSDate *newTodayDate = [gregorian dateFromComponents:todayComponents];
    //Most Recent Day in Journal
    NSDateComponents *memoryDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[[_memoryArray lastObject] memoryDate]];
//    NSInteger Currentday = [memoryDateComponents day];
//    NSInteger Currentmonth = [memoryDateComponents month];
//    NSInteger Currentyear = [memoryDateComponents year];
    NSDate *newMemoryDate = [gregorian dateFromComponents:memoryDateComponents];

    if ([newMemoryDate isEqualToDate:newTodayDate]) {
        _beginMemoryButton.enabled = false;
    }
    else {
        //Change View For User
        _noteTextView.text = @"";
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"EEEE MMM d"];
        _dateLabel.text = [formatter stringFromDate:[NSDate date]];
    
        //Update Database
        Memories *newMemory = (Memories *)[NSEntityDescription insertNewObjectForEntityForName:@"Memories" inManagedObjectContext:_managedObjectContext];
        NSDateFormatter *mmddccyy = [[NSDateFormatter alloc] init];
        mmddccyy.dateFormat = @"MM/dd/yyyy";
        [newMemory setMemoryDate:[NSDate date]];
        [newMemory setMemoryNote:_noteTextView.text];
        [_appDelegate saveContext];
        _memoryArray = [self fetchItems];
        //update Slider
        _timeLineSlider.maximumValue = _memoryArray.count - 1;
        _timeLineSlider.value = _memoryArray.count - 1;
    
        //update Date
        _currentMemory = _memoryArray[(int)_timeLineSlider.value];
        _dateLabel.text = [formatter stringFromDate:[_currentMemory memoryDate]];
    }
}

#pragma - Database Methods
- (void)tempAddRecords {
    Memories *newMemory = (Memories *)[NSEntityDescription insertNewObjectForEntityForName:@"Memories" inManagedObjectContext:_managedObjectContext];
    NSDateFormatter *mmddccyy = [[NSDateFormatter alloc] init];
    mmddccyy.dateFormat = @"MM/dd/yyyy";
    //12
    NSDate *date = [mmddccyy dateFromString:@"06/12/2015"];
    [newMemory setMemoryDate:date];
    [newMemory setMemoryNote:@"Today I ate Tacos. I was happy. Class was nice."];
    //13
    date = [mmddccyy dateFromString:@"06/13/2015"];
    [newMemory setMemoryDate:date];
    [newMemory setMemoryNote:@"Very stressed today. Need Pie ASAP!"];
    //14
    date = [mmddccyy dateFromString:@"06/14/2015"];
    [newMemory setMemoryDate:date];
    [newMemory setMemoryNote:@"Been working all day, but finally happy to take a break."];
    //15
    date = [mmddccyy dateFromString:@"06/15/2015"];
    [newMemory setMemoryDate:date];
    [newMemory setMemoryNote:@"Gosh I wish I had those tacos from a few days ago!"];
    //16
    date = [mmddccyy dateFromString:@"06/16/2015"];
    [newMemory setMemoryDate:date];
    [newMemory setMemoryNote:@"Lots and lots of homework. Need to get some new shoes."];
    //17
    date = [mmddccyy dateFromString:@"06/17/2015"];
    [newMemory setMemoryDate:date];
    [newMemory setMemoryNote:@"Good day in class, got all of the concepts."];
    //18
    date = [mmddccyy dateFromString:@"06/18/2015"];
    [newMemory setMemoryDate:date];
    [newMemory setMemoryNote:@"Bad day in class, understood nothing."];
    //19
    date = [mmddccyy dateFromString:@"06/19/2015"];
    [newMemory setMemoryDate:date];
    [newMemory setMemoryNote:@"I miss my dog Algernon. Wish he was with me in DC"];
    //20
    date = [mmddccyy dateFromString:@"06/20/2015"];
    [newMemory setMemoryDate:date];
    [newMemory setMemoryNote:@"Went to a nice play today. Kind of an older crowd, but I enjoyed myself nontheless"];
    //21
    date = [mmddccyy dateFromString:@"06/21/2015"];
    [newMemory setMemoryDate:date];
    [newMemory setMemoryNote:@"All I want to do is slee.."];
    //22
    date = [mmddccyy dateFromString:@"06/22/2015"];
    [newMemory setMemoryDate:date];
    [newMemory setMemoryNote:@"Long day today, but found a way to grind through my work. Happy I got it all done."];
    //23
    date = [mmddccyy dateFromString:@"06/23/2015"];
    [newMemory setMemoryDate:date];
    [newMemory setMemoryNote:@"Thinking about pie most of today, occasionally thinking about code."];
    
    [_appDelegate saveContext];
}

- (void)deleteObject {
    Memories *tempMemory = [_memoryArray objectAtIndex:12];
    [_managedObjectContext deleteObject:tempMemory];
    [_appDelegate saveContext];
    //    [self.navigationController popViewControllerAnimated:TRUE];
}

- (NSArray *)fetchItems {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Memories" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    return [_managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

#pragma mark - Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _managedObjectContext = _appDelegate.managedObjectContext;
    [self tempAddRecords];
    _memoryArray = [self fetchItems];
    //[self deleteObject];
//    for (Memories *memory in _memoryArray) {
//        NSLog(@"%@ %@",[memory dateEntered], [memory memoryNote]);
//    }
    //Initialize SLider Values
    _timeLineSlider.maximumValue = _memoryArray.count - 1;
    _timeLineSlider.minimumValue = 0;
    _timeLineSlider.value = _memoryArray.count - 1;
    _noteTextView.text = [_memoryArray[(int)_timeLineSlider.value] memoryNote];
    //Initialize Date Values
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"EEEE MMM d"];
    _currentMemory = _memoryArray[(int)_timeLineSlider.value];
    _dateLabel.text = [formatter stringFromDate:[_currentMemory memoryDate]];
    //Text Field Change Listener
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextFieldTextDidChangeNotification object:_noteTextView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
