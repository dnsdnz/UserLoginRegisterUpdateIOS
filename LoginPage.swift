//
//  ViewController.swift
//  register
//
//  Created by MacBook Air on 14.06.2018.
//  Copyright © 2018 Deniz Cakmak. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate {
    
    let URL_USER_LOGIN = "your_api.com"
    
    @IBOutlet weak var login_email: UITextField!
    @IBOutlet weak var login_password: UITextField!
    
    
    @IBAction func register(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let RegisterViewController = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.present(RegisterViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func buttonLogin(_ sender: Any) {
  
        let parameters: Parameters=[
            
            "email" : login_email.text!,
            "password" : login_password.text!
            
        ]
        
        if ((login_email.text?.isEmpty)! || (login_password.text?.isEmpty)!) {
            
            displayMyAlertMessage(userMessage: "Fill all informations");
            return;
            
        }
        else {
            Alamofire.request(URL_USER_LOGIN, method: .post, parameters: parameters).responseJSON
                {
                    response in
                    print(response)
                    
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        
                        if(!(jsonData.value(forKey: "status") as! Bool))
                        {
                            self.displayMyAlertMessage(userMessage: "Wrong password or username.");
                            return;
                        }
                        else
                        {
                            
                        MyVariables.auth_token = jsonData.value(forKey: "auth-token") as? String
                       
                            if let tabbar = (self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as? UITabBarController) {
                                self.present(tabbar, animated: true, completion: nil)
                            }
                        }
                    }
                    
            }   //end alamofire request

        }
    }
    
   
   
        func displayMyAlertMessage(userMessage:String) {
            
            let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertController.Style.alert);
            let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil);
            
            myAlert.addAction(okAction);
            self.present(myAlert, animated: true, completion: nil);
            
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
    }

}

