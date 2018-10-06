//
//  RegisterViewController.swift
//  register
//
//  Created by MacBook Air on 29.06.2018.
//  Copyright © 2018 Deniz Cakmak. All rights reserved.
//

import Alamofire
import UIKit

class RegisterViewController: UIViewController {
    
    let URL_USER_REGISTER = "your_api.com"
 
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldLastname: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
  
    
    @IBAction func RegisterButton(_ sender: Any) {
        
        let parameters: Parameters=[
             "email":textFieldEmail.text!,
             "password":textFieldPassword.text!,
             "first_name":textFieldName.text!,
             "last_name":textFieldLastname.text!,
            ]
        
        if ((textFieldName.text?.isEmpty)! || (textFieldName.text?.isEmpty)! || (textFieldLastname.text?.isEmpty)! || (textFieldPassword.text?.isEmpty)!) {
            
            displayMyAlertMessage(userMessage: "Fill all informations.");
            return;
            
        }
        else if((textFieldPassword.text?.count)! < 6){
            
            displayMyAlertMessage(userMessage: "Password must be six or more character");
            return;
        }
        
        Alamofire.request(URL_USER_REGISTER, method: .post,   parameters:parameters).responseJSON
            {
                response in
                print(response)
                
                if let result = response.result.value {
                    
                    _ = result as! NSDictionary
                    
            
                }
        }
        let myAlert = UIAlertController(title: "Succesful", message: "User added.", preferredStyle: UIAlertController.Style.alert);
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { action in
            self.dismiss(animated: true, completion: nil);
            
        }
        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion: nil);
    }
    
   
    @IBAction func backLogin(_ sender: Any) {
        
        let backLoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(backLoginViewController, animated: true)
        self.dismiss(animated: false, completion: nil)
    }
    
    func displayMyAlertMessage(userMessage:String)
    {
        
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertController.Style.alert);
        let okAction = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil);
        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion: nil);
        
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
