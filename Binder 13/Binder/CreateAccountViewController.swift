//
//  CreateAccountViewController.swift
//  Binder
//
//  Created by Isaac on 3/26/18.
//  Copyright © 2018 The University of Texas at Austin. All rights reserved.
//


import UIKit
import CoreData

class CreateAccountViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.text = ""
        //PersistenceService.shared.fetchPeople()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if noErrors() && newAccount(){
            let index:Int = DataStore.shared.countOfPeople()
            
            //CREATE A PERSON HERE
            let thePersonCreated:People = People(username: usernameTextField.text!, password: passwordTextField.text!, personID: index, fontSize: "small", backgroundColor: "blue", firebaseRandomID: "")
            
            DataStore.shared.addPerson(person: thePersonCreated)
            
            //Opens connection to core data
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            //Creates new entity that will hold the information to be added to Core Data
            let entity = NSEntityDescription.entity(forEntityName: "PersonLoggedIn", in: managedContext)
            let personDM = NSManagedObject(entity: entity!, insertInto:managedContext)
            personDM.setValue(index, forKey: "personID")
            //Saves to core data
            do{
                try managedContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
            DataStore.shared.setIndexOfUserLoggedIn(_setValue: index)
            performSegue(withIdentifier: "ToTabController", sender: self)
//            performSegue(withIdentifier: "unwindToLogin", sender: self)
        }
    }
    
    func noErrors() -> Bool {
        var errorMessage:String = ""
        var noError:Bool = true
        if usernameTextField.text == "" || passwordTextField.text == "" || retypePasswordTextField.text == ""{
            errorMessage = "Enter both username and password"
            noError = false
        }else{
            if passwordTextField.text != retypePasswordTextField.text {
                errorMessage = "Passwords must match"
                noError = false
            }
        }
        errorLabel.text = errorMessage
        
        //the default settings are added for this user
        //Config.setUserBackgroundColor("blue")
        
        
        
        return noError
        
    }
    
    func newAccount() -> Bool {
        let count:Int = DataStore.shared.countOfPeople()
        let username:String = usernameTextField.text!
        
        if count > 0 { //only need to check if the username already exists if other accounts have been created
            //if you try and check when count is 0 youll get an index error
            //if no acounts have been created then you can instantly return true because it will be a new account
            for i in 0...count-1 {
                let person = DataStore.shared.getPerson(index: i)
                let gottenUsername:String = person.username
                if username == gottenUsername {
                    errorLabel.text = "Username already exists"
                    return false
                }
            }
        }
        
        return true
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
 
 
