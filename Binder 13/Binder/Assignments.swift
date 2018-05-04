//
//  Assignments.swift
//  Binder
//
//  Created by Brandon Kerbow on 3/25/18.
//  Copyright © 2018 The University of Texas at Austin. All rights reserved.
//

import Foundation

class Assignments {
    
    fileprivate var _firebaseRandomID:String = ""
    fileprivate var _pk:Int = 0
    fileprivate var _assignmentTitle:String = ""
//    fileprivate var _assignmentID:Int = 0 //serial incrementer for courseID and personID
    fileprivate var _assignmentType:String = ""
    fileprivate var _courseID:Int = 0
    fileprivate var _percentOfGrade:Int = 0
    fileprivate var _assignmentGrade:Int = 0
    fileprivate var _personID:Int = 0
    
    
    var firebaseRandomID:String {
        get { return _firebaseRandomID }
        set(newVal) { _firebaseRandomID = newVal }
    }
 
    
    
    var pk:Int {
        get { return _pk }
        set (newValue) { _pk = newValue }
    }
    
    var assignmentTitle:String {
        get { return _assignmentTitle }
        set(newVal) { _assignmentTitle = newVal }
    }
    
//    var assignmentID:Int {
//        get { return _assignmentID }
//        set (newValue) { _assignmentID = newValue }
//    }
    
    var assignmentType:String {
        get { return _assignmentType }
        set(newVal) { _assignmentType = newVal }
    }
    
    var courseID:Int {
        get { return _courseID }
        set(newVal) { _courseID = newVal }
    }
    
    var percentOfGrade:Int {
        get { return _percentOfGrade }
        set(newVal) { _percentOfGrade = newVal }
    }
    
    var assignmentGrade:Int {
        get { return _assignmentGrade }
        set(newVal) { _assignmentGrade = newVal }
    }
    
    var personID:Int {
        get { return _personID }
        set(newVal) { _personID = newVal }
    }
    
    init(assignmentType:String, courseID:Int, percentOfGrade:Int, assignmentGrade:Int, personID:Int, pk:Int, assignmentTitle:String,  firebaseRandomID:String) {
        self._pk = pk
        self._assignmentTitle = assignmentTitle
//        self._assignmentID = assignmentID
        self._assignmentType = assignmentType
        self._courseID = courseID
        self._percentOfGrade = percentOfGrade
        self._assignmentGrade = assignmentGrade
        self._personID = personID
        self._firebaseRandomID = firebaseRandomID
    }
    
    
    
}
