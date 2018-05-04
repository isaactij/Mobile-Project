//
//  Courses.swift
//  Binder
//
//  Created by Brandon Kerbow on 3/25/18.
//  Copyright © 2018 The University of Texas at Austin. All rights reserved.
//

import Foundation

class Courses {
    
    fileprivate var _firebaseRandomID:String = ""
    fileprivate var _courseName:String = ""
    fileprivate var _courseAbbreviation:String = ""
    fileprivate var _courseID:Int = 0
    
    var firebaseRandomID:String {
        get { return _firebaseRandomID }
        set(newVal) { _firebaseRandomID = newVal }
    }
 
    
    var courseName:String {
        get { return _courseName }
        set (newValue) { _courseName = newValue }
    }
    var courseAbbreviation:String {
        get { return _courseAbbreviation }
        set(newVal) { _courseAbbreviation = newVal }
    }
    var courseID:Int {
        get { return _courseID }
        set(newVal) { _courseID = newVal }
    }
    
    init(courseName:String, courseAbbreviation:String, courseID:Int, firebaseRandomID:String) {
        self._courseName = courseName
        self._courseAbbreviation = courseAbbreviation
        self._courseID = courseID
        self._firebaseRandomID = firebaseRandomID
    }
    
    
    
}
