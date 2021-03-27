//
//  SaveProfile.swift
//  MusicListApp
//
//  Created by Manabu Kuramochi on 2021/03/26.
//

import Foundation
import Firebase
import PKHUD


class  SaveProfile {
    
    //サーバーに値を飛ばす
    var userID:String! = ""
    var userName:String! = ""
    var ref:DatabaseReference!
    
    init(userID:String, userName:String) {
        
        self.userID = userID
        self.userName = userName
        
        //ログインの時に拾えるuidを先頭につけ送信。受信時もuidから引っ張ってくる childByAutoId
        ref = Database.database().reference().child("profile").childByAutoId()
        
        
    }
    
    init(snapShot:DataSnapshot) {
        
        ref = snapShot.ref
        if let value = snapShot.value as? [String:Any] {
            
            userID = value["userID"] as? String
            userName = value["userName"] as? String
            
            
        }
        
    }
    
    //外部から持ってきた値　userID,userName
    func toContents() -> [String:Any] {
        
        return ["userID":userID!, "userName":userName as Any]
        
    }
    
    func saveProfile() {
        
        //userID,userNameを値として保存
        ref.setValue(toContents())
        UserDefaults.standard.set(ref.key, forKey: "autoID")
        
    }
    
    
}

