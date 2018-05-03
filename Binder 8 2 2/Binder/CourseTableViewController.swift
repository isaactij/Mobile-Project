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
        let courseNames = loadCourseTableView()

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath)
        let myCourseList = loadCourseTableView()
        
        // Configure the cell...
        let course = myCourseList[indexPath.row]
        cell.textLabel?.text = course
        cell.detailTextLabel?.text = String(0)

        return cell
    }
    
    
    func loadCourseTableView() -> [String] {
        // Initialize return array
        var returnArray:[String] = []
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
                        returnArray.append(course.courseName)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
