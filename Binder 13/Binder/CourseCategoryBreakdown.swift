//
//  CourseCategoryBreakdown.swift
//  Binder
//
//  Created by Brandon Kerbow on 4/23/18.
//  Copyright © 2018 The University of Texas at Austin. All rights reserved.
//

import Foundation

class CourseCategoryBreakdown {
    
    fileprivate var _firebaseRandomID:String = ""
    fileprivate var _pk:Int = 0
    fileprivate var _peopleInCoursesID:Int = 0 //this number will corrospond to a primary key in the "peopleInCourses" class, i.e. a given person in a given class. this person in the class will have assignment categorys and percents for each of them, hence the purpose of this class
    fileprivate var _percentOfFinalGradeOfCategory:Float = 0.0
    fileprivate var _category:String = ""
    
    
    var firebaseRandomID:String {
        get { return _firebaseRandomID }
        set(newVal) { _firebaseRandomID = newVal }
    }
 
    
    var pk:Int {
        get { return _pk }
        set (newValue) { _pk = newValue }
    }
    
    var peopleInCoursesID:Int {
        get { return _peopleInCoursesID }
        set(newVal) { _peopleInCoursesID = newVal }
    }
    
    var percentOfFinalGradeOfCategory:Float {
        get { return _percentOfFinalGradeOfCategory }
        set(newVal) { _percentOfFinalGradeOfCategory = newVal }
    }
    
    var category:String {
        get { return _category }
        set(newVal) { _category = newVal }
    }
    
    
    init(pk:Int, peopleInCoursesID:Int, percentOfFinalGradeOfCategory:Float, category:String, firebaseRandomID:String ) {
        self._pk = pk
        self._peopleInCoursesID = peopleInCoursesID
        self._percentOfFinalGradeOfCategory = percentOfFinalGradeOfCategory
        self._category = category
        self._firebaseRandomID = firebaseRandomID
    }
    
    
    
}
