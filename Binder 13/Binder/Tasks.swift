// look here
//  Tasks.swift
//  Binder
//
//  Created by Isaac on 4/14/18.
//  Copyright © 2018 The University of Texas at Austin. All rights reserved.
//

import Foundation

class Tasks {
    
    fileprivate var _firebaseRandomID:String = ""
    fileprivate var _taskID:Int = 0
    fileprivate var _taskDescription:String = ""
    fileprivate var _taskDeadlineDate:String = ""
    fileprivate var _taskReminderDate:String = ""
    fileprivate var _personID:Int = 0
    
    
    var firebaseRandomID:String {
        get { return _firebaseRandomID }
        set(newVal) { _firebaseRandomID = newVal }
    }
    
    
    var taskID:Int {
        get { return _taskID }
        set (newValue) { _taskID = newValue}
    }
    
    var taskDescription:String {
        get { return _taskDescription }
        set (newValue) { _taskDescription = newValue}
    }
    
    var taskDeadlineDate:String {
        get { return _taskDeadlineDate }
        set (newValue) { _taskDeadlineDate = newValue}
    }
    
    var taskReminderDate:String {
        get { return _taskReminderDate }
        set (newValue) { _taskReminderDate = newValue}
    }
    
    var personID:Int {
        get { return _personID }
        set (newValue) { _personID = newValue}
    }
    
    init(taskID:Int, taskDescription:String, taskDeadlineDate:String, taskReminderDate:String, personID:Int, firebaseRandomID:String) {
        self._taskID = taskID
        self._taskDescription = taskDescription
        self._taskDeadlineDate = taskDeadlineDate
        self._taskReminderDate = taskReminderDate
        self._personID = personID
        self._firebaseRandomID = firebaseRandomID
    }
    
}
