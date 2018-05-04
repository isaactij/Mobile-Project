// look here
//  DataStore.swift
//  TestFirebase2
//
//  Created by Robert Seitsinger on 10/12/17.
//  Copyright © 2017 Summer Moon Solutions. All rights reserved.
//

import Foundation
import Firebase

class DataStore {
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // ~ IMPORTANT FIREBASE INFO ~
    //
    // our firebase link (should have got email from brandon 04/08 sunday night around 11:59pm):
    // https://console.firebase.google.com/project/binderappproject
    //
    // NOTE: It seems like the only time loadPeople() (or loadAssignment(), loadCourseS()...etc) should be called
    // is during the viewDidLoad() of the login screen, since that saves everything on the server to local (i.e. stored within app) variables which
    // can be used in the app, and the addPerson() (and addAssignment()..etc) add to both firebase and these local variables
    //
    // THE CONTENTS OF THIS CLASS WAS LARGELY BORROWED FROM PROFESSOR SEITSINGERS "test firebase2" code postsed on canvas, online lecture recorded 03/02/2018
    //
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    // Instantiate the singleton object.
    static let shared = DataStore()
    
    private var ref: DatabaseReference!
    
    private var arrayOfPeople: [People]!
    private var arrayOfAssignments: [Assignments]!
    private var arrayOfCourses: [Courses]!
    private var arrayOfPeopleInCourses: [PeopleInCourses]!
    private var arrayOfTasks: [Tasks]!
    private var arrayOfCourseCategoryBreakdowns: [CourseCategoryBreakdown]!
    private var indexOfUserLoggedIn: Int? = nil //is specified when the user logs in
    
    // Making the init method private means only this class can instantiate an object of this type.
    private init() {
        // Get a database reference.
        // Needed before we can read/write to/from the firebase database.
        ref = Database.database().reference()
    }
    
    //
    //PEOPLE RELATED METHODS
    //
    
    func countOfPeople() -> Int {
        return arrayOfPeople.count
    }
    
    func getPerson(index: Int) -> People {
        //print(DataStore.shared.countOfPeople())
        return arrayOfPeople[index]
    }
    
    func setIndexOfUserLoggedIn(_setValue: Int) {
        indexOfUserLoggedIn = _setValue
    }
    
    func getIndexOfUserLoggedIn() -> Int {
        return indexOfUserLoggedIn!
    }
    
    func loadPeople() {
        // Start with an empty array.
        arrayOfPeople = [People]()
        
        // Fetch the data from Firebase and store it in our internal people array.
        // This is a one-time listener.
        ref.child("people").observeSingleEvent(of: .value, with: { (snapshot) in

            // Get the top-level dictionary.

            let value = snapshot.value as? NSDictionary
  
            if let persons = value {

                // Iterate over the person objects and store in our internal people array.
                for p in persons {
                    let id = p.key as! String
                    //let personIDforObject = Int(id[6...]) //takes int of the 6th string element and beyond
                    let person = p.value as! [String:String]
                    let firebaseRandomID = person["firebaseRandomID"]
                    let personID = person["personID"] //person ID is passed into the object as the int but you also want to see it on firebase
                    let personIDforObject = Int(personID!)
                    let username = person["username"]
                    let password = person["password"]
                    let fontSize = person["fontSize"]
                    let backgroundColor = person["backgroundColor"]
                    let newPerson = People(username:username!, password:password!, personID:personIDforObject!, fontSize:fontSize!, backgroundColor:backgroundColor!, firebaseRandomID: firebaseRandomID! )
    
                    self.arrayOfPeople.append(newPerson)
                   

                }
            }
        }) { (error) in
            print(error.localizedDescription)
            
        }
    }
    
