//
//  LoginViewController.swift
//  Binder
//
//  Created by Isaac on 3/26/18.
//  Copyright © 2018 The University of Texas at Austin. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    var personLoggedIn = [NSManagedObject]()
    var personIDDM = -1
    
    @IBOutlet weak var imgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Login Logo
        imgView.image = UIImage(named:"binderLogo.png")
        imgView.contentMode = UIViewContentMode.scaleAspectFit
        
        DataStore.shared.loadPeople()
        DataStore.shared.loadAssignments()
        DataStore.shared.loadCourses()
        DataStore.shared.loadPeopleInCourses()
        DataStore.shared.loadTasks()
        DataStore.shared.loadCourseCategoryBreakdowns()
        errorLabel.text = ""
        //checkLogin()
        
        
    }
    
    func checkLogin(){
        //Opens connection to core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        //Gets the info stored in core data
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"PersonLoggedIn")
        var fetchedResults:[NSManagedObject]? = nil
        do{
            try fetchedResults = managedContext.fetch(fetchRequest) as? [NSManagedObject]
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        if let results = fetchedResults {
            personLoggedIn = results
        } else{
            print("Could not fetch")
        }
        if personLoggedIn.count > 0 {
            let person = personLoggedIn[0]
            let personID:Int = (person.value(forKey: "personID") as? Int)!
                if(personID != -1){
                    personLoggedIn[0].setValue(personID, forKey: "personID")
                    personIDDM = personID
                        performSegue(withIdentifier: "tabBarControllerSegue", sender: nil)
                    }
                }
        }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(_ sender: Any) {
        //DataStore.shared.loadPeople() //shouldnt be necesary ?
        if fieldsFilled() {
            if credentialsCorrect() {
                performSegue(withIdentifier: "tabBarControllerSegue", sender: nil)
                //this sets the name of the user in the user defaults (user defaults is wrapped in the config class)
                
                //Config.specifyUsername(usernameTextField.text!)
            }
        }
    }
    
    func credentialsCorrect() -> Bool {
        let givenUsername = usernameTextField.text
        let givenPassword = passwordTextField.text
        let count = DataStore.shared.countOfPeople()
        
        if count > 0 { //because if no accounts are present then this would return an index error
                //if no accounts are present then any credentials typed in will be wrong
            //print("sdfhsdfsdjkfhsjkdhfsdjkfhsdjkf")
            //print(count)
            for i in 0...count-1{
                let person = DataStore.shared.getPerson(index: i)
                if person.username == givenUsername {
                    if person.password == givenPassword {
                        DataStore.shared.setIndexOfUserLoggedIn(_setValue: i) //this is the user logged in
                        //print(DataStore.shared.getPerson(index: i).personID)
                        return true
                    }
                }

            }
        }
        
        
        
        errorLabel.text = "Username or Password is incorrect"
        return false
    }
    
    func fieldsFilled() -> Bool{
        if usernameTextField.text == "" || passwordTextField.text == "" {
            errorLabel.text = "Enter both username and password"
            return false
        }else {
            return true
        }
    }

    @IBAction func unwindToLogIn(segue: UIStoryboardSegue){}
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tabBarControllerSegue" {
            if let destination = segue.destination as? SettingsViewController {
                destination.sentPersonID = personIDDM
            }
        }
    }
    

}
