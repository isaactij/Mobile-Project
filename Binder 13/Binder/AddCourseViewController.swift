//
//  AddCourseViewController.swift
//  Binder
//
//  Created by Christina Depena on 3/31/18.
//  Copyright © 2018 The University of Texas at Austin. All rights reserved.
//

import UIKit

class AddCourseViewController: UIViewController, UITextFieldDelegate {
    // Connect the UI elements
    @IBOutlet weak var courseNameField: UITextField!
    @IBOutlet weak var courseAbbrField: UITextField!
    
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var courseAbbrLabel: UILabel!
    
    
    @IBOutlet weak var showGradeBreakdownButton: UIButton!
    @IBOutlet weak var addGradeBreakdownButton: UIButton!
    
    @IBOutlet weak var saveCourseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.hidesBackButton = true
        // Set text field delegates in preparation for keyboard dismissal
        self.courseNameField.delegate = self
        self.courseAbbrField.delegate = self
        
        
       checkBackgroundColorAndFontSize()

        
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
       checkBackgroundColorAndFontSize()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Hide the keyboard when user presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return(true)
    }
    
    // Hide the keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func saveCourseBtn(_ sender: Any) {
       
        // Guard for empty fields and trigger an alert controller if fields are empty
        if((courseNameField.text == "") || (courseAbbrField.text == "")) {
            let alert = UIAlertController(title: "Error",
                                          message: "You must enter all course details",
                                          preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK",
                                         style: .default) { (action: UIAlertAction!) -> Void in
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        } else {
            // Handle the case if this the first user
            if DataStore.shared.countOfCourses() == 0 {
                // Add the course and the peopleInCourses
                let newCourse = Courses(courseName: courseNameField.text!, courseAbbreviation: courseAbbrField.text!, courseID: 0, firebaseRandomID: "")
                DataStore.shared.addCourse(course: newCourse)
                // Add the person to PeopleInCourses
                let personInCourseObject = PeopleInCourses(courseID: newCourse.courseID, personID: DataStore.shared.getIndexOfUserLoggedIn(), pk: 0, firebaseRandomID: "")
                DataStore.shared.addPeopleInCourse(peopleInCourse: personInCourseObject)
                let alert = UIAlertController(title: "Success",
                                              message: "Course saved!",
                                              preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK",
                                             style: .default) { (action: UIAlertAction!) -> Void in
                }
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
                return
            }
            // If the user's input is correct, then begin to check if course exists, if the user is already enrolled in the course
            var doesCourseExist:Bool = false
            var isPersonEnrolled:Bool = false
            let courseCount = DataStore.shared.countOfCourses()
            var existingCourse:Courses = Courses(courseName: "", courseAbbreviation: "", courseID: 0, firebaseRandomID: "")
            for i in (0...courseCount - 1){
                let currentCourse = DataStore.shared.getCourse(index: i)
                if currentCourse.courseName == courseNameField.text{
                    doesCourseExist = true
                    existingCourse = DataStore.shared.getCourse(index: i)
                    
                }
            }
            // Now check if the person is enrolled in a course that already exists
            
            let peopleInCoursesCount = DataStore.shared.countOfPeopleInCourses()
            let currentUserID = DataStore.shared.getIndexOfUserLoggedIn()
            
            if doesCourseExist == true {
                for i in 0...(peopleInCoursesCount - 1) {
                    let personInCourseObject = DataStore.shared.getPeopleInCourses(index: i)
                    if personInCourseObject.courseID == existingCourse.courseID && personInCourseObject.personID == currentUserID {
                        isPersonEnrolled = true
                        
                        // This means that the course exists and the person is already enrolled so throw an error
                        let alert = UIAlertController(title: "Error",
                                                      message: "You are already enrolled in this course!",
                                                      preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK",
                                                     style: .default) { (action: UIAlertAction!) -> Void in
                        }
                        alert.addAction(okAction)
                        present(alert, animated: true, completion: nil)
                        return
                    }
                }
            }
            // Add the user to peopleInCourses if they aren't enrolled
            if doesCourseExist == true && isPersonEnrolled == false {
                let newPeopleInCoursesCount = peopleInCoursesCount + 1
                let personInCourseObject = PeopleInCourses(courseID: existingCourse.courseID, personID: currentUserID, pk: newPeopleInCoursesCount - 1, firebaseRandomID: "")
                DataStore.shared.addPeopleInCourse(peopleInCourse: personInCourseObject)
                return
            }
            if doesCourseExist == false && isPersonEnrolled == false{
                // Add the course and the peopleInCourses
                let newCourseCount = courseCount + 1
                let newCourse = Courses(courseName: courseNameField.text!, courseAbbreviation: courseAbbrField.text!, courseID: newCourseCount - 1, firebaseRandomID: "")
                DataStore.shared.addCourse(course: newCourse)
                // Add the person to PeopleInCourses
                let newPeopleInCoursesCount = peopleInCoursesCount + 1
                let personInCourseObject = PeopleInCourses(courseID: newCourse.courseID, personID: currentUserID, pk: newPeopleInCoursesCount - 1, firebaseRandomID: "")
                DataStore.shared.addPeopleInCourse(peopleInCourse: personInCourseObject)
                let alert = UIAlertController(title: "Success",
                                              message: "Course saved!",
                                              preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK",
                                             style: .default) { (action: UIAlertAction!) -> Void in
                }
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
                return
            }
        }
    }
    // MARK: - Navigation
    
    //
    //   PREPARE FOR SEGUE
    //
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //if the segue is to the CreateAssignmentTypeViewController
        if let theDestinationVC = segue.destination as? CreateAssignmentTypeViewController {
            
          //just segue to the VC, nothing to prepare
        }
        
        
        //if the segue is to the assignmentCategoryTableVC
        if let theDestinationVC = segue.destination as? AssignmentCategoryTableViewController {
            
            
            if (courseNameField.text != "") {
                //TO DO:
                //check to see if this course actually exists for this user if not then show an error message
                if (courseExistsForThisUser()) {
                    
                    var peopleInCoursesID:Int? = nil
                    //pass in the correct peopleInCoursesID
                    peopleInCoursesID = getThePeopleInCoursesID()
                    theDestinationVC.peopleInCoursesID = peopleInCoursesID
                    
                } else {
                    
                    let alert = UIAlertController(title: "Error",
                                                  message: "You are not in a course with that name!",
                                                  preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK",
                                                 style: .default) { (action: UIAlertAction!) -> Void in
                    }
                    alert.addAction(okAction)
                    present(alert, animated: true, completion: nil)
                    
                }
            
            } else {
                
                let alert = UIAlertController(title: "Error",
                                              message: "Must enter course name to see its breakdown!",
                                              preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK",
                                             style: .default) { (action: UIAlertAction!) -> Void in
                }
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
                
            }
        }
        
            // Get the new view controller using segue.destinationViewController.
            // Pass the selected object to the new view controller.
    }
    
    func courseExistsForThisUser() -> Bool {
        
        var theCourseExistsForThisUser = false
        var courseIDofCourse:Int? = nil
        
        //see if course exists and get get ID of that course
        let countOfCourses = DataStore.shared.countOfCourses()
        if (countOfCourses > 0) {
            for i in 0...countOfCourses-1 {
                let course = DataStore.shared.getCourse(index: i)
                if (course.courseName == courseNameField.text) {
                   
                    courseIDofCourse = course.courseID
                }
            }
        } else {
            return theCourseExistsForThisUser
        }
        
        //get the ID of the user logged in
        let idOfUserLoggedIn = DataStore.shared.getIndexOfUserLoggedIn()
        
        //go through peopleInCourses and see if any entry has the "idOfUserLoggedIn" and "courseIDofCourse"
        let countOfPeopleInCourses = DataStore.shared.countOfPeopleInCourses()
        if (countOfPeopleInCourses > 0) {
            for i in 0...countOfPeopleInCourses-1 {
                let peopleInCourse = DataStore.shared.getPeopleInCourses(index: i)
                if (peopleInCourse.personID == idOfUserLoggedIn && peopleInCourse.courseID == courseIDofCourse) {
                    
                    theCourseExistsForThisUser = true
                }
            }
        }
        
        return theCourseExistsForThisUser
        
        
    
        
        
        
    }
    
    func getThePeopleInCoursesID() -> Int {
        
        var thePeopleInCoursesIDToReturn:Int? = nil
        
        //the courseID of the course specified in the text field
        var courseIDofCourse:Int? = nil
        
        //see if course exists and get get ID of that course
        let countOfCourses = DataStore.shared.countOfCourses()
        if (countOfCourses > 0) {
            for i in 0...countOfCourses-1 {
                let course = DataStore.shared.getCourse(index: i)
                if (course.courseName == courseNameField.text) {
                    
                    courseIDofCourse = course.courseID
                }
            }
        }
        
        
        //get the ID of the user logged in
        let idOfUserLoggedIn = DataStore.shared.getIndexOfUserLoggedIn()
        
        //go through peopleInCourses and see if any entry has the "idOfUserLoggedIn" and "courseIDofCourse"
        let countOfPeopleInCourses = DataStore.shared.countOfPeopleInCourses()
        if (countOfPeopleInCourses > 0) {
            for i in 0...countOfPeopleInCourses-1 {
                let peopleInCourse = DataStore.shared.getPeopleInCourses(index: i)
                if (peopleInCourse.personID == idOfUserLoggedIn && peopleInCourse.courseID == courseIDofCourse) {
                    
                   thePeopleInCoursesIDToReturn = peopleInCourse.pk
                }
            }
        }
        
        
        return thePeopleInCoursesIDToReturn!
        
        
        
    }
    
    func checkBackgroundColorAndFontSize() {
        
        //setting the background color and font sizes of this
        //VC based on user default settings
        //see the SettingsViewController and also Config
        //classes for more info
        
        
        if DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).backgroundColor == "blue" {
            self.view.backgroundColor = UIColor.cyan
        } else {
            self.view.backgroundColor = UIColor.white
        }
        
        //set font sizes
        if DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).fontSize == "small" {
            
            saveCourseButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            addGradeBreakdownButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            showGradeBreakdownButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            
            courseAbbrLabel.font = UIFont.systemFont(ofSize: 15.0)
            courseNameLabel.font = UIFont.systemFont(ofSize: 15.0)
            
            courseNameField.font = UIFont.systemFont(ofSize: 15.0)
            courseAbbrField.font = UIFont.systemFont(ofSize: 15.0)
            
            
            
        } else {
            saveCourseButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            addGradeBreakdownButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            showGradeBreakdownButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            
            courseAbbrLabel.font = UIFont.systemFont(ofSize: 20.0)
            courseNameLabel.font = UIFont.systemFont(ofSize: 20.0)
            
            courseNameField.font = UIFont.systemFont(ofSize: 20.0)
            courseAbbrField.font = UIFont.systemFont(ofSize: 20.0)
            
        }
        
        
    }
    

}
 

