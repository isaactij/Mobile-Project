//
//  CreateTaskViewController.swift
//  Binder
//
//  Created by Isaac on 4/15/18.
//  Copyright © 2018 The University of Texas at Austin. All rights reserved.
//

import UIKit
import EventKit

class CreateTaskViewController: UIViewController {
    @IBOutlet weak var taskDescriptionTextInput: UITextField!
    @IBOutlet weak var deadlineDateTextField: UITextField!
    @IBOutlet weak var reminderDateTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    let pickerDeadlineDate = UIDatePicker()
    let pickerReminderDate = UIDatePicker()
    let eventStore = EKEventStore()
    var calendars: [EKCalendar]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deadlineDateTextField.text = ""
        reminderDateTextField.text = ""
        errorLabel.text = ""
        createDatePicker()
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
        deadlineDateTextField.text = "\(deadlineDateString)"
        self.view.endEditing(true)
    }
    
    @objc func donePressedRR() {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        var reminderDateString = formatter.string(from: pickerReminderDate.date)
        formatter.timeStyle = .short
        reminderDateString = " " + formatter.string(from: pickerReminderDate.date)
        reminderDateTextField.text = "\(reminderDateString)"
        self.view.endEditing(true)
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        var description = taskDescriptionTextInput.text
        description = description?.trimmingCharacters(in: .whitespacesAndNewlines)
        if filledFields(description:description!) {
            let authorized:Bool = checkCalendarAuthorizationStatus()
            if authorized {
                addToCalendar()
            }
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
    
    func addToCalendar(){
        let calendarIdentifier = UserDefaults.standard.string(forKey: "Binder")
        let calendar = eventStore.calendar(withIdentifier: calendarIdentifier!)
        if(calendar != nil) {
            let endDate = pickerDeadlineDate.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            let event = EKEvent(eventStore: eventStore)
            event.calendar = calendar
            event.title = taskDescriptionTextInput.text
            event.startDate = endDate
            event.endDate = endDate
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
    
    func addTask(description:String){
        let index:Int = DataStore.shared.countTasks()
        let currentUserID = DataStore.shared.getIndexOfUserLoggedIn()
        let task:Tasks = Tasks(taskID: index, taskDescription: description, taskDeadlineDate: String(describing: pickerDeadlineDate.date), taskReminderDate: String(describing: pickerReminderDate.date), personID: currentUserID)
        DataStore.shared.addTask(task: task)
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

}
