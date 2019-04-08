//
//  ChangePasswordView.swift
//  News_App
//
//  Created by huongnguyen on 07/12/2018.
//  Copyright © 2018 huongnguyen. All rights reserved.
//

import UIKit

class ChangePasswordView: UIView {
    
    //MARK: Properties
    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var txtOldPass: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    
    var tagAlert : Int = -1
    var tagOK : Int = -1
    var tagModifyOrDelete : Int = 1
    
    //MARK: Action
    //Luu du lieu thay doi
    func btnSave(_ sender: UIButton) {
        if User_Provider().checkSpaceInString(string: txtNewPass.text!) {
            tagAlert = 5
            return
        }
        
        if txtNewPass.text!.count < 6{
            tagAlert = 0
            return
        }
        
        //Kiem tra mat khau xac nhan co trung khop khong
        if txtConfirmPass.text != txtNewPass.text {
            tagAlert = 1
            return
        }
        
        //Lay mat khau cua user dang dang nhap so sanh xem co trung khop voi mat khau nguoi dung nhap khong
        let conditional = " WHERE username = '"+User_Provider.username+"'"
        var arrayUser = UsersDAO().getAllUsers(conditional: conditional)
        var object = arrayUser.object(at: 0) as! Tbl_Users
        
        if EncryptPassword().encryptPass(password: txtOldPass.text!) != object.password {
            tagAlert = 2
            return
        }
        if EncryptPassword().encryptPass(password: txtNewPass.text!) == object.password {
            tagAlert = 3
            return
        }
        tagAlert = 4
    }
}

