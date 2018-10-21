//
//  LoginViewController.swift
//  RowTime
//
//  Created by Paul Ventisei on 06/10/2018.
//  Copyright © 2018 Paul Ventisei. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func login(_ sender: Any) {
        //check that both the name and the password have been set
        if userName.isEqual(""), password.isEqual(""){
            //either password or username were not set so return without doing anything
            print("either password or username was not set")
        }else {
            // TODO call API to check the password and email are correct and if they are get the user details
            print("got to login check")
        }
        
    }
    
    
}
