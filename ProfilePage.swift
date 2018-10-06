//
//  ProfileViewController.swift
//  register
//
//  Created by MacBook Air on 26.06.2018.
//  Copyright © 2018 Deniz Cakmak. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ProfileViewController:UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    let URL_USER_UPDATE = "your_api.com"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldBirthday: UITextField!
    @IBOutlet weak var textFieldGender: UITextField!
    @IBOutlet weak var testPhoto: UITextField!    
    
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        let ViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(ViewController, animated: true)
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func Update(_ sender: Any) {
        
        let parameters: Parameters=[
            
            "first_name":textFieldFirstName.text!,
            "last_name":textFieldLastName.text!,
            "gender":textFieldGender.text!,
            "phone":textFieldPhone.text!,
            ]
        
        let headers: HTTPHeaders=[
            
            "auth-token":MyVariables.auth_token!
        ]
        
        let imgData = imageView.image!.jpegData(compressionQuality: 0.2)!
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "profile_picture",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:URL_USER_UPDATE,headers:headers)
        { (result) in
            switch result {
            case .success(let upload, _, _):
            upload.responseJSON { response in
                    print(response)
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
        let myAlert = UIAlertController(title: "Success", message: "Updated.", preferredStyle: UIAlertController.Style.alert);
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { action in
            self.dismiss(animated: true, completion: nil);
            
        }
        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion: nil);
      
        
    }
    
    
    @IBAction func selectPhoto(_ sender: Any) {
     
        let ImagePicker = UIImagePickerController()
        ImagePicker.delegate = self
        ImagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(ImagePicker, animated: true, completion: nil)

    }
    
    func imagePickerController( _ picker: UIImagePickerController,didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any] )
    {

let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        imageView.image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headers: HTTPHeaders=[
            
            "auth-token":MyVariables.auth_token!
        ]
        
        Alamofire.request(URL_USER_UPDATE, method: .get, headers: headers).responseJSON
            {
                response in
                print(response)
                let result = response.result.value
                let jsonData = result as! NSDictionary
              
                
                self.textFieldFirstName.text = jsonData.value(forKey: "first_name") as? String
                self.textFieldLastName.text = jsonData.value(forKey: "last_name") as? String
                self.textFieldEmail.text = jsonData.value(forKey: "email") as? String
                self.textFieldPhone.text = jsonData.value(forKey: "phone") as? String
                self.textFieldGender.text = jsonData.value(forKey: "gender") as? String
                self.testPhoto.text = jsonData.value(forKey: "profile_picture_url") as? String
               
                do {
                    let url = URL(string: self.testPhoto.text!)
                    if(url != nil){
                    let data = try Data(contentsOf: url!)
                    self.imageView.image = UIImage(data: data)
                    }
                }
                catch{
                    print(error)
                }
                
        } //end alamofire
  
        
    } //end view did load
    

