//
//  CreateAssignmentTypeViewController.swift
//  Binder
//
//  Created by Brandon Kerbow on 4/24/18.
//  Copyright © 2018 The University of Texas at Austin. All rights reserved.
//

import UIKit

class CreateAssignmentTypeViewController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var assignmentTypeLabel: UILabel!
    @IBOutlet weak var percentOfTotalFinalGradeLabel: UILabel!
    
    @IBOutlet weak var courseNameTextFieldEntry: UITextField!
    @IBOutlet weak var assignmentTypeTextFieldEntry: UITextField!
    @IBOutlet weak var percentOfTotalFinalGradeTextFieldEntry: UITextField!
    
    @IBOutlet weak var saveAssignmentTypeButton: UIButton!
    
    @IBOutlet weak var assignmentTypeSavedMessageLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Set text field delegates in preparation for keyboard dismissal
        self.courseNameTextFieldEntry.delegate = self
        self.assignmentTypeTextFieldEntry.delegate = self
        self.percentOfTotalFinalGradeTextFieldEntry.delegate = self
        
        checkBackgroundColorAndFontSize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //also want to set these user defaults every time the view loads
        
        //set the background color and make sure the segmenetd control is on the right spot
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    
    
    @IBAction func saveAssignmentTypeButtonPressed(_ sender: Any) {
        
        if (allFieldsFilledAndOfCorrectType()) {
            
            if(theCourseActuallyExistsForThisUser()) {
                
                if(theCategoryIsANewCatrgoryForThisCourse()) {
                    
                    
                    saveToFireBaseAsNewCategory()
                    
                } else {
                    
                    updateFirebaseInfoForThisCategory()
                    //still save it to firebase but use an update instead
                }
                
                
            } else {
                //assignmentTypeSavedMessageLabel.text = "Course not found for this user"
                let alert = UIAlertController(title: "Error",
                                              message: "Course not found for this user!",
                                              preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK",
                                             style: .default) { (action: UIAlertAction!) -> Void in
                }
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            }
            
        } else {
            //assignmentTypeSavedMessageLabel.text = "Enter all fields and ensure percent of final grade is be an int or float"
            let alert = UIAlertController(title: "Error",
                                          message: "Enter all fields. Percent of final grade must be an int or float.",
                                          preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK",
                                         style: .default) { (action: UIAlertAction!) -> Void in
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
        }
        
        //when the user clicks save assignment type
    }
    
    func allFieldsFilledAndOfCorrectType() -> Bool {
        //return true only if all of the fields are not empty , and also the percent field must be an int or float
        
        var percentOfFinalGradeEntryIsAnInt = false
        var percentOfFinalGradeEntryIsAFloat = false
        var percentOfFinalGradeEntryIsAnIntOrFloat = false
        
        
        if  Int(percentOfTotalFinalGradeTextFieldEntry.text!) != nil {
            percentOfFinalGradeEntryIsAnInt = true
        }
        
        if  Float(percentOfTotalFinalGradeTextFieldEntry.text!) != nil {
            percentOfFinalGradeEntryIsAFloat = true
        }
        
        percentOfFinalGradeEntryIsAnIntOrFloat = percentOfFinalGradeEntryIsAnInt || percentOfFinalGradeEntryIsAFloat
        
        
        return courseNameTextFieldEntry.text != "" && assignmentTypeTextFieldEntry.text != "" && percentOfTotalFinalGradeTextFieldEntry.text != "" && percentOfFinalGradeEntryIsAnIntOrFloat
    }
    
    
    
    func theCourseActuallyExistsForThisUser() -> Bool {
        
        var theCourseExists = false
        var courseIDofCourse:Int? = nil //assigned if course exists
        var userHasCourse = false
        
        //check to see if the course exists: if the course name matches any of the coursenames in the courses, and if so then assign courseIDofCourse to the courses ID
        
        let countOfCourses = DataStore.shared.countOfCourses()
        
        if (countOfCourses > 0) {
            for i in 0...countOfCourses-1 {
                let course = DataStore.shared.getCourse(index: i)
                if (course.courseName == courseNameTextFieldEntry.text) {
                    theCourseExists = true
                    courseIDofCourse = course.courseID
                }
            }
        } //else when the coursecount has 0 courses, do nothing because you dont want to change the bvooloean userHasCourse to "true"...that isnt possible if there are no courses
        
        
        
        
        //now if the course exists you have the courseID, so see if the user has the course by going through peopleInCourses objects and seeing if there is an entry where the users ID is in that courseID
        
        //the index of the user logged in should be the personID
        let personIDofUserLoggedIn = DataStore.shared.getIndexOfUserLoggedIn()
        
        let countOfPeopleInCourses = DataStore.shared.countOfPeopleInCourses()
        
        if (countOfPeopleInCourses > 0) {
            for i in 0...countOfPeopleInCourses-1 {
                let peopleInCourse = DataStore.shared.getPeopleInCourses(index: i)
                if (peopleInCourse.personID == personIDofUserLoggedIn && peopleInCourse.courseID == courseIDofCourse ) {
                    userHasCourse = true
                }
            }
        }
        
        return theCourseExists && userHasCourse
    }
    
    
    func theCategoryIsANewCatrgoryForThisCourse() -> Bool {
        
        var categoryIsNewForThisCourse = true
        
        var theCorrectPeopleInCoursesID:Int? = nil
        var theCorrectCourseID:Int? = nil
        
        let countOfCourseCategoryBreakdowns = DataStore.shared.countOfCourseCategoryBreakdowns()
        
        //determine what the correct thePeopleInCoursesIDforUserLoggedInAndCourseSpecified is
        //get the properCourseID
        let countOfCourses = DataStore.shared.countOfCourses()
        if (countOfCourses > 0) {
            for i in 0...countOfCourses-1 {
                let course = DataStore.shared.getCourse(index: i)
                
                if (course.courseName == courseNameTextFieldEntry.text) {
                    theCorrectCourseID = i
                }
            }
        }
        
        //the proper userID
        let theProperUserID = DataStore.shared.getIndexOfUserLoggedIn()
        
        //determing the theCorrectPeopleInCoursesID: the pk of the peopleInCoursesObject with the proper userID and courseID
        let countOfPeopleInCourses = DataStore.shared.countOfPeopleInCourses()
        if (countOfPeopleInCourses > 0) {
            for i in 0...countOfPeopleInCourses-1 {
                let peopleInCourse = DataStore.shared.getPeopleInCourses(index: i)
                
                if (peopleInCourse.courseID == theCorrectCourseID && peopleInCourse.personID == theProperUserID) {
                    
                    theCorrectPeopleInCoursesID = peopleInCourse.pk
                }
            }
        }
        
        if (countOfCourseCategoryBreakdowns > 0) {
            for i in 0...countOfCourseCategoryBreakdowns-1 {
                let courseCategoryBreakdown = DataStore.shared.getCourseCategoryBreakdown(index: i)
                
                if (courseCategoryBreakdown.category == assignmentTypeTextFieldEntry.text && courseCategoryBreakdown.peopleInCoursesID == theCorrectPeopleInCoursesID) {
                    categoryIsNewForThisCourse = false
                }
            }
        }
        
        return categoryIsNewForThisCourse
    }
    
    
    func saveToFireBaseAsNewCategory() {
        
        let pk = DataStore.shared.countOfCourseCategoryBreakdowns()
        
        //get the peopleInCoursesID
        var peopleInCoursesID:Int? = nil
        var courseIDofCourse:Int? = nil
        
        let countOfCourses = DataStore.shared.countOfCourses()
        if (countOfCourses > 0) {
            for i in 0...countOfCourses-1 {
                let course = DataStore.shared.getCourse(index: i)
                if (course.courseName == courseNameTextFieldEntry.text) {
                    
                    courseIDofCourse = course.courseID
                }
            }
        }
        
        //now actually assign the peopleInCourseID
        let countOfPeopleInCourses = DataStore.shared.countOfPeopleInCourses()
        if (countOfPeopleInCourses > 0) {
            for i in 0...countOfPeopleInCourses-1 {
                let peopleInCourse = DataStore.shared.getPeopleInCourses(index: i)
                
                if (peopleInCourse.courseID == courseIDofCourse && peopleInCourse.personID == DataStore.shared.getIndexOfUserLoggedIn()) {
                    
                    peopleInCoursesID = peopleInCourse.pk
                }
            }
        }
        
        
        let percentOfFinalGradeOfCategory = Float(percentOfTotalFinalGradeTextFieldEntry.text!)
        
        let category = assignmentTypeTextFieldEntry.text
        
        
        let courseCategoryBreakdown = CourseCategoryBreakdown(pk: pk, peopleInCoursesID: peopleInCoursesID!, percentOfFinalGradeOfCategory: percentOfFinalGradeOfCategory!, category: category!, firebaseRandomID: "")
        
        DataStore.shared.addCourseCategoryBreakdown(courseCategoryBreakdown: courseCategoryBreakdown)
        
        //assignmentTypeSavedMessageLabel.text = "assignment type saved!"
        let alert = UIAlertController(title: "Success",
                                      message: "Assignment type saved!",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK",
                                     style: .default) { (action: UIAlertAction!) -> Void in
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func updateFirebaseInfoForThisCategory() {
        
        var theCorrectPeopleInCoursesID:Int? = nil
        var theCorrectCourseID:Int? = nil
        var theIndexOfTheCourseCategoryBreakdownToUpdate:Int? = nil
        
        //get the properCourseID
        let countOfCourses = DataStore.shared.countOfCourses()
        if (countOfCourses > 0) {
            for i in 0...countOfCourses-1 {
                let course = DataStore.shared.getCourse(index: i)
                
                if (course.courseName == courseNameTextFieldEntry.text) {
                    theCorrectCourseID = i
                }
            }
        }
        
        //the proper userID
        let theProperUserID = DataStore.shared.getIndexOfUserLoggedIn()
        
        //determing the theCorrectPeopleInCoursesID: the pk of the peopleInCoursesObject with the proper userID and courseID
        let countOfPeopleInCourses = DataStore.shared.countOfPeopleInCourses()
        if (countOfPeopleInCourses > 0) {
            for i in 0...countOfPeopleInCourses-1 {
                let peopleInCourse = DataStore.shared.getPeopleInCourses(index: i)
                
                if (peopleInCourse.courseID == theCorrectCourseID && peopleInCourse.personID == theProperUserID) {
                    
                    theCorrectPeopleInCoursesID = peopleInCourse.pk
                }
            }
        }
        
        
        //the object in the array which has the correct peopleInCourseID and category
        let countOfCourseCategoryBreakdowns = DataStore.shared.countOfCourseCategoryBreakdowns()
        if (countOfCourseCategoryBreakdowns > 0) {
            for i in 0...countOfCourseCategoryBreakdowns-1 {
                let courseCategoryBreakdown = DataStore.shared.getCourseCategoryBreakdown(index: i)
                
                if (courseCategoryBreakdown.peopleInCoursesID == theCorrectPeopleInCoursesID && courseCategoryBreakdown.category == assignmentTypeTextFieldEntry.text) {
                    theIndexOfTheCourseCategoryBreakdownToUpdate = i
                }
            }
        }
        
        
        //we want to update this object
        let courseCategoryBreakdownToUpdate = DataStore.shared.getCourseCategoryBreakdown(index: theIndexOfTheCourseCategoryBreakdownToUpdate!)
        
        //its the same category - you're not changing that in this method
        let newCategory = courseCategoryBreakdownToUpdate.category
        
        
        DataStore.shared.updateCourseCategoryBreakdown(courseCategoryBreakdown: courseCategoryBreakdownToUpdate, newPercentOfFinalGradeOfCategory: Float(percentOfTotalFinalGradeTextFieldEntry.text!)!, newCategory: newCategory)
        
    }
    
    
    
    
    
    
    func checkBackgroundColorAndFontSize() {
        
        if DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).backgroundColor == "blue" {
            self.view.backgroundColor = UIColor.cyan
        } else {
            self.view.backgroundColor = UIColor.white
        }
        
        //set font sizes
        if DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).fontSize == "small" {
            saveAssignmentTypeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            
            courseNameLabel.font = UIFont.systemFont(ofSize: 15.0)
            assignmentTypeLabel.font = UIFont.systemFont(ofSize: 15.0)
            percentOfTotalFinalGradeLabel.font = UIFont.systemFont(ofSize: 15.0)
            assignmentTypeSavedMessageLabel.font = UIFont.systemFont(ofSize: 15.0)
            
            courseNameTextFieldEntry.font = UIFont.systemFont(ofSize: 15.0)
            assignmentTypeTextFieldEntry.font = UIFont.systemFont(ofSize: 15.0)
            percentOfTotalFinalGradeTextFieldEntry.font = UIFont.systemFont(ofSize: 15.0)
            
            
            
        } else {
            saveAssignmentTypeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            
            courseNameLabel.font = UIFont.systemFont(ofSize: 20.0)
            assignmentTypeLabel.font = UIFont.systemFont(ofSize: 20.0)
            percentOfTotalFinalGradeLabel.font = UIFont.systemFont(ofSize: 20.0)
            assignmentTypeSavedMessageLabel.font = UIFont.systemFont(ofSize: 20.0)
            
            courseNameTextFieldEntry.font = UIFont.systemFont(ofSize: 20.0)
            assignmentTypeTextFieldEntry.font = UIFont.systemFont(ofSize: 20.0)
            percentOfTotalFinalGradeTextFieldEntry.font = UIFont.systemFont(ofSize: 20.0)
            
            
        }
    }
    
}

