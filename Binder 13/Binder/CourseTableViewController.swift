//
//  CourseTableViewController.swift
//  Binder
//
//  Created by Christina Depena on 4/15/18.
//  Copyright © 2018 The University of Texas at Austin. All rights reserved.
//

import UIKit

class CourseTableViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return loadCourseTableView().count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = DataStore.shared.getIndexOfUserLoggedIn()
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath)
        let myCourseList = loadCourseTableView()
        
        // Configure the cell...
        let course = myCourseList[indexPath.row]
        cell.textLabel?.text = course.courseName
        let grade = calculateCourseGrade(course: myCourseList[indexPath.row], person: person)
        cell.detailTextLabel?.text = String(grade)

        return cell
    }
    
    
    func loadCourseTableView() -> [Courses] {
        // Initialize return array
        var returnArray:[Courses] = []
        // Obtain the user first
        let currentUser = DataStore.shared.getIndexOfUserLoggedIn()
        
        // Initialize two booleans
        var areThereCourses:Bool = true
        var firstTimeUser:Bool = false
        
        // Check to see if there are any courses at all
        let courseCount = DataStore.shared.countOfCourses()
        if courseCount == 0 {
            areThereCourses = false
            return returnArray
        }
        
        // Check to see if the user is enrolled in any courses
        let peopleInCoursesCount = DataStore.shared.countOfPeopleInCourses()
        var userCourseIDs:[Int] = []
        for i in 0...(peopleInCoursesCount - 1){
            let peopleInCoursesObject = DataStore.shared.getPeopleInCourses(index: i)
            if peopleInCoursesObject.personID == currentUser {
               userCourseIDs.append(peopleInCoursesObject.courseID)
            }
        }

        if userCourseIDs.count == 0 {
            firstTimeUser = true
            return returnArray
        }
        // Now populate userCourse Names list which is the returnArray
        if firstTimeUser == false && areThereCourses == true {
            for i in 0...(userCourseIDs.count - 1){
                for j in (0...courseCount - 1){
                    let course = DataStore.shared.getCourse(index: j)
                    if userCourseIDs[i] == course.courseID{
                        returnArray.append(course)
                    }
                }
            }
        }
    return returnArray
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
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
    
    func calculateCourseGrade(course: Courses, person:Int) -> Float {
        // Count the number of categories in a course
        let catCount = DataStore.shared.countOfCourseCategoryBreakdowns()
        
        // Handle the case that this is the first user and they did not add any categories
        if catCount == 0{
            return 0
        }
        let peopleInCoursesCount = DataStore.shared.countOfPeopleInCourses()
        var peopleInCoursesIDList:[Int] = []
        var courseCats:[CourseCategoryBreakdown] = []
        
        // Obtain the appropriate pks
        for i in (0...peopleInCoursesCount - 1){
            let peopleInCoursesObject = DataStore.shared.getPeopleInCourses(index: i)
            if course.courseID == peopleInCoursesObject.courseID && person == peopleInCoursesObject.personID{
                peopleInCoursesIDList.append(peopleInCoursesObject.pk)
            }
        }
        
        // See if there are any matching current categories
        for i in (0...peopleInCoursesIDList.count - 1){
            for j in (0...catCount - 1){
                let currentCat = DataStore.shared.getCourseCategoryBreakdown(index: j)
                if peopleInCoursesIDList[i] == currentCat.peopleInCoursesID{
                    courseCats.append(currentCat)
                }
            }
        }
        
        // Handle the case that the user has not added categories for the course yet
        if courseCats.count == 0 {
            return 0
        }
        
        // Pull the assignments for that user/that course
        let yourAssignments = retrieveAssignments(course: course, person: person)
        
        // Handle the case that the user has not added assignments for the course
        if yourAssignments.count == 0{
            return 0
        }
        
        // Otherwise begin grade calculation
        var finalGrade: Float = 0
        var percentageDenom: Float = 0
        for i in (0...courseCats.count - 1){
            var assignmentGradeByType:Float = 0
            var countOfAssignmentsByType:Float = 0
            percentageDenom += Float(courseCats[i].percentOfFinalGradeOfCategory)
            for j in (0...yourAssignments.count - 1){
                if courseCats[i].category == yourAssignments[j].assignmentType{
                    countOfAssignmentsByType += 1
                    assignmentGradeByType += Float(yourAssignments[j].assignmentGrade)
                }
            }
            if countOfAssignmentsByType == 0 {
                percentageDenom -= Float(courseCats[i].percentOfFinalGradeOfCategory)
            }
            if percentageDenom == 0 {
                continue
            } else {
                assignmentGradeByType = Float(assignmentGradeByType/countOfAssignmentsByType)
                finalGrade += Float(assignmentGradeByType) * (courseCats[i].percentOfFinalGradeOfCategory/100)
            }
        }
        finalGrade = finalGrade/percentageDenom * (100)
        return finalGrade
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        // Reload the courselist and pass the course to the Assignment Table VC
        let myCourseList = loadCourseTableView()
        if let destinationVC = segue.destination as? AssignmentTableViewController,
            let selectedIndexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCourse = myCourseList[selectedIndexPath.row]
            print(destinationVC.selectedCourse!.courseAbbreviation)
        }
        

    
}
}
