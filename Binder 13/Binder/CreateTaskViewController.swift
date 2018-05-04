// look here j
//  CreateTaskViewController.swift
//  Binder
//
//  Created by Isaac on 4/15/18.
//  Copyright © 2018 The University of Texas at Austin. All rights reserved.
//

import UIKit
import EventKit
import UserNotifications

class CreateTaskViewController: UIViewController {
    @IBOutlet weak var taskDescriptionTextInput: UITextField!
    @IBOutlet weak var deadlineDateTextField: UITextField!
    @IBOutlet weak var reminderDateTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    let pickerDeadlineDate = UIDatePicker()
    let pickerReminderDate = UIDatePicker()
    let eventStore = EKEventStore()
    var calendars: [EKCalendar]?
    var givenID:Int = -1
    var editingTask:Bool = false
    var givenTask:Tasks?
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkBackgroundColorAndFontSize()
        
        if(givenID != -1){
            editingTask = true
            populateFields()
            button.setTitle("Update", for: UIControlState.normal)
        }else{
            deadlineDateTextField.text = ""
            reminderDateTextField.text = ""
        }
        errorLabel.text = ""
        createDatePicker()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        checkBackgroundColorAndFontSize()
        
    }
    
    func populateFields(){
        let task:Tasks = DataStore.shared.getTask(id: givenID)
        givenTask = task
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from: task.taskDeadlineDate)!
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        var deadlineDateString = formatter.string(from: date)
        formatter.timeStyle = .short
        deadlineDateString = " " + formatter.string(from: date)
        deadlineDateString = deadlineDateString.replacingOccurrences(of: ",", with: " at")
        deadlineDateTextField.text = deadlineDateString
        let reminderDate = dateFormatter.date(from: task.taskReminderDate)!
        formatter.dateStyle = .short
        var reminderDateString = formatter.string(from: reminderDate)
        formatter.timeStyle = .short
        reminderDateString = " " + formatter.string(from: reminderDate)
        reminderDateString = reminderDateString.replacingOccurrences(of: ",", with: " at")
        reminderDateTextField.text = reminderDateString
        taskDescriptionTextInput.text = task.taskDescription
    }
    
    func createDatePicker(){
        let toolbarDD = UIToolbar()
        toolbarDD.sizeToFit()
        let doneDD = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedDD))
        toolbarDD.setItems([doneDD], animated: false)
        
        deadlineDateTextField.inputAccessoryView = toolbarDD
        deadlineDateTextField.inputView = pickerDeadlineDate
        
        let toolbarRR = UIToolbar()
        toolbarRR.sizeToFit()
        let doneRR = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedRR))
        toolbarRR.setItems([doneRR], animated: false)
        reminderDateTextField.inputAccessoryView = toolbarRR
        reminderDateTextField.inputView = pickerReminderDate
    }
    
    @objc func donePressedDD() {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        var deadlineDateString = formatter.string(from: pickerDeadlineDate.date)
        formatter.timeStyle = .short
        deadlineDateString = " " + formatter.string(from: pickerDeadlineDate.date)
        deadlineDateString = deadlineDateString.replacingOccurrences(of: ",", with: " at")
        deadlineDateTextField.text = "\(deadlineDateString)"
        self.view.endEditing(true)
    }
    
    @objc func donePressedRR() {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        var reminderDateString = formatter.string(from: pickerReminderDate.date)
        formatter.timeStyle = .short
        reminderDateString = " " + formatter.string(from: pickerReminderDate.date)
        reminderDateString = reminderDateString.replacingOccurrences(of: ",", with: " at")
        reminderDateTextField.text = "\(reminderDateString)"
        self.view.endEditing(true)
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        var description = taskDescriptionTextInput.text
        description = description?.trimmingCharacters(in: .whitespacesAndNewlines)
        if filledFields(description:description!) {
            let authorizedCalendar:Bool = checkCalendarAuthorizationStatus()
            if authorizedCalendar {
                addToCalendar()
            }
            addReminder()
            addTask(description:description!)
            performSegue(withIdentifier: "unwindToTaskList", sender: self)
        }
        
    }
    
    func checkCalendarAuthorizationStatus() -> Bool{
        let status = EKEventStore.authorizationStatus(for: .event)
        if status == .authorized {
            return true
        }else{
            return false
        }
    }
    
    func addReminder(){
        let reminderDate = pickerReminderDate.date
        let content = UNMutableNotificationContent()
        content.title = taskDescriptionTextInput.text!
        let calendarA = Calendar.current
        let components = calendarA.dateComponents([.year, .month, .day, .hour, .minute, .second], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func addToCalendar(){
        let calendarIdentifier = UserDefaults.standard.string(forKey: "Binder")
        let calendar = eventStore.calendar(withIdentifier: calendarIdentifier!)
        if(calendar != nil) {
            let endDate = pickerDeadlineDate.date
            let event = EKEvent(eventStore: eventStore)
            event.calendar = calendar
            event.title = taskDescriptionTextInput.text
            event.startDate = endDate
            event.endDate = endDate
            if editingTask {
                let task:Tasks = DataStore.shared.getTask(id: givenID)
                let oldEvent = EKEvent(eventStore: eventStore)
                oldEvent.calendar = calendar
                oldEvent.title = task.taskDescription
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                let date = dateFormatter.date(from:task.taskDeadlineDate)!
                oldEvent.startDate = date
                oldEvent.endDate = date
                deleteCalendar()
                createCalendar()
                DataStore.shared.updateTask(task: givenTask!, newDescription: taskDescriptionTextInput.text!, newDeadlineDate: String(describing: pickerDeadlineDate.date), newReminderDate: String(describing: pickerReminderDate.date), samePersonID: task.personID)
                addEntries()
            }
            do {
                try eventStore.save(event, span: EKSpan.thisEvent)
                
//                    let alert = UIAlertController(title: "Event Saved", message: "Event was successfully saved", preferredStyle: .alert)
//                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                    alert.addAction(OKAction)
//
//                    self.present(alert, animated: true, completion: nil)
            } catch _ {
//                    let alert = UIAlertController(title: "Event Save Error", message: "Event could not be saved", preferredStyle: .alert)
//                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                    alert.addAction(OKAction)
//
//                    self.present(alert, animated: true, completion: nil)
            }
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
            //            let alert = UIAlertController(title: "Calendar Saved", message: "Calendar was successfully saved", preferredStyle: .alert)
            //            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            //            alert.addAction(OKAction)
            //            self.present(alert, animated: true, completion: nil)
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
                    let task = DataStore.shared.getTaskAt(index: i)
                    let endDate = task.taskDeadlineDate
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    let date = dateFormatter.date(from: endDate)!
                    let event = EKEvent(eventStore: eventStore)
                    event.calendar = calendar
                    event.title = task.taskDescription
                    event.startDate = date
                    event.endDate = date
                    do {
                        try eventStore.save(event, span: EKSpan.thisEvent)
                        
                        //                        let alert = UIAlertController(title: "Event Saved", message: "Event was successfully saved", preferredStyle: .alert)
                        //                        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        //                        alert.addAction(OKAction)
                        //
                        //                        self.present(alert, animated: true, completion: nil)
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
    
    func addTask(description:String){
        if !editingTask {
            let index:Int = DataStore.shared.countTasks()
            let currentUserID = DataStore.shared.getIndexOfUserLoggedIn()
            let task:Tasks = Tasks(taskID: index, taskDescription: description, taskDeadlineDate: String(describing: pickerDeadlineDate.date), taskReminderDate: String(describing: pickerReminderDate.date), personID: currentUserID, firebaseRandomID:"")
            DataStore.shared.addTask(task: task)
        }
        
    }
    
    func filledFields(description:String) -> Bool{
        var filled: Bool = true
        if taskDescriptionTextInput.text == "" || deadlineDateTextField.text == "" || reminderDateTextField.text == "" {
            errorLabel.text = "Please enter all fields"
            filled = false
        }
        return filled
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
           
            errorLabel.font = UIFont.systemFont(ofSize: 15.0)
            taskDescriptionTextInput.font = UIFont.systemFont(ofSize: 15.0)
            deadlineDateTextField.font = UIFont.systemFont(ofSize: 15.0)
            reminderDateTextField.font = UIFont.systemFont(ofSize: 15.0)
            
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            
        
        } else {
            errorLabel.font = UIFont.systemFont(ofSize: 20.0)
            taskDescriptionTextInput.font = UIFont.systemFont(ofSize: 20.0)
            deadlineDateTextField.font = UIFont.systemFont(ofSize: 20.0)
            reminderDateTextField.font = UIFont.systemFont(ofSize: 20.0)
            
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            
        }
    }
}
