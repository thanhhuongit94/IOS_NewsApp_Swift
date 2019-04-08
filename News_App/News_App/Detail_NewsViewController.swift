//
//  Detail_NewsViewController.swift
//  News_App
//
//  Created by huongnguyen on 20/11/2018.
//  Copyright © 2018 huongnguyen. All rights reserved.
//

import UIKit

class Detail_NewsViewController: UIViewController {
    //MARK: Variable
    var thamSoNews_ID = String()
    var arrayNews = NSMutableArray()
    var arrayNewsDuocluu = NSMutableArray()
    let columName = "news_id"
    var news_id : String = ""
    var screenSource : String = ""
    
    //MARK: Properties
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var imgNew: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // print("Man hinh 2: " + thamSoNews_ID)
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if screenSource == "TDL" {
            btnLike.isHidden = true
        }
        
        //Doi mau nen cho navigation item
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGray;
        
        //Doi font cho navigation item
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Times New Roman", size: 22)]
        //MARK: An tab
        self.tabBarController!.tabBar.isHidden = true
        arrayNews = NewsDAO().getDataNewsIntoKeyword(keyWord: thamSoNews_ID, colName: columName, "")
        var objectNew = Tbl_News()
        objectNew = arrayNews[0] as! Tbl_News
        news_id = objectNew.news_id
        
        lblDate.text = objectNew.datePost
        lblName.lineBreakMode = .byWordWrapping
        lblName.numberOfLines = 0
        lblName.autoresizesSubviews = true
        lblName.text = objectNew.news_name
        lblName.textColor = UIColor.black
        
        imgNew.image = objectNew.news_photo!
        
        lblContent.text = objectNew.news_content
        lblContent.backgroundColor = UIColor.white
    }
    @IBAction func btnLike(_ sender: UIButton) {
        
        //Chua dang nhap
        if User_Provider.username.isEmpty {
            let alert = UIAlertController(title: "Thông báo", message: "Hãy đăng nhập để có lưu lại tin tức!", preferredStyle: UIAlertController.Style.alert)
            //Nhan OK
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {action in
                //Day man hinh sua ra khoi navigation
                let sb = UIStoryboard(name: "Main", bundle: nil)
                //Khoi dong man hinh home luc khoi dong app
                let screenLogin = sb.instantiateViewController(withIdentifier: "sbLoginViewController") as! LoginViewController
                screenLogin.sourceScreen = "Details"
                self.navigationController?.pushViewController(screenLogin, animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        //lay du lieu
        let arrayUser = UsersDAO().getAllUsers(conditional: " WHERE username = '" + User_Provider.username + "'")
        var postNewsEnjoyToUpdate: String = ""
        
        //MARK: Luu tin
        //Nhan luu tin
        if btnLike.currentBackgroundImage == #imageLiteral(resourceName: "noSaveNews") {
            if let user = arrayUser[0] as? Tbl_Users {
                let newsEnjoy = user.getNewsEnjoy()//lay danh sach bai viet yeu thich
                
                var objectNew = Tbl_News()
                objectNew = arrayNews[0] as! Tbl_News
                news_id = objectNew.news_id

                for item in newsEnjoy {
                    if item == news_id {
                        let alert = UIAlertController(title: "Thông báo", message: "Tin tức đã được lưu!", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    postNewsEnjoyToUpdate += item + "&"
                }
                postNewsEnjoyToUpdate += news_id
            }
            
            btnLike.setBackgroundImage(#imageLiteral(resourceName: "saveNews"), for: .normal)
            //Kiem tra bai viet da duoc luu chua
            print("Luu tin")
            UsersDAO().updateNewsEnjoy(newsEnjoy: postNewsEnjoyToUpdate, username: User_Provider.username)
        } else {
            btnLike.setBackgroundImage(#imageLiteral(resourceName: "noSaveNews"), for: .normal)
            if let user = arrayUser[0] as? Tbl_Users {
                let newsEnjoy = user.getNewsEnjoy()//lay danh sach bai viet yeu thich
                
                var objectNew = Tbl_News()
                objectNew = arrayNews[0] as! Tbl_News
                news_id = objectNew.news_id
                
                for item in newsEnjoy {
                    if item != news_id && item != ""{
                        postNewsEnjoyToUpdate += item + "&"
                    }
                }
            }
            print("Khong luu tin")
            UsersDAO().updateNewsEnjoy(newsEnjoy: postNewsEnjoyToUpdate, username: User_Provider.username)
        }
    }
}
