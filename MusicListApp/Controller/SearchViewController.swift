//
//  SearchViewController.swift
//  MusicListApp
//
//  Created by Manabu Kuramochi on 2021/03/26.
//

import UIKit
import PKHUD
import Alamofire
import SwiftyJSON
import DTGradientButton
import Firebase
import FirebaseAuth
import ChameleonFramework


class SearchViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    
    var artistNameArray = [String]()
    var musicNameArray = [String]()
    var previewURLArray = [String]()
    var imageStringArray = [String]()
    var userID = String()
    var userName = String()
    var autoID = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: "autoID") != nil {
            
            
            autoID = UserDefaults.standard.object(forKey: "autoID") as! String
            print(autoID)
            
        }else {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(identifier: "LoginViewController")
            
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true, completion: nil)
            
        }
        
        if UserDefaults.standard.object(forKey: "userID") != nil && UserDefaults.standard.object(forKey: "userName") != nil {
            
            userID = UserDefaults.standard.object(forKey: "userID") as! String
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
        
        
        searchTextField.delegate = self
        searchTextField.becomeFirstResponder()
        
        //Buttonのグラデーション
        favButton.setGradientBackgroundColors([UIColor(hex:"E21F70"), UIColor(hex:"FF4D2C")], direction: .toBottom, for: .normal)
        
        listButton.setGradientBackgroundColors([UIColor(hex:"FF8960"), UIColor(hex:"FF62A5")], direction: .toBottom, for: .normal)
        

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //navigationBarのbackButtonを消す
        
        
        //Barの色
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor.flatRed()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //searchを行う
        
        textField.resignFirstResponder()
        return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        searchTextField.resignFirstResponder()
        
    }
    
    
    @IBAction func moveToSelectCardView(_ sender: Any) {
        
        //parseを実行
        startParse(keyword: searchTextField.text!)
        
        
        
    }
    
    
    func moveToCard() {
        
        performSegue(withIdentifier: "selectVC", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if searchTextField.text != nil && segue.identifier == "selectVC" {
            
            let selectVC = segue.destination as! SelectViewController
            selectVC.artistNameArray = self.artistNameArray
            selectVC.imageStringArray = self.imageStringArray
            selectVC.musicNameArray = self.musicNameArray
            selectVC.previewURLArray = self.previewURLArray
            selectVC.userID = self.userID
            selectVC.userName = self.userName
            
        }
        
        
    }
    
    func startParse(keyword:String) {
        
        HUD.show(.progress)
        imageStringArray = [String]()
        previewURLArray = [String]()
        artistNameArray = [String]()
        musicNameArray = [String]()
        
        let urlString = "https://itunes.apple.com/search?term=\(keyword)&country=jp"
        let encodeUrlString:String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        AF.request(encodeUrlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{(response) in
            
            print(response)
            
            switch response.result {
            
            case .success:
                
                let json:JSON = JSON(response.data as Any)
                var resultCount:Int = json["resultCount"].int!
                
                for i in 0 ..< resultCount {
                    
                    var artWorkUrl = json["results"][i]["artworkUrl60"].string
                    let previewUrl = json["results"][i]["previewUrl"].string
                    let artistName = json["results"][i]["artistName"].string
                    let trackCensoredName = json["results"][i]["trackCensoredName"].string
                    
                    
                    if let range = artWorkUrl?.range(of: "60×60bb") {
                        
                        artWorkUrl?.replaceSubrange(range, with: "320×320bb")
                    }
                    
                    self.imageStringArray.append(artWorkUrl!)
                    self.previewURLArray.append(previewUrl!)
                    self.artistNameArray.append(artistName!)
                    self.musicNameArray.append(trackCensoredName!)
                    
                    if self.musicNameArray.count == resultCount {
                        
                        //カード画面へ遷移
                        self.moveToCard()
                        
                        
                    }
                    
                }
                HUD.hide()
                
            case .failure(let error):
                
                print(error)
            
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
