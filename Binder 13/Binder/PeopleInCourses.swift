//
//  PeopleInCourses.swift
//  Binder
//
//  Created by Brandon Kerbow on 3/25/18.
//  Copyright © 2018 The University of Texas at Austin. All rights reserved.
//

import Foundation

class PeopleInCourses {
    
    fileprivate var _firebaseRandomID:String = ""
    fileprivate var _courseID:Int = 0
    fileprivate var _personID:Int = 0
    fileprivate var _pk:Int = 0
    
    
    var firebaseRandomID:String {
        get { return _firebaseRandomID }
        set(newVal) { _firebaseRandomID = newVal }
    }
 
    
    var courseID:Int {
        get { return _courseID }
        set (newValue) { _courseID = newValue }
    }
    
    var personID:Int {
        get { return _personID }
        set(newVal) { _personID = newVal }
    }
    var pk:Int {
        get { return _pk }
        set(newVal) { _pk = newVal }
    }
    
    init(courseID:Int,  personID:Int, pk:Int, firebaseRandomID:String) {
        self._courseID = courseID
        self._personID = personID
        self._pk = pk
        self._firebaseRandomID = firebaseRandomID
    }
    

}
