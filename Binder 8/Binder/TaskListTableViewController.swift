//
//  TaskListTableViewController.swift
//  Binder
//
//  Created by Isaac on 4/14/18.
//  Copyright © 2018 The University of Texas at Austin. All rights reserved.
//

import UIKit
import EventKit

class TaskListTableViewController: UITableViewController {

    var cellCount:Int = 0
    var numOfCells = 0
    var arrayOfTasks:[Tasks]!
    let eventStore = EKEventStore()
    var calendars: [EKCalendar]?
    var calendarIndex:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTasks()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getTasks()
        super.viewWillAppear(animated)
        checkCalendarAuthorizationStatus()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
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
            for i in 0...totalTasks - 1{
                let task:Tasks = DataStore.shared.getTask(index: i)
                if currentUser == task.personID {
                    arrayOfTasks.append(task)
                    index = index + 1
                }
            }
        }
    }
    
    func checkCalendarAuthorizationStatus(){
        let status = EKEventStore.authorizationStatus(for: .event)
        switch (status) {
            case .notDetermined:
                self.requestAccessToCalendar()
            case .authorized:
                self.loadCalendar()
            case .restricted, .denied:
                self.needPermission()
        }
    }
    
    func requestAccessToCalendar(){
        eventStore.requestAccess(to: .event, completion: {
            (granted: Bool, error: Error?) in
            if granted == true {
                DispatchQueue.main.async(execute: {
                    self.loadCalendar()
                })
            }
//            else {
//                self.needPermission()
//            }
        })
    }
    
    func loadCalendar(){
        self.calendars = eventStore.calendars(for: .event)
        if let calendars = self.calendars {
            var index:Int = 0
            for calendar in calendars{
                if calendar.title == "Binder" {
                    calendarIndex = index
                }
                index = index + 1
            }
        }
        if calendarIndex == 0 {
            createCalendar()
            addEntries()
        }
        
    }
    
    func createCalendar(){
        let newCalendar = EKCalendar(for: .event, eventStore: eventStore)
        newCalendar.title = "Binder"
        let sourcesInEventStore = eventStore.sources
        var filteredCalendarList = sourcesInEventStore.filter{
            (source: EKSource) -> Bool in
            source.sourceType == .local
        }
        if filteredCalendarList.first == nil {
            filteredCalendarList = sourcesInEventStore.filter{
                (source: EKSource) -> Bool in
                source.sourceType == .calDAV
            }
        }
        newCalendar.source = filteredCalendarList.first!
        do{
            try eventStore.saveCalendar(newCalendar, commit: true)
            UserDefaults.standard.set(newCalendar.calendarIdentifier, forKey: "Binder")
            let alert = UIAlertController(title: "Calendar Saved", message: "Calendar was successfully saved", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
        } catch _ {
            let alert = UIAlertController(title: "Calendar Save Error", message: "Calendar could not be saved", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKAction)
                self.present(alert, animated:true, completion: nil)
        }
    }
    
    func addEntries(){
        let taskCount:Int = DataStore.shared.countTasks()
        if(taskCount > 0){
            let calendarIdentifier = UserDefaults.standard.string(forKey: "Binder")
            let calendar = eventStore.calendar(withIdentifier: calendarIdentifier!)
            if(calendar != nil) {
                for i in 0...taskCount - 1 {
                    let task = DataStore.shared.getTask(index: i)
                    let startDate = Date()
                    let endDate = task.taskDeadlineDate
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "mm/dd/yyyy"
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    let date = dateFormatter.date(from: endDate)!
                    let c = Calendar.current
                    let components = c.dateComponents([.month, .day, .year], from: date)
                    let finalEndDate = c.date(from:components)
                    let event = EKEvent(eventStore: eventStore)
                    event.calendar = calendar
                    event.title = task.taskDescription
                    event.startDate = startDate
                    event.endDate = finalEndDate
                    do {
                        try eventStore.save(event, span: EKSpan.thisEvent)
                        
                        let alert = UIAlertController(title: "Event Saved", message: "Event was successfully saved", preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(OKAction)
                        
                        self.present(alert, animated: true, completion: nil)
                    } catch _ {
                        let alert = UIAlertController(title: "Event Save Error", message: "Event could not be saved", preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(OKAction)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func deleteCalendar(){
        let calendarIdentifier = UserDefaults.standard.string(forKey: "Binder")
        let calendar = eventStore.calendar(withIdentifier: calendarIdentifier!)
        if(calendar != nil) {
            do{
                try eventStore.removeCalendar(calendar!, commit:true)
                let alert = UIAlertController(title: "Calendar Deleted", message: "Calendar was successfully deleted", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OKAction)
                
                self.present(alert, animated: true, completion: nil)
            }catch _ {
                let alert = UIAlertController(title: "Calendar Delete Error", message: "Calendar could not be deleted", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OKAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func needPermission(){
        
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
