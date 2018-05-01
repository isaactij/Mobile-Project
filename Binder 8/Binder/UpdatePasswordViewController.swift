//
//  UpdatePasswordViewController.swift
//  Binder
//
//  Created by Brandon Kerbow on 3/26/18.
//  Copyright © 2018 The University of Texas at Austin. All rights reserved.
//

import UIKit

class UpdatePasswordViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var oldPasswordLabel: UILabel!
    @IBOutlet weak var newPasswordLabel: UILabel!
    @IBOutlet weak var confirmNewPasswordLabel: UILabel!
    
    @IBOutlet weak var uddateButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var usernameEntry: UITextField!
    @IBOutlet weak var oldPasswordEntry: UITextField!
    @IBOutlet weak var newPasswordEntry: UITextField!
    @IBOutlet weak var confirmNewPasswordEntry: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting the background color and font sizes of this
        //VC based on user default settings
        //see the SettingsViewController and also Config
        //classes for more info
        
        checkBackgroundColorAndFontSize()
        


        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //also want to set these user defaults every time the view loads
        
        //set the background color and make sure the segmenetd control is on the right spot
        checkBackgroundColorAndFontSize()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //updating the users password
    
    //TO DO: make this actually work, right now it doesnt
    //for some unknown reason
    @IBAction func updateButtonPressed(_ sender: Any) {
        var indexOfPersonToUpdateInfoFor = 0
        var usernameIsAUser = false
        var oldPasswordIsCorrect = false
        for i in 0...DataStore.shared.countOfPeople() - 1 {
            if DataStore.shared.getPerson(index: i).username == usernameEntry.text {
                usernameIsAUser = true
                
                if DataStore.shared.getPerson(index: i).password == oldPasswordEntry.text {
                    oldPasswordIsCorrect = true
                    indexOfPersonToUpdateInfoFor = i
                    
                }
                
            }
        }
        
        let newPasswordsmatch = newPasswordEntry.text == confirmNewPasswordEntry.text
        
        
        if (usernameIsAUser && oldPasswordIsCorrect && newPasswordsmatch) {
            //update this users password

            DataStore.shared.updatePerson(
                person: (DataStore.shared.getPerson(index: indexOfPersonToUpdateInfoFor)),
                newPassword: newPasswordEntry.text!,
                newBackgroundColor: DataStore.shared.getPerson(index: indexOfPersonToUpdateInfoFor).backgroundColor,
                newFontSize: DataStore.shared.getPerson(index: indexOfPersonToUpdateInfoFor).fontSize
            )

            
            
            
            
            messageLabel.text = "Password successfully changed."
            
            
        } else {
            messageLabel.text = "Update failed. Please double check your inputs."
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func checkBackgroundColorAndFontSize() {
        
        if DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).backgroundColor == "blue" {
            self.view.backgroundColor = UIColor.cyan
        } else {
            self.view.backgroundColor = UIColor.white
        }
        
        //set font sizes
        if DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).fontSize == "small" {
            uddateButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            usernameLabel.font = UIFont.systemFont(ofSize: 15.0)
            oldPasswordLabel.font = UIFont.systemFont(ofSize: 15.0)
            newPasswordLabel.font = UIFont.systemFont(ofSize: 15.0)
            confirmNewPasswordLabel.font = UIFont.systemFont(ofSize: 15.0)
            messageLabel.font = UIFont.systemFont(ofSize: 15.0)
            usernameEntry.font = UIFont.systemFont(ofSize: 15.0)
            oldPasswordEntry.font = UIFont.systemFont(ofSize: 15.0)
            newPasswordEntry.font = UIFont.systemFont(ofSize: 15.0)
            confirmNewPasswordEntry.font = UIFont.systemFont(ofSize: 15.0)
            
            
        } else {
            uddateButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            usernameLabel.font = UIFont.systemFont(ofSize: 20.0)
            oldPasswordLabel.font = UIFont.systemFont(ofSize: 20.0)
            newPasswordLabel.font = UIFont.systemFont(ofSize: 20.0)
            confirmNewPasswordLabel.font = UIFont.systemFont(ofSize: 20.0)
            messageLabel.font = UIFont.systemFont(ofSize: 20.0)
            usernameEntry.font = UIFont.systemFont(ofSize: 20.0)
            oldPasswordEntry.font = UIFont.systemFont(ofSize: 20.0)
            newPasswordEntry.font = UIFont.systemFont(ofSize: 20.0)
            confirmNewPasswordEntry.font = UIFont.systemFont(ofSize: 20.0)
            
        }
    }

}
