//
//  People.swift
//  Binder
//
//  Created by Brandon Kerbow on 3/25/18.
//  Copyright © 2018 The University of Texas at Austin. All rights reserved.
//

import Foundation

class People {
    
    fileprivate var _firebaseRandomID:String = ""
    fileprivate var _username:String = ""
    fileprivate var _password:String = ""
    fileprivate var _personID:Int = 0
    fileprivate var _fontSize:String = "small"
    fileprivate var _backgroundColor:String = "blue"
    
    var firebaseRandomID:String {
        get { return _firebaseRandomID }
        set(newVal) { _firebaseRandomID = newVal }
    }
    
    var username:String {
        get { return _username }
        set (newValue) { _username = newValue }
    }
    var password:String {
        get { return _password }
        set(newVal) { _password = newVal }
    }
    var personID:Int {
        get { return _personID }
        set(newVal) { _personID = newVal }
    }
    var fontSize:String {
        get { return _fontSize }
        set(newVal) { _fontSize = newVal }
    }
    var backgroundColor:String {
        get { return _backgroundColor }
        set(newVal) { _backgroundColor = newVal }
    }
    
    init(username:String, password:String, personID:Int, fontSize:String, backgroundColor:String, firebaseRandomID:String ) {
        self._username = username
        self._password = password
        self._personID = personID
        
        self._fontSize = fontSize
        self._backgroundColor = backgroundColor
        self._firebaseRandomID = firebaseRandomID
    }
    
    
    
}