    func addPerson(person: People) {
        
        let personsRandomFirebaseID = self.ref.child("people").childByAutoId()
        
        let personsRandomFirebaseIDStringNeedsSubString = String(describing: personsRandomFirebaseID)
        
        let personsRandomFirebaseIDString = personsRandomFirebaseIDStringNeedsSubString[47...]
        
        //assign this randomly generated firebase ID to an attribute of the person
        //so that it can be referenced in the "update" method
        person.firebaseRandomID = String(personsRandomFirebaseIDString)
        
        // define array of key/value pairs to store for this person.
        let personRecord = [
            "firebaseRandomID": person.firebaseRandomID,
            "username": person.username,
            "password": person.password,
            "fontSize": person.fontSize,
            "backgroundColor": person.backgroundColor,
            "personID": String(person.personID)
        ]
        
        // Save to Firebase.
        /*
        self.ref.child("people").child(String("person" + String(person.personID))).setValue(personRecord)
        */
        personsRandomFirebaseID.setValue(personRecord)
        

        // Also save to our internal array, to stay in sync with what's in Firebase.
        arrayOfPeople.append(person)
    }
    
    func updatePerson(person: People, newPassword: String, newBackgroundColor:String, newFontSize: String) {
        
        person.password = newPassword
        person.backgroundColor = newBackgroundColor
        person.fontSize = newFontSize
        
        /*
        let refToUpdate = self.ref.child("people").child(String("person" + String(person.personID)))
        */
        let refToUpdate = self.ref.child("people").child(person.firebaseRandomID)
        
        refToUpdate.updateChildValues([
            "username": person.username,
            "password": newPassword,
            "backgroundColor": newBackgroundColor,
            "fontSize": newFontSize
        ])
    }
    
    //
    // END OF PEOPLE RELATED METHODS
    //
    
    
    //
    //ASSIGNMENT RELATED METHODS
    //
    
    func countOfAssignments() -> Int {
        return arrayOfAssignments.count
    }
    
    func getAssignment(index: Int) -> Assignments {
        return arrayOfAssignments[index]
    }
    
