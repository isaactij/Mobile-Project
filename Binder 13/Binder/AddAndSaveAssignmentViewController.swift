//
//  AddAndSaveAssignmentViewController.swift
//  Binder
//
//  Created by Brandon Kerbow on 4/22/18.
//  Copyright © 2018 The University of Texas at Austin. All rights reserved.
//

import UIKit

class AddAndSaveAssignmentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // Returns the number of columns for the picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Returns the number of rows for the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // Fills the picker with the information from the pickerData array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Captures the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerSelection = pickerData[row]
        //let yourSelection = pickerView.selectedRow(inComponent: 0)
        //var view = self.pickerView(pickerView, didSelectRow, inComponent, nil)
        //var selectedValue = pickerData[pickerView.selectedRow(inComponent: 0)]
    }
    
    // This variable will populated
    var pickerData: [String] = [String]()
    var pickerCategories: [CourseCategoryBreakdown]?
    
    // This variable is passed in from the TableVC for Assignments
    var selectedCourse: Courses?
    let currentUserID = DataStore.shared.getIndexOfUserLoggedIn()
    var pickerSelection: String?
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var gradeTextField: UITextField!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    @IBOutlet weak var percentOfFinalGradeTextLabel: UILabel!
    @IBOutlet weak var percentOfFinalGradeActualNumberLabel: UILabel!
    
    @IBOutlet weak var classAverageTextLabel: UILabel!
    @IBOutlet weak var classAverageActualNumberLabel: UILabel!
    
    
    @IBOutlet weak var addOrSaveCourseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkBackgroundColorAndFontSize()
        
        // Do any additional setup after loading the view.
        
        // Connect the data
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
        
        // Set text field delegates in preparation for keyboard dismissal
        self.descriptionTextField.delegate = self
        self.gradeTextField.delegate = self
        
        // Initialize the picker data here with a function later. i.e. assign the pickerData array to a function that returns an array
        pickerCategories = loadCategories()
        for i in (0...(pickerCategories?.count)! - 1) {
            pickerData.append(pickerCategories![i].category)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        checkBackgroundColorAndFontSize()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
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
    
    @IBAction func addSaveBtn(_ sender: Any) {
        var assignmentDupeForUser:Bool = false
        // If the fields are empty, then throw an alert controller
        if ((descriptionTextField.text == "") || (gradeTextField.text == "")) {
            let alert = UIAlertController(title: "Error",
                                          message: "You must enter all assignment details",
                                          preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK",
                                         style: .default){ (action: UIAlertAction!) -> Void in
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        } else {
            // Process the entered data
            let yourAssignments = retrieveAssignments(course: selectedCourse!, person: currentUserID)
            // If the above array is empty add the new assignment
            if yourAssignments.count == 0 {
                // Add the new assignment
                let selectedCategoryString:String = pickerSelection!
                var selectedCategory:CourseCategoryBreakdown = CourseCategoryBreakdown(pk: 0, peopleInCoursesID: 0, percentOfFinalGradeOfCategory: 0, category: "", firebaseRandomID: "")
                for i in (0...(pickerCategories?.count)! - 1){
                    let currentCategoryObject = pickerCategories![i]
                    if selectedCategoryString == currentCategoryObject.category{
                        selectedCategory = currentCategoryObject
                    }
                }
                let newAssignmentCount = DataStore.shared.countOfAssignments() + 1

                if !(gradeEntryIsCorrect(gradeEntry: gradeTextField.text!)){
                    let alert = UIAlertController(title: "Error",
                                                  message: "Grades need to be entered as Floats or Ints",
                                                  preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK",
                                                 style: .default){ (action: UIAlertAction!) -> Void in
                    }
                    alert.addAction(okAction)
                    present(alert, animated: true, completion: nil)
                    return
                }
                
                let newAssignment: Assignments = Assignments(assignmentType: selectedCategory.category, courseID: (selectedCourse?.courseID)!, percentOfGrade: Int(selectedCategory.percentOfFinalGradeOfCategory), assignmentGrade: Int(gradeTextField.text!)!, personID: currentUserID, pk: newAssignmentCount - 1, assignmentTitle: descriptionTextField.text!, firebaseRandomID: "")
                DataStore.shared.addAssignment(assignment: newAssignment)
                
                
                let alert = UIAlertController(title: "Success",
                                              message: "Assignment Added",
                                              preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK",
                                             style: .default){ (action: UIAlertAction!) -> Void in
                }
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
                return
                
                
                
                //this is where the assigment fgot added to firebase right?
                
            } else {
                // Handle the case the the entered assignment is a duplicate
                let selectedCategoryString:String = pickerSelection!
                for i in (0...yourAssignments.count - 1){
                    let currentAssignment = yourAssignments[i]
                    if descriptionTextField.text == currentAssignment.assignmentTitle && selectedCategoryString == currentAssignment.assignmentType{
                        assignmentDupeForUser = true
                        let alert = UIAlertController(title: "Error",
                                                      message: "You have already registered this assignment",
                                                      preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK",
                                                     style: .default){ (action: UIAlertAction!) -> Void in
                        }
                        alert.addAction(okAction)
                        present(alert, animated: true, completion: nil)
                        return
                    }
                }
                // Add the new assignment if it does not exist already
                if assignmentDupeForUser == false{
                    //Add assignment
                    let selectedCategoryString:String = pickerSelection!
                    var selectedCategory:CourseCategoryBreakdown = CourseCategoryBreakdown(pk: 0, peopleInCoursesID: 0, percentOfFinalGradeOfCategory: 0, category: "", firebaseRandomID: "")
                    for i in (0...(pickerCategories?.count)! - 1){
                        let currentCategoryObject = pickerCategories![i]
                        if selectedCategoryString == currentCategoryObject.category{
                            selectedCategory = currentCategoryObject
                        }
                    }
                    let newAssignmentCount = DataStore.shared.countOfAssignments() + 1
                    
                    if !(gradeEntryIsCorrect(gradeEntry: gradeTextField.text!)){
                        let alert = UIAlertController(title: "Error",
                                                      message: "Grades need to be entered as Floats or Ints",
                                                      preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK",
                                                     style: .default){ (action: UIAlertAction!) -> Void in
                        }
                        alert.addAction(okAction)
                        present(alert, animated: true, completion: nil)
                        return
                    }
                    

                    let newAssignment: Assignments = Assignments(assignmentType: selectedCategory.category, courseID: (selectedCourse?.courseID)!, percentOfGrade: Int(selectedCategory.percentOfFinalGradeOfCategory), assignmentGrade: Int(gradeTextField.text!)!, personID: currentUserID, pk: newAssignmentCount - 1, assignmentTitle: descriptionTextField.text!, firebaseRandomID: "")
                    DataStore.shared.addAssignment(assignment: newAssignment)
                }
            }
        }
    }
    // Retrieves Assignment for this user for this particular course
    func retrieveAssignments(course:Courses, person:Int) -> [Assignments] {
        var returnArray: [Assignments] = []
        // Handle the case the case for a newly enrolled user in a class/the very first user
        // Get a count of total assignments
        let assignmentCount = DataStore.shared.countOfAssignments()
        if assignmentCount == 0 {
            return returnArray
        }
        // Loop through to try and add assignments that match the course and the user
        for i in (0...assignmentCount - 1){
            let assignment = DataStore.shared.getAssignment(index: i)
            if assignment.courseID == course.courseID && assignment.personID == person{
                returnArray.append(assignment)
            }
        }
        return returnArray
    }
    
    func loadCategories() -> [CourseCategoryBreakdown]{
        let catCount = DataStore.shared.countOfCourseCategoryBreakdowns()
        // Handle the case that this is the first user and they did not add any categories
        let peopleInCoursesCount = DataStore.shared.countOfPeopleInCourses()
        var peopleInCoursesIDList:[Int] = []
        var returnArray:[CourseCategoryBreakdown] = []
        
        // Obtain the appropriate pks
        for i in (0...peopleInCoursesCount - 1){
            let peopleInCoursesObject = DataStore.shared.getPeopleInCourses(index: i)
            if selectedCourse?.courseID == peopleInCoursesObject.courseID && currentUserID == peopleInCoursesObject.personID{
                peopleInCoursesIDList.append(peopleInCoursesObject.pk)
            }
        }
        
        // See if there are any matching current categories
        for i in (0...peopleInCoursesIDList.count - 1){
            for j in (0...catCount - 1){
                let currentCat = DataStore.shared.getCourseCategoryBreakdown(index: j)
                if peopleInCoursesIDList[i] == currentCat.peopleInCoursesID{
                    returnArray.append(currentCat)
                }
            }
        }
        return returnArray
    }
    
    func gradeEntryIsCorrect(gradeEntry:String) -> Bool {
        //return true only if all of the fields are not empty , and also the percent field must be an int or float
        
        var GradeEntryIsAnInt = false
        var GradeEntryIsAFloat = false
        var GradeEntryIsAnIntOrFloat = false
        
        
        if  Int(gradeTextField.text!) != nil {
            GradeEntryIsAnInt = true
        }
        
        if  Float(gradeTextField.text!) != nil {
            GradeEntryIsAFloat = true
        }
        
        GradeEntryIsAnIntOrFloat = GradeEntryIsAnInt || GradeEntryIsAFloat
        
        return GradeEntryIsAnIntOrFloat
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func checkBackgroundColorAndFontSize() {
        
        if DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).backgroundColor == "blue" {
            self.view.backgroundColor = UIColor.cyan
        } else {
            self.view.backgroundColor = UIColor.white
        }
        
        //set font sizes
        if DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).fontSize == "small" {
            
            descriptionTextField.font = UIFont.systemFont(ofSize: 15.0)
            gradeTextField.font = UIFont.systemFont(ofSize: 15.0)
            
            descriptionLabel.font = UIFont.systemFont(ofSize: 15.0)
            gradeLabel.font = UIFont.systemFont(ofSize: 15.0)
            categoryLabel.font = UIFont.systemFont(ofSize: 15.0)
            percentOfFinalGradeTextLabel.font = UIFont.systemFont(ofSize: 15.0)
            percentOfFinalGradeActualNumberLabel.font = UIFont.systemFont(ofSize: 15.0)
            classAverageTextLabel.font = UIFont.systemFont(ofSize: 15.0)
            classAverageActualNumberLabel.font = UIFont.systemFont(ofSize: 15.0)
            
            //addOrSaveCourseButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
            
        } else {
            descriptionTextField.font = UIFont.systemFont(ofSize: 20.0)
            gradeTextField.font = UIFont.systemFont(ofSize: 20.0)
            
            descriptionLabel.font = UIFont.systemFont(ofSize: 20.0)
            gradeLabel.font = UIFont.systemFont(ofSize: 20.0)
            categoryLabel.font = UIFont.systemFont(ofSize: 20.0)
            percentOfFinalGradeTextLabel.font = UIFont.systemFont(ofSize: 20.0)
            percentOfFinalGradeActualNumberLabel.font = UIFont.systemFont(ofSize: 20.0)
            classAverageTextLabel.font = UIFont.systemFont(ofSize: 20.0)
            classAverageActualNumberLabel.font = UIFont.systemFont(ofSize: 20.0)
            
            //addOrSaveCourseButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            
        }
    }
    
}

