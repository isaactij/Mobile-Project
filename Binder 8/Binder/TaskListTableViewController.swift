//
//  TaskListTableViewController.swift
//  Binder
//
//  Created by Isaac on 4/14/18.
//  Copyright © 2018 The University of Texas at Austin. All rights reserved.
//

import UIKit

class TaskListTableViewController: UITableViewController {

    var cellCount:Int = 0
    var numOfCells = 0
    var arrayOfTasks:[Tasks]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataStore.shared.loadTasks()
        getTasks()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getTasks()
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
        numOfCells = arrayOfTasks.count
        return numOfCells + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row < numOfCells){
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
            let task = arrayOfTasks[indexPath.row]
            cell.taskLabel.text = task.taskDescription
            cell.deadlineLabel.text = task.taskDeadlineDate
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newButtonCell", for: indexPath)
            return cell
        }
    }
    
    func getTasks() {
        arrayOfTasks = [Tasks]()
        let totalTasks:Int = DataStore.shared.countTasks()
        if totalTasks > 0 {
            let currentUser = DataStore.shared.getIndexOfUserLoggedIn()
            var index:Int = 0
            for i in 0...totalTasks {
                let task:Tasks = DataStore.shared.getTask(index: i)
                if currentUser == task.personID {
                    arrayOfTasks.append(task)
                    index = index + 1
                }
            }
        }
    }
    
    @IBAction func unwindToTaskList(segue: UIStoryboardSegue){}

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
