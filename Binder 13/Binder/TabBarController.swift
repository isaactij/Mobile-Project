//
//  TabBarController.swift
//  Binder
//
//  Created by Brandon Kerbow on 5/3/18.
//  Copyright © 2018 The University of Texas at Austin. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    var unwind:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if unwind {
            performSegue(withIdentifier: "unwindToLogin", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToTab(segue: UIStoryboardSegue){}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
