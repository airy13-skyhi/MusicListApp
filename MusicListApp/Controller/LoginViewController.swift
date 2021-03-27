//
//  LoginViewController.swift
//  MusicListApp
//
//  Created by Manabu Kuramochi on 2021/03/26.
//

import UIKit
import Firebase
import FirebaseAuth
import DTGradientButton

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
        //buttonの背景色
        loginButton.setGradientBackgroundColors([UIColor(hex:"E21F70"), UIColor(hex:"FF4D2C")], direction: .toBottom, for: .normal)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    
    @IBAction func login(_ sender: Any) {
        
        //もしtextFieldの値が空でない場合
        if textField.text?.isEmpty != true {
            
            //textFieldの値(ユーザー名)をアプリ内保存
            UserDefaults.standard.set(textField.text, forKey: "userName")
            
            //空ならば振動させる UIKit
        }else {
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            print("振動")
            
            
        }
        
        
        Auth.auth().signInAnonymously { (result, error) in
            
            if error == nil {
                
                guard let user = result?.user else { return }
                
                let userID = user.uid
                UserDefaults.standard.set(userID, forKey: "userID")
                
                //DBにuserID,textFieldを入れる
                let saveProfile = SaveProfile(userID: userID, userName: self.textField.text!)
                saveProfile.saveProfile()
                self.dismiss(animated: true, completion: nil)
                
            }else {
                
                
                print(error?.localizedDescription as Any)
                
                //アラート
                
            }
            
            
            
            
        }
        
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
