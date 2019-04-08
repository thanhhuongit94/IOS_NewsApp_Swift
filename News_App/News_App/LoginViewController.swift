//
//  LoginViewController.swift
//  News_App
//
//  Created by huongnguyen on 22/11/2018.
//  Copyright © 2018 huongnguyen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    //MARK: Properties
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var viewLogin: UIView!
    
    var sourceScreen : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.tabBarController!.tabBar.isHidden = false//MARK: Hien thi lai tabbar
        view.backgroundColor = UIColor.white
        
        //Border view login
        self.viewLogin.layer.borderWidth = 0.5
        self.viewLogin.layer.cornerRadius = 30
        
        //Delegate for textfield
        txtEmail.delegate = self
        txtPassword.delegate = self
        
        //Doi mau nen cho navigation item
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGray;
        
        //Doi font cho navigation item
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Times New Roman", size: 22)]
    }

    //MARK: Definition of action
    @IBAction func loginButtonTapped(_ sender: UIButton) {       
        let username = txtEmail.text
        let password = txtPassword.text
        
        //Kiem tra nguoi dung nhap du lieu
        if username!.isEmpty{
            let alert = UIAlertController(title: "Thông báo", message: "Bạn chưa nhập tài khoản!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        if password!.isEmpty{
            let alert = UIAlertController(title: "Thông báo", message: "Bạn chưa nhập mật khẩu!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
//        print("Login button")
        //Kiem tra dang nhap
        let userItem : Tbl_Users = Tbl_Users()
        let item : Tbl_Users = UsersDAO().checkLogin(username!, password!) //lay du lieu tu csdl
        if  !item.username.isEmpty {
            
            User_Provider.username = username!
            if sourceScreen == "Details" {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                //Khoi dong man hinh tuong ung khi login thanh cong
                let details = sb.instantiateViewController(withIdentifier: "sbDetail_NewsViewController") as! Detail_NewsViewController
//                txtEmail.text = ""
//                txtPassword.text = ""
                //Khoi dong man hinh cua file quan tri AdminViewController
                self.navigationController?.popViewController(animated: true)
                return
            }
            
            //Login successfull
            let sb = UIStoryboard(name: "Main", bundle: nil)
            //Khoi dong man hinh tuong ung khi login thanh cong
            let manhinhMenu = sb.instantiateViewController(withIdentifier: "sbAdminViewController") as! AdminViewController
           //let manhinhMenu = sb.instantiateViewController(withIdentifier: "sbTabMain_Controller") as! TabMain_Controller
            
            txtEmail.text = ""
            txtPassword.text = ""
            manhinhMenu.checkScreen = "LoginScreen"
            //Khoi dong man hinh cua file quan tri AdminViewController   
            self.navigationController?.pushViewController(manhinhMenu, animated: true)
            
        } else {
            let alert = UIAlertController(title: "Thông báo", message: "Sai tài khoản hoặc mật khẩu!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //Quay lai man hinh chinh luc khoi dong app
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.tabBarController?.tabBar.isHidden = false //mo lai tabbar
        if sourceScreen == "Details" {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            //Khoi dong man hinh tuong ung khi login thanh cong
            let details = sb.instantiateViewController(withIdentifier: "sbDetail_NewsViewController") as! Detail_NewsViewController
            //                txtEmail.text = ""
            //                txtPassword.text = ""
            //Khoi dong man hinh cua file quan tri AdminViewController
            self.navigationController?.popViewController(animated: true)
            return
        }
        let sb = UIStoryboard(name: "Main", bundle: nil)
        //Khoi dong man hinh home luc khoi dong app
        let home = sb.instantiateViewController(withIdentifier: "sbTabMain_Controller") as! TabMain_Controller
        self.present(home, animated: true)
    }
    
    //Dang ky tai khoan moi
    @IBAction func registerAccountButtonTapped(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        //Khoi dong man hinh home luc khoi dong app
        let home = sb.instantiateViewController(withIdentifier: "sbRegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(home, animated: true)
    }
    
    //Bat su kien cho textfield khi ket thuc nhap du lieu
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        return true
    }
}