    func loadAssignments() {
        // Start with an empty array.
        arrayOfAssignments = [Assignments]()
        
        // Fetch the data from Firebase and store it in our internal people array.
        // This is a one-time listener.
        ref.child("assignments").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get the top-level dictionary.
            let value = snapshot.value as? NSDictionary
            
            if let theAssignments = value {
                // Iterate over the person objects and store in our internal people array.
                for p in theAssignments {
                    let id = p.key as! String
                    //let pk = Int(id[10...]) //takes int of the 10th string element and beyond
                    let assignment = p.value as! [String:String]
                    let pk = assignment["pk"]
                    let pkForObject = Int(pk!)
                    
                    let firebaseRandomID = assignment["firebaseRandomID"]
                    
                    let assignmentType = assignment["assignmentType"]
                    
                    let assignmentTitle = assignment["assignmentTitle"]
                    //let assignmentID = assignment["assignmentID"]
                    
                    let courseID = assignment["courseID"]
                    let courseIDforObject = Int(courseID!)
                    
                    let percentOfGrade = assignment["percentOfGrade"]
                    let percentOfGradeforObject = Int(percentOfGrade!)
                    
                    let assignmentGrade = assignment["assignmentGrade"]
                    let assignmentGradeforObject = Int(assignmentGrade!)
                    
                    let personID = assignment["personID"]
                    let personIDforObject = Int(personID!)
                    
//                   let assignmentID = assignment["assignmentID"]
//                   let assignmentIDForObject = Int(assignmentID!)
                    
                    
//                    let newAsignment = Assignments(assignmentID:assignmentIDForObject!, assignmentType:assignmentType!, courseID:courseIDforObject! , percentOfGrade:percentOfGradeforObject!, assignmentGrade: assignmentGradeforObject!, personID: personIDforObject!, pk: pk!, assignmentTitle: assignmentTitle!)
                    let newAsignment = Assignments(assignmentType:assignmentType!, courseID:courseIDforObject! , percentOfGrade:percentOfGradeforObject!, assignmentGrade: assignmentGradeforObject!, personID: personIDforObject!, pk: pkForObject!, assignmentTitle: assignmentTitle!, firebaseRandomID: firebaseRandomID!)
                    self.arrayOfAssignments.append(newAsignment)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func addAssignment(assignment: Assignments) {
        
        
        
        let assignmentsRandomFirebaseID = self.ref.child("assignments").childByAutoId()
        
        let assignmentsRandomFirebaseIDStringNeedsSubString = String(describing: assignmentsRandomFirebaseID)
        
        //print(assignmentsRandomFirebaseIDStringNeedsSubString)
        
        let assignmentsRandomFirebaseIDString = assignmentsRandomFirebaseIDStringNeedsSubString[52...]
        
        //assign this randomly generated firebase ID to an attribute of the person
        //so that it can be referenced in the "update" method
        assignment.firebaseRandomID = String(assignmentsRandomFirebaseIDString)
        
        
        
        
        
        
        // define array of key/value pairs to store for this person.
        let assignmentRecord = [
            "firebaseRandomID": assignment.firebaseRandomID,
            "assignmentType": assignment.assignmentType,
            "courseID": String(assignment.courseID),
            "percentOfGrade": String(assignment.percentOfGrade),
            "personID": String(assignment.personID),
            "assignmentGrade": String(assignment.assignmentGrade),
//            "assignmentID":String(assignment.assignmentID),
            "assignmentTitle":(assignment.assignmentTitle),
            "pk":String(assignment.pk)
            ] as [String : Any]
        
        // Save to Firebase.
        assignmentsRandomFirebaseID.setValue(assignmentRecord)
        
        // Also save to our internal array, to stay in sync with what's in Firebase.
        arrayOfAssignments.append(assignment)
    }
    
    
    func updateAssignment(assignment: Assignments, newAssignmentType: String, newCourseID:Int, newPercentOfGrade: Int, newAssignmentGrade: Int) {
        
        assignment.assignmentType = newAssignmentType
        assignment.courseID = newCourseID
        assignment.percentOfGrade = newPercentOfGrade
        assignment.assignmentGrade = newAssignmentGrade
        
        let refToUpdate = self.ref.child("assignments").child(assignment.firebaseRandomID)
        
        
        refToUpdate.updateChildValues([
            "assignmentType": newAssignmentType,
            "courseID": String(newCourseID),
            "percentOfGrade": String(newPercentOfGrade),
            "assignmentGrade": String(newAssignmentGrade)
            ])
    }
    
    
    
    
    //
    // END OF ASSIGNMENT RELATED METHODS
    //
    
    
    //
    // COURSES RELATED METHODS
    //
    
    func countOfCourses() -> Int {
        //print("what count of courses function returns")
        //print(arrayOfCourses.count)
        return arrayOfCourses.count
    }
    
    func getCourse(index: Int) -> Courses {
        return arrayOfCourses[index]
    }
    
    func loadCourses() {
        // Start with an empty array.
        arrayOfCourses = [Courses]()
       
        
        // Fetch the data from Firebase and store it in our internal people array.
        // This is a one-time listener.
        ref.child("courses").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get the top-level dictionary.
            let value = snapshot.value as? NSDictionary
            
            if let theCourses = value {
             
                // Iterate over the person objects and store in our internal people array.
                for p in theCourses {
                
                    let id = p.key as! String
                    //let courseIDforObject = Int(id[6...]) //takes int of the 6th string element and beyond
                    
                    
                    let course = p.value as! [String:String]
                    let firebaseRandomID = course["firebaseRandomID"]
                    let courseAbbreviation = course["courseAbbreviation"]
                    let courseName = course["courseName"]
                    let courseID = course["courseID"]
                    let courseIDforObject = Int(courseID!)

                    let newCourse = Courses(courseName:courseName!, courseAbbreviation:courseAbbreviation!, courseID:courseIDforObject!, firebaseRandomID: firebaseRandomID!)
                    
                    self.arrayOfCourses.append(newCourse)
                    //print("course count as seen inside dataStore")
                    //print(self.arrayOfCourses.count)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func addCourse(course: Courses) {
        
        let coursesRandomFirebaseID = self.ref.child("courses").childByAutoId()
        
        let coursesRandomFirebaseIDStringNeedsSubString = String(describing: coursesRandomFirebaseID)
        
        print(coursesRandomFirebaseIDStringNeedsSubString)
        
        let coursesRandomFirebaseIDString = coursesRandomFirebaseIDStringNeedsSubString[48...]
        
        //assign this randomly generated firebase ID to an attribute of the person
        //so that it can be referenced in the "update" method
        course.firebaseRandomID = String(coursesRandomFirebaseIDString)
        
        
        // define array of key/value pairs to store for this person.
        let courseRecord = [
            "firebaseRandomID": course.firebaseRandomID,
            "courseAbbreviation": String(course.courseAbbreviation),
            "courseName": String(course.courseName),
            "courseID": String(course.courseID)
            
            ]
        
        // Save to Firebase.
        coursesRandomFirebaseID.setValue(courseRecord)
        
        // Also save to our internal array, to stay in sync with what's in Firebase.
        arrayOfCourses.append(course)
    }
    
    
    
    func updateCourse(course: Courses, newCourseAbbreviation: String, newCourseName:String) {
        
        course.courseAbbreviation = newCourseAbbreviation
        course.courseName = newCourseName
        
        
        //print(person.personID) //was 0 in the first app runthrough...then you load it and its 0
        let refToUpdate = self.ref.child("courses").child(course.firebaseRandomID)
        
        
        refToUpdate.updateChildValues([
            "courseAbbreviation": newCourseAbbreviation,
            "courseName": newCourseName
            
            ])
    }
    
    //
    // END OF COURSE RELATED METHODS
    //
    
    
    //
    // PEOPLEINCOURSES RELATED METHODS
    //
    
    func countOfPeopleInCourses() -> Int {
        return arrayOfPeopleInCourses.count
    }
    
    func getPeopleInCourses(index: Int) -> PeopleInCourses {
        return arrayOfPeopleInCourses[index]
    }
    
    func loadPeopleInCourses() {
        // Start with an empty array.
        arrayOfPeopleInCourses = [PeopleInCourses]()
        
        // Fetch the data from Firebase and store it in our internal people array.
        // This is a one-time listener.
        ref.child("peopleInCourses").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get the top-level dictionary.
            let value = snapshot.value as? NSDictionary
            
            if let thePeopleInCourses = value {
                // Iterate over the person objects and store in our internal people array.
                for p in thePeopleInCourses {
                    let id = p.key as! String
                    //let peopleInCoursesIDforObject = Int(id[14...]) //takes int of the 14th string element and beyond
                    
                    //print(p.value)
                    let peopleInCourse = p.value as! [String:String]
                    
                    let firebaseRandomID = peopleInCourse["firebaseRandomID"]
                    
                    let peopleInCoursesID = peopleInCourse["pk"]
                    let peopleInCoursesIDforObject = Int(peopleInCoursesID!)
                    
                    let courseID = peopleInCourse["courseID"]
                    let courseIDforObject = Int(courseID!)
                    
                    let personID = peopleInCourse["personID"]
                    let personIDforObject = Int(personID!)
                    
                    let pk = peopleInCourse["pk"]
                    //let pkforObject = Int(pk!)
                    
                    let newPeopleInCourse = PeopleInCourses(courseID: courseIDforObject!, personID: personIDforObject!, pk: peopleInCoursesIDforObject!, firebaseRandomID:firebaseRandomID!)
                    
                    self.arrayOfPeopleInCourses.append(newPeopleInCourse)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func addPeopleInCourse(peopleInCourse: PeopleInCourses) {
        
        let peopleInCoursesRandomFirebaseID = self.ref.child("peopleInCourses").childByAutoId()
        
        let peopleInCoursesRandomFirebaseIDStringNeedsSubString = String(describing: peopleInCoursesRandomFirebaseID)
        
        //print(peopleInCoursesRandomFirebaseIDStringNeedsSubString)
        
        let peopleInCoursesRandomFirebaseIDString = peopleInCoursesRandomFirebaseIDStringNeedsSubString[56...]
        
        //assign this randomly generated firebase ID to an attribute of the person
        //so that it can be referenced in the "update" method
        peopleInCourse.firebaseRandomID = String(peopleInCoursesRandomFirebaseIDString)
        
        
        // define array of key/value pairs to store for this person.
        let peopleInCourseRecord = [
            "firebaseRandomID": peopleInCourse.firebaseRandomID,
            "courseID": String(peopleInCourse.courseID),
            "personID": String(peopleInCourse.personID),
            "pk":String(peopleInCourse.pk)
            
        ]
        
        // Save to Firebase.
        peopleInCoursesRandomFirebaseID.setValue(peopleInCourseRecord)
        
        // Also save to our internal array, to stay in sync with what's in Firebase.
        arrayOfPeopleInCourses.append(peopleInCourse)
    }
    
    
    
    func updatePeopleInCourse(peopleInCourse: PeopleInCourses, newCourseID:Int, newPersonID:Int) {
        
        peopleInCourse.courseID = newCourseID
        peopleInCourse.personID = newPersonID

        //print(person.personID) //was 0 in the first app runthrough...then you load it and its 0
        let refToUpdate = self.ref.child("peopleInCourses").child(peopleInCourse.firebaseRandomID)
        
        
        refToUpdate.updateChildValues([
            
            "courseID": String(newCourseID),
            "personID": String(newPersonID)
   
            ])
    }
    
    
    
    
    //
    // END OF PEOPLEINCOURSES RELATED METHODS
    //
    
    //Beginning of task related methods
    
    func countTasks() -> Int {
        return arrayOfTasks.count
    }
    
    func getTask(id: Int) -> Tasks {
        var found:Bool = false
        var index:Int = 0
        var task:Tasks = arrayOfTasks[index]
        while !found {
            task = arrayOfTasks[index]
            if task.taskID == id {
                found = true
            }else {
                index = index + 1
            }
        }
        return task
    }
    
    func getTaskAt(index: Int) -> Tasks {
        return arrayOfTasks[index]
    }
    
    func loadTasks(){
        arrayOfTasks = [Tasks]()
        ref.child("tasks").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let theTasks = value {
                for p in theTasks {
                    let id = p.key as! String
                    //let taskIDforObject = Int(id[4...])
                    let task = p.value as! [String:String]
                    let firebaseRandomID = task["firebaseRandomID"]
                    let taskID = task["taskID"]
                    let taskIDforObject = Int(taskID!)
                    let taskDescription = task["taskDescription"]
                    let taskDeadlineDate = task["taskDeadlineDate"]
                    let taskReminderDate = task["taskReminderDate"]
                    let personID = task["personID"]
                    let personIDforObject = Int(personID!)
                    let newTask = Tasks(taskID:taskIDforObject!, taskDescription:taskDescription!, taskDeadlineDate:taskDeadlineDate!, taskReminderDate:taskReminderDate!, personID:personIDforObject!, firebaseRandomID: firebaseRandomID!)
                    self.arrayOfTasks.append(newTask)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func addTask(task: Tasks) {
        
        let tasksRandomFirebaseID = self.ref.child("tasks").childByAutoId()
        
        let tasksRandomFirebaseIDStringNeedsSubString = String(describing: tasksRandomFirebaseID)
        
        //print(tasksRandomFirebaseIDStringNeedsSubString)
        
        let tasksRandomFirebaseIDString = tasksRandomFirebaseIDStringNeedsSubString[46...]
        
        
        //assign it to object
        task.firebaseRandomID = String(tasksRandomFirebaseIDString)
        
        
        
        
        
        let ID:String = String(task.taskID)
        //let firebaseRandomID:String = String(task.firebaseRandomID)
        let taskRecord = [
            "firebaseRandomID": task.firebaseRandomID,
            "taskID": ID,
            "taskDescription": String(task.taskDescription),
            "taskDeadlineDate": String(task.taskDeadlineDate),
            "taskReminderDate": String(task.taskReminderDate),
            "personID": String(task.personID)
            ] as [String : Any]
        
        tasksRandomFirebaseID.setValue(taskRecord)
        arrayOfTasks.append(task)
    }
    
    func updateTask(task: Tasks, newDescription: String, newDeadlineDate: String, newReminderDate: String, samePersonID:Int){
        task.taskDescription = newDescription
        task.taskDeadlineDate = newDeadlineDate
        task.taskReminderDate = newReminderDate
        task.personID = samePersonID
        
        let refToUpdate = self.ref.child("tasks").child(task.firebaseRandomID)
        
            refToUpdate.updateChildValues([
                "taskDescription": String(newDescription),
                "taskDeadlineDate": String(newDeadlineDate),
                "taskReminderDate": String(newReminderDate)
                ])
        var found:Bool = false
        var index:Int = 0
        var taskA:Tasks = arrayOfTasks[index]
        while !found {
            taskA = arrayOfTasks[index]
            if taskA.taskID == task.taskID {
                found = true
            }else {
                index = index + 1
            }
        }
        arrayOfTasks[index].taskDescription = newDescription
        arrayOfTasks[index].taskReminderDate = newReminderDate
        arrayOfTasks[index].taskDeadlineDate = newDeadlineDate
    }
    
    func deleteTask(task:Tasks){
        
        self.ref.child("tasks").child(task.firebaseRandomID)
        
        var found:Bool = false
        var index:Int = 0
        var taskA:Tasks = arrayOfTasks[index]
        while !found {
            taskA = arrayOfTasks[index]
            if taskA.taskID == task.taskID {
                found = true
            }else {
                index = index + 1
            }
        }
        arrayOfTasks.remove(at: index)
    }
    
    
    
    
    
    //End of task related methods


//
// CourseCategoryBreakdown RELATED METHODS
//

func countOfCourseCategoryBreakdowns() -> Int {
    return arrayOfCourseCategoryBreakdowns.count
}

func getCourseCategoryBreakdown(index: Int) -> CourseCategoryBreakdown {
    return arrayOfCourseCategoryBreakdowns[index]
}

func loadCourseCategoryBreakdowns() {
    // Start with an empty array.
    arrayOfCourseCategoryBreakdowns = [CourseCategoryBreakdown]()
    
    
    // Fetch the data from Firebase and store it in our internal people array.
    // This is a one-time listener.
    ref.child("coursesCategoryBreakdowns").observeSingleEvent(of: .value, with: { (snapshot) in
        // Get the top-level dictionary.
        let value = snapshot.value as? NSDictionary
        
        if let theCourseCategoryBreakdown = value {
            
            // Iterate over the person objects and store in our internal people array.
            for p in theCourseCategoryBreakdown {
                
                let id = p.key as! String
                //let pkForObject = Int(id[24...]) //takes int of the 6th string element and beyond
                
                let courseCategoryBreakdown = p.value as! [String:String]
                
                let firebaseRandomID = courseCategoryBreakdown["firebaseRandomID"]
                
                let pk = courseCategoryBreakdown["pk"]
                let pkForObject = Int(pk!)
                
                let peopleInCoursesID = courseCategoryBreakdown["peopleInCoursesID"]
                let peopleInCoursesIDForObject = Int(peopleInCoursesID!)
                
                let percentOfFinalGradeOfCategory = courseCategoryBreakdown["percentOfFinalGradeOfCategory"]
                let percentOfFinalGradeOfCategoryForObject = Float(percentOfFinalGradeOfCategory!)
                
                let category = courseCategoryBreakdown["category"]
                
                let newCourseCategoryBreakdown = CourseCategoryBreakdown(pk: pkForObject!, peopleInCoursesID: peopleInCoursesIDForObject!, percentOfFinalGradeOfCategory: percentOfFinalGradeOfCategoryForObject!, category: category!, firebaseRandomID: firebaseRandomID!)
                
                self.arrayOfCourseCategoryBreakdowns.append(newCourseCategoryBreakdown)
                
            }
        }
    }) { (error) in
        print(error.localizedDescription)
    }
}

func addCourseCategoryBreakdown(courseCategoryBreakdown: CourseCategoryBreakdown) {
    
    
    
    let courseCategoryBreakdownsRandomFirebaseID = self.ref.child("coursesCategoryBreakdowns").childByAutoId()
    
    let courseCategoryBreakdownsRandomFirebaseIDStringNeedsSubString = String(describing: courseCategoryBreakdownsRandomFirebaseID)
    
    //print(courseCategoryBreakdownsRandomFirebaseIDStringNeedsSubString)
    
    let courseCategoryBreakdownsRandomFirebaseIDString = courseCategoryBreakdownsRandomFirebaseIDStringNeedsSubString[66...]
    
    //assign this randomly generated firebase ID to an attribute of the person
    //so that it can be referenced in the "update" method
    courseCategoryBreakdown.firebaseRandomID = String(courseCategoryBreakdownsRandomFirebaseIDString)
    

    
    // define array of key/value pairs to store for this person.
    var courseCategoryBreakdowna: String = courseCategoryBreakdown.category
    let courseCategoryBreakdownRecord = [
        
        "firebaseRandomID": courseCategoryBreakdown.firebaseRandomID,
        "pk": String(courseCategoryBreakdown.pk),
        "peopleInCoursesID": String(courseCategoryBreakdown.peopleInCoursesID),
        "percentOfFinalGradeOfCategory": String(courseCategoryBreakdown.percentOfFinalGradeOfCategory),
        "category": String(courseCategoryBreakdowna)
        
    ]
    
    // Save to Firebase.
   /* self.ref.child("coursesCategoryBreakdowns").child(String("coursesCategoryBreakdown" + String(courseCategoryBreakdown.pk))).setValue(courseCategoryBreakdownRecord)
 */
    courseCategoryBreakdownsRandomFirebaseID.setValue(courseCategoryBreakdownRecord)
    
    // Also save to our internal array, to stay in sync with what's in Firebase.
    
    arrayOfCourseCategoryBreakdowns.append(courseCategoryBreakdown)
}



func updateCourseCategoryBreakdown(courseCategoryBreakdown: CourseCategoryBreakdown, newPercentOfFinalGradeOfCategory:Float, newCategory:String) {
    
    courseCategoryBreakdown.percentOfFinalGradeOfCategory = newPercentOfFinalGradeOfCategory
    courseCategoryBreakdown.category = newCategory
    
    
    //print(person.personID) //was 0 in the first app runthrough...then you load it and its 0
    let refToUpdate = self.ref.child("coursesCategoryBreakdowns").child(courseCategoryBreakdown.firebaseRandomID)
    
    
    refToUpdate.updateChildValues([
        "percentOfFinalGradeOfCategory": String(newPercentOfFinalGradeOfCategory),
        "category": newCategory
        
        ])
}
}



//an extension of the string class to allow the easy way of obtaining substrings used in the add____ methods throughout this DataStore (firebase) class
extension String {
    subscript(value: PartialRangeUpTo<Int>) -> Substring {
        get {
            return self[..<index(startIndex, offsetBy: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeThrough<Int>) -> Substring {
        get {
            return self[...index(startIndex, offsetBy: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeFrom<Int>) -> Substring {
        get {
            return self[index(startIndex, offsetBy: value.lowerBound)...]
        }
    }
}


