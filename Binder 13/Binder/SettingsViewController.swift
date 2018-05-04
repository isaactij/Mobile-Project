//
//  SettingsViewController.swift
//  Binder
//
//  Created by Brandon Kerbow on 3/25/18.
//  Copyright © 2018 The University of Texas at Austin. All rights reserved.
//

import UIKit
import CoreData
import EventKit

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var updatePasswordButton: UIButton!
    @IBOutlet weak var backgroundColorSegmentedControl: UISegmentedControl!
    @IBOutlet weak var fontSizeSegmentedControl: UISegmentedControl!
    var personLoggedIn = [NSManagedObject]()
    @IBOutlet weak var backgroundColorText: UILabel!
    @IBOutlet weak var fontSizeText: UILabel!
    let eventStore = EKEventStore()
    var sentPersonID = -1
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
         self.navigationItem.hidesBackButton = true
        checkPerson()
        checkBackgroundColorAndFontSize()
        
        
       

        // Do any additional setup after loading the view.
    }
    
    func checkPerson(){
        let count = DataStore.shared.countOfPeople()
        
        if count > 0 { //because if no accounts are present then this would return an index error
            //if no accounts are present then any credentials typed in will be wrong
            //print("sdfhsdfsdjkfhsjkdhfsdjkfhsdjkf")
            //print(count)
            for i in 0...count-1{
                let person = DataStore.shared.getPerson(index: i)
                if person.personID == sentPersonID {
                    DataStore.shared.setIndexOfUserLoggedIn(_setValue: i) //this is the user logged in
                }
                
            }
        }
    }
    
    
    @IBAction func logOutPressed(_ sender: Any) {
        clearDataModel()
        deleteCalendar()
        performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
    
    func clearDataModel(){
        //Opens connection to core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        //Gets the info stored in core data
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"PersonLoggedIn")
        var fetchedResults:[NSManagedObject]? = nil
        do{
            try fetchedResults = managedContext.fetch(fetchRequest) as? [NSManagedObject]
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        if let results = fetchedResults {
            personLoggedIn = results
        } else{
            print("Could not fetch")
        }
        if personLoggedIn.count > 0 {
            personLoggedIn[0].setValue(-1, forKey:"personID")
        }
    }
    
    func deleteCalendar(){
        let calendarIdentifier = UserDefaults.standard.string(forKey: "Binder")
        let calendar = eventStore.calendar(withIdentifier: calendarIdentifier!)
        if(calendar != nil) {
            do{
                try eventStore.removeCalendar(calendar!, commit:true)
                //                let alert = UIAlertController(title: "Calendar Deleted", message: "Calendar was successfully deleted", preferredStyle: .alert)
                //                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                //                alert.addAction(OKAction)
                //
                //                self.present(alert, animated: true, completion: nil)
            }catch let error {
                print(error)
                //                let alert = UIAlertController(title: "Calendar Delete Error", message: "Calendar could not be deleted", preferredStyle: .alert)
                //                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                //                alert.addAction(OKAction)
                //
                //                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
       checkBackgroundColorAndFontSize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func updatePasswordButtonPressed(_ sender: Any) {
        
    }
    
    
    @IBAction func backgrondColorSegmentedControlPressed(_ sender: Any) {
        
        let theStringWithinTheSegmentedControlThatIsCurrentlySelected = backgroundColorSegmentedControl.titleForSegment(at: backgroundColorSegmentedControl.selectedSegmentIndex)!
        
        if theStringWithinTheSegmentedControlThatIsCurrentlySelected == "Blue" {
            //when the user selects blue on the segmented control, alter
            //their user defaults to be a blue background color
         
            //print(DataStore.shared.getIndexOfUserLoggedIn())
            DataStore.shared.updatePerson(
                                          person: (DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn())),
                                        
                                          newPassword: DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).password,
                                          newBackgroundColor: "blue",
                                          newFontSize: DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).fontSize
                                            )
            
        } else {
            //the other segmented control option is white
           
            DataStore.shared.updatePerson(
                person: (DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn())),
                newPassword: DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).password,
                newBackgroundColor: "white",
                newFontSize: DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).fontSize
            )
        }
        
        //once the color value is set in core data, update this VC's color
        if DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).backgroundColor == "blue" {
            self.view.backgroundColor = UIColor.cyan
        } else {
            self.view.backgroundColor = UIColor.white
        }
    }
    
    //same idea for setting the font size
    @IBAction func fontSizeSegmentedControlPressed(_ sender: Any) {
        
        let theStringWithinTheSegmentedControlThatIsCurrentlySelected = fontSizeSegmentedControl.titleForSegment(at: fontSizeSegmentedControl.selectedSegmentIndex)!
        
        if theStringWithinTheSegmentedControlThatIsCurrentlySelected == "small" {
           //if the user picks small font then set everything to size 15
            //in this VC and save their user default setting as small
            
            DataStore.shared.updatePerson(
                person: (DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn())),
                newPassword: DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).password,
                newBackgroundColor: DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).backgroundColor,
                newFontSize: "small"
            )
            
            
            updatePasswordButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            backgroundColorText.font = UIFont.systemFont(ofSize: 15.0)
            fontSizeText.font = UIFont.systemFont(ofSize: 15.0)
    
            
        } else {
            //the other option on the segmented control is large font
            DataStore.shared.updatePerson(
                person: (DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn())),
                newPassword: DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).password,
                newBackgroundColor: DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).backgroundColor,
                newFontSize: "large"
            )
            
            updatePasswordButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            backgroundColorText.font = UIFont.systemFont(ofSize: 20.0)
            fontSizeText.font = UIFont.systemFont(ofSize: 20.0)
          
        }
        
    }
    
    func checkBackgroundColorAndFontSize() {
        
        //set background color based on user defaults
        if DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).backgroundColor  == "blue" {
            self.view.backgroundColor = UIColor.cyan
            backgroundColorSegmentedControl.selectedSegmentIndex = 0
        } else {
            self.view.backgroundColor = UIColor.white
            backgroundColorSegmentedControl.selectedSegmentIndex = 1
        }
        
        
        //set font sizes based on user defaults
        if  DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).fontSize == "small" {
            updatePasswordButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            backgroundColorText.font = UIFont.systemFont(ofSize: 15.0)
            fontSizeText.font = UIFont.systemFont(ofSize: 15.0)
            fontSizeSegmentedControl.selectedSegmentIndex = 0
        } else {
            updatePasswordButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
            backgroundColorText.font = UIFont.systemFont(ofSize: 20.0)
            fontSizeText.font = UIFont.systemFont(ofSize: 20.0)
            fontSizeSegmentedControl.selectedSegmentIndex = 1
        }
        
    }

        
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToLogin" {
            if let destination = segue.destination as? TabBarController {
                destination.unwind = true
            }
        }
    }
}

