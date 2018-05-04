//
//  AssignmentTableViewController.swift
//  Binder
//
//  Created by Brandon Kerbow on 4/22/18.
//  Copyright © 2018 The University of Texas at Austin. All rights reserved.
//

import UIKit

class AssignmentTableViewController: UITableViewController {
    // This will be initialized based off the what the user selects in the Course Table VC
    var selectedCourse: Courses?
    
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
        return retrieveAssignments(course: selectedCourse!, person: DataStore.shared.getIndexOfUserLoggedIn()).count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignmentCell", for: indexPath)
        let myAssignments = retrieveAssignments(course: selectedCourse!, person: DataStore.shared.getIndexOfUserLoggedIn())
        // Configure the cell...
        // Configure the cell...
        let assignment = myAssignments[indexPath.row]
        cell.textLabel?.text = assignment.assignmentTitle
        cell.detailTextLabel?.text = String(assignment.assignmentGrade)

        return cell
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
    @IBAction func addAssign(_ sender: Any) {
        if shouldPerformSegue(withIdentifier: "AtoB", sender: Any?.self){
            performSegue(withIdentifier: "AtoB", sender: Any?.self)
        } else {
            // Throw alert controllers
            let alert = UIAlertController(title: "Error",
                                          message: "You must enter all assignment types",
                                          preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK",
                                         style: .default){ (action: UIAlertAction!) -> Void in
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destinationVC = segue.destination as? AddAndSaveAssignmentViewController{
            destinationVC.selectedCourse = self.selectedCourse
        }
    }
    
    override func shouldPerformSegue(withIdentifier: String, sender: Any!) -> Bool {
        let catCount = loadCategoriesCount()
        return (DataStore.shared.countOfCourseCategoryBreakdowns() != 0 || catCount != 0)
    }
    
    func loadCategoriesCount() -> Int {
        let catCount = DataStore.shared.countOfCourseCategoryBreakdowns()
        if catCount == 0 {
            return catCount
        }
        // Handle the case that this is the first user and they did not add any categories
        let peopleInCoursesCount = DataStore.shared.countOfPeopleInCourses()
        let currentUserID = DataStore.shared.getIndexOfUserLoggedIn()
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
        return returnArray.count
    }
    
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

}
