//
//  CreateTaskViewController.swift
//  Binder
//
//  Created by Isaac on 4/15/18.
//  Copyright © 2018 The University of Texas at Austin. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController {
    @IBOutlet weak var taskDescriptionTextInput: UITextField!
    @IBOutlet weak var deadlineDateTextField: UITextField!
    @IBOutlet weak var deadlineTimeTextField: UITextField!
    @IBOutlet weak var reminderDateTextField: UITextField!
    @IBOutlet weak var reminderTimeTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    let pickerDeadlineDate = UIDatePicker()
    let pickerReminderDate = UIDatePicker()
    let pickerDeadlineTime = UIDatePicker()
    let pickerReminderTime = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deadlineDateTextField.text = ""
        deadlineTimeTextField.text = ""
        reminderDateTextField.text = ""
        reminderTimeTextField.text = ""
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
        
        let toolbarDT = UIToolbar()
        toolbarDT.sizeToFit()
        let doneDT = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedDT))
        toolbarDT.setItems([doneDT], animated: false)
        deadlineTimeTextField.inputAccessoryView = toolbarDT
        deadlineTimeTextField.inputView = pickerDeadlineTime
        
        let toolbarRT = UIToolbar()
        toolbarRT.sizeToFit()
        let doneRT = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedRT))
        toolbarRT.setItems([doneRT], animated: false)
        reminderTimeTextField.inputAccessoryView = toolbarRT
        reminderTimeTextField.inputView = pickerReminderTime
        
        pickerDeadlineDate.datePickerMode = .date
        pickerReminderDate.datePickerMode = .date
        pickerDeadlineTime.datePickerMode = .time
        pickerReminderTime.datePickerMode = .time
    }
    
    @objc func donePressedDT() {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let deadlineTimeString = formatter.string(from: pickerDeadlineTime.date)
        deadlineTimeTextField.text = "\(deadlineTimeString)"
        self.view.endEditing(true)
    }
    
    @objc func donePressedRT() {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let reminderTimeString = formatter.string(from: pickerReminderTime.date)
        reminderTimeTextField.text = "\(reminderTimeString)"
        self.view.endEditing(true)
    }
    
    @objc func donePressedDD() {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let deadlineDateString = formatter.string(from: pickerDeadlineDate.date)
        deadlineDateTextField.text = "\(deadlineDateString)"
        self.view.endEditing(true)
    }
    
    @objc func donePressedRR() {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let reminderDateString = formatter.string(from: pickerReminderDate.date)
        reminderDateTextField.text = "\(reminderDateString)"
        self.view.endEditing(true)
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        var description = taskDescriptionTextInput.text
        description = description?.trimmingCharacters(in: .whitespacesAndNewlines)
        if filledFields(description:description!) {
            addTask(description:description!)
            performSegue(withIdentifier: "unwindToTaskList", sender: self)
        }
        
    }
    
    
    func addTask(description:String){
        //DataStore.shared.loadTasks()
        let index:Int = DataStore.shared.countTasks()
        let currentUserID = DataStore.shared.getIndexOfUserLoggedIn()
        let task:Tasks = Tasks(taskID: index, taskDescription: description, taskDeadlineDate: deadlineDateTextField.text!, taskDeadlineTime: deadlineTimeTextField.text!, taskReminderDate: reminderDateTextField.text!, taskReminderTime: reminderTimeTextField.text!, personID: currentUserID, taskStartDate: String(describing: Date()))
        DataStore.shared.addTask(task: task)
    }
    
    func filledFields(description:String) -> Bool{
        var filled: Bool = true
        if taskDescriptionTextInput.text == "" || deadlineDateTextField.text == "" || deadlineTimeTextField.text == "" || reminderDateTextField.text == "" || reminderTimeTextField.text == ""{
            errorLabel.text = "Please enter all fields"
            filled = false
        }
        return filled
    }
    
    @IBAction func clearButtonOnePressed(_ sender: Any) {
        deadlineDateTextField.text = ""
    }
    
    @IBAction func clearButtonTwoPressed(_ sender: Any) {
        deadlineTimeTextField.text = ""
    }
    
    @IBAction func clearButtonThreePressed(_ sender: Any) {
        reminderDateTextField.text = ""
    }
    
    @IBAction func clearButtonFourPressed(_ sender: Any) {
        reminderTimeTextField.text = ""
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
