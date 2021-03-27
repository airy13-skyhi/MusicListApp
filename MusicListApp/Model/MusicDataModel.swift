//
//  MusicDataModel.swift
//  MusicListApp
//
//  Created by Manabu Kuramochi on 2021/03/27.
//

import Foundation
import Firebase
import PKHUD

class MusicDataModel {
    
    
    var artistName:String! = ""
    var musicName:String! = ""
    var preViewURL:String! = ""
    var imageString:String! = ""
    var userID:String! = ""
    var userName:String! = ""
    var artistViewUrl:String! = ""
    let ref:DatabaseReference!
    
    var key:String! = ""
    
    //外部データを取り込む
    init(artistName:String, musicName:String, preViewURL:String, imageString:String, userID:String, userName:String) {
        
        self.artistName = artistName
        self.musicName = musicName
        self.preViewURL = preViewURL
        self.imageString = imageString
        self.userID = userID
        self.userName = userName
        
        //ログインの時、拾えるuidを先頭につけて送信　受診する時もuidから引っ張る
        ref = Database.database().reference().child("users").child(userID).childByAutoId()
    }
    
    //DataSnapshotと引き換えに値を取っていく
    init(snapshot:DataSnapshot) {
        
        ref = snapshot.ref
        if let value = snapshot.value as? [String:Any] {
            
            artistName = value["artistName"] as? String
            musicName = value["musicName"] as? String
            preViewURL = value["preViewURL"] as? String
            imageString = value["imageString"] as? String
            userID = value["userID"] as? String
            userName = value["userName"] as? String
            
            
            
            
        }
        
        
    }
    
    
    func toContents() -> [String:Any] {
        
        return ["artistName":artistName!, "musicName":musicName!, "preViewURL":preViewURL!, "imageString":imageString!, "userID":userID!, "userName":userName!]
        
    }
    
    
    func save() {
        
        ref.setValue(toContents())
        
    }
    
    
}


