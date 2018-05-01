//
//  SettingsViewController.swift
//  Binder
//
//  Created by Brandon Kerbow on 3/25/18.
//  Copyright © 2018 The University of Texas at Austin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var updatePasswordButton: UIButton!
    @IBOutlet weak var backgroundColorSegmentedControl: UISegmentedControl!
    @IBOutlet weak var fontSizeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var backgroundColorText: UILabel!
    @IBOutlet weak var fontSizeText: UILabel!
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        checkBackgroundColorAndFontSize()
        
       

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
       checkBackgroundColorAndFontSize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func updatePasswordButtonPressed(_ sender: Any) {
        
    }
    
    
    @IBAction func backgrondColorSegmentedControlPressed(_ sender: Any) {
        
        let theStringWithinTheSegmentedControlThatIsCurrentlySelected = backgroundColorSegmentedControl.titleForSegment(at: backgroundColorSegmentedControl.selectedSegmentIndex)!
        
        if theStringWithinTheSegmentedControlThatIsCurrentlySelected == "Blue" {
            //when the user selects blue on the segmented control, alter
            //their user defaults to be a blue background color
         
            //print(DataStore.shared.getIndexOfUserLoggedIn())
            DataStore.shared.updatePerson(
                                          person: (DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn())),
                                        
                                          newPassword: DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).password,
                                          newBackgroundColor: "blue",
                                          newFontSize: DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).fontSize
                                            )
            
        } else {
            //the other segmented control option is white
           
            DataStore.shared.updatePerson(
                person: (DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn())),
                newPassword: DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).password,
                newBackgroundColor: "white",
                newFontSize: DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).fontSize
            )
        }
        
        //once the color value is set in core data, update this VC's color
        if DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).backgroundColor == "blue" {
            self.view.backgroundColor = UIColor.cyan
        } else {
            self.view.backgroundColor = UIColor.white
        }
    }
    
    //same idea for setting the font size
    @IBAction func fontSizeSegmentedControlPressed(_ sender: Any) {
        
        let theStringWithinTheSegmentedControlThatIsCurrentlySelected = fontSizeSegmentedControl.titleForSegment(at: fontSizeSegmentedControl.selectedSegmentIndex)!
        
        if theStringWithinTheSegmentedControlThatIsCurrentlySelected == "small" {
           //if the user picks small font then set everything to size 15
            //in this VC and save their user default setting as small
            
            DataStore.shared.updatePerson(
                person: (DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn())),
                newPassword: DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).password,
                newBackgroundColor: DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).backgroundColor,
                newFontSize: "small"
            )
            
            
            updatePasswordButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            backgroundColorText.font = UIFont.systemFont(ofSize: 15.0)
            fontSizeText.font = UIFont.systemFont(ofSize: 15.0)
    
            
        } else {
            //the other option on the segmented control is large font
            DataStore.shared.updatePerson(
                person: (DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn())),
                newPassword: DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).password,
                newBackgroundColor: DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).backgroundColor,
                newFontSize: "large"
            )
            
            updatePasswordButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            backgroundColorText.font = UIFont.systemFont(ofSize: 20.0)
            fontSizeText.font = UIFont.systemFont(ofSize: 20.0)
          
        }
        
    }
    
    func checkBackgroundColorAndFontSize() {
        
        //set background color based on user defaults
        if DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).backgroundColor  == "blue" {
            self.view.backgroundColor = UIColor.cyan
            backgroundColorSegmentedControl.selectedSegmentIndex = 0
        } else {
            self.view.backgroundColor = UIColor.white
            backgroundColorSegmentedControl.selectedSegmentIndex = 1
        }
        
        
        //set font sizes based on user defaults
        if  DataStore.shared.getPerson(index: DataStore.shared.getIndexOfUserLoggedIn()).fontSize == "small" {
            updatePasswordButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            backgroundColorText.font = UIFont.systemFont(ofSize: 15.0)
            fontSizeText.font = UIFont.systemFont(ofSize: 15.0)
            fontSizeSegmentedControl.selectedSegmentIndex = 0
        } else {
            updatePasswordButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
            backgroundColorText.font = UIFont.systemFont(ofSize: 20.0)
            fontSizeText.font = UIFont.systemFont(ofSize: 20.0)
            fontSizeSegmentedControl.selectedSegmentIndex = 1
        }
        
    }

        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    */
    
}

