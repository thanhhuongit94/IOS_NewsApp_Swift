//
//  UserAddView.swift
//  News_App
//
//  Created by huongnguyen on 03/12/2018.
//  Copyright © 2018 huongnguyen. All rights reserved.
//

import UIKit

class UserAddView: UIView{
    
    //MARK: Properties
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var lblHeader: UILabel!
    
    var tagAlert : Int = -1
    var tagAddOrModify : Int = 1//Them du lieu
    var tagOK : Int = 1
    var oldPass : String?
    
    //MARK: Action
    //Luu du lieu khi insert vao CSDL
    func btnSaveData(_ sender: UIButton) {
        //Lay du lieu
        //Kiem tra du lieu duoc nhap chua
        if txtUsername.text!.count < 6 {
            tagAlert = 0
            return
        }
        
        if User_Provider().checkSpaceInString(string: txtPassword.text!) {
           tagAlert = 9
            return
        }
        
        if txtPassword.text!.count < 6{
            tagAlert = 1
            return
        }
        
        //Kiem tra mat khau xac nhan co trung khop khong
        if txtConfirmPass.text != txtPassword.text {
            tagAlert = 2
            return
        }
        
        if txtName.text!.count < 1 || txtName.text == " "{
            tagAlert = 3
            return
        }
        
        if txtAddress.text!.count < 2 {
            tagAlert = 4
            return
        }
        
        //Kiem tra truoc khi insert
        var user : Tbl_Users = Tbl_Users()
        user.username = txtUsername.text!
        
        user.password = EncryptPassword().encryptPass(password: txtPassword.text!)
        user.name = txtName.text!
        user.address = txtAddress.text!
        
        //Kiem tra khoang trang trong ten tai khoan
        if User_Provider().checkSpaceInString(string: txtUsername.text!) {
            tagAlert = 6
            return
        }
        //Them/sua du lieu
        if tagAddOrModify == 1 {
            //Insert du lieu
            //Kiem tra tai khoan da ton tai chua
            if User_Provider().checkUsernameIsExists(username: txtUsername.text!){
                tagAlert = 5
                return
            } else {
                if UsersDAO().insertNewUser(user: user) {
                    tagAlert = 7
                    
                    //Add quyen cho username
                    let Permission : Tbl_Permission = Tbl_Permission()
                    var arrayMenu : [String] = ["LO", "CSTT", "DMK", "TDL", "QLBVCT"]//chua mang menu thuoc username
                    var arrayPermission : [String] = ["F", "V&M" , "M", "D&V", "A&D&M"] //Mang chua quyen theo menu
                    for i in 0...arrayMenu.count - 1 {
                        PermissionDAO().insertNewPermission(username: user.username, menuID: arrayMenu[i], permission: arrayPermission[i])
                    }
                    
                    //Resets
                    txtUsername.text = ""
                    txtName.text = ""
                    txtPassword.text = ""
                    txtConfirmPass.text = ""
                    txtAddress.text = ""
                }
            }
        }
        else {//Sua thong tin
            tagAlert = 8
        }
        
    }
    
}
