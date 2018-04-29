//
//  Tasks.swift
//  Binder
//
//  Created by Isaac on 4/14/18.
//  Copyright © 2018 The University of Texas at Austin. All rights reserved.
//

import Foundation

class Tasks {
    fileprivate var _taskID:Int = 0
    fileprivate var _taskDescription:String = ""
    fileprivate var _taskDeadlineDate:String = ""
    fileprivate var _taskDeadlineTime:String = ""
    fileprivate var _taskReminderDate:String = ""
    fileprivate var _taskReminderTime:String = ""
    fileprivate var _personID:Int = 0
    fileprivate var _taskStartDate:String = ""
    
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
    
    var taskDeadlineTime:String {
        get { return _taskDeadlineTime }
        set (newValue) { _taskDeadlineTime = newValue}
    }
    
    var taskReminderDate:String {
        get { return _taskReminderDate }
        set (newValue) { _taskReminderDate = newValue}
    }
    
    var taskReminderTime:String {
        get { return _taskReminderTime }
        set (newValue) { _taskReminderTime = newValue}
    }
    
    var personID:Int {
        get { return _personID }
        set (newValue) { _personID = newValue}
    }
    
    var taskStartDate:String {
        get{ return _taskStartDate}
        set(newValue) {_taskStartDate = newValue}
    }
    
    init(taskID:Int, taskDescription:String, taskDeadlineDate:String, taskDeadlineTime:String, taskReminderDate:String, taskReminderTime:String, personID:Int, taskStartDate:String) {
        self._taskID = taskID
        self._taskDescription = taskDescription
        self._taskDeadlineDate = taskDeadlineDate
        self._taskDeadlineTime = taskDeadlineTime
        self._taskReminderDate = taskReminderDate
        self._taskReminderTime = taskReminderTime
        self._personID = personID
        self._taskStartDate = taskStartDate
    }
    
}
