//
//  RegisterViewController.swift
//  News_App
//
//  Created by huongnguyen on 26/11/2018.
//  Copyright © 2018 huongnguyen. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate{
    //MARK : Properties
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    
    //MARK: Variable
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegate
        txtAddress.delegate = self
        txtName.delegate = self
        txtConfirmPassword.delegate = self
        txtPassword.delegate = self
        txtUsername.delegate = self

    }
    
    //MARK: Definition of Action
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hidden keyboard
        txtAddress.resignFirstResponder()
        txtName.resignFirstResponder()
        txtUsername.resignFirstResponder()
        txtPassword.resignFirstResponder()
        txtConfirmPassword.resignFirstResponder()
        return true
    }

    
    //Huy dang ky
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        //Khoi dong man hinh home luc khoi dong app
        let home = sb.instantiateViewController(withIdentifier: "sbLoginViewController") as! LoginViewController
       self.navigationController?.popViewController(animated: true)
    }
    
    //Nhan quay lai dang nhap
    @IBAction func backLoginButtonTapped(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        //Khoi dong man hinh home luc khoi dong app
        let home = sb.instantiateViewController(withIdentifier: "sbLoginViewController") as! LoginViewController
         self.navigationController?.popViewController(animated: true)
    }
    
    //Kiem tra xem username nguoi dung dang nhap co ton tai chua
    @IBAction func checkUsername(_ sender: UITextField) {
        if User_Provider().checkUsernameIsExists(username: txtUsername.text!){
            let alert = UIAlertController(title: "Thông báo", message: "Tài khoản đã tồn tại! Vui lòng chọn tài khoản khác!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        //Kiem tra khoang trang trong ten tai khoan
        if User_Provider().checkSpaceInString(string: txtUsername.text!) {
            let alert = UIAlertController(title: "Thông báo", message: "Tên tài khoản không được có khoảng trắng!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            txtUsername.textColor = UIColor.red
        }
    }
    
    //Kiem tra mat khau co hop l khong
    @IBAction func checkPass(_ sender: UITextField) {
        if User_Provider().checkSpaceInString(string: txtPassword.text!) {
            let alert = UIAlertController(title: "Thông báo", message: "Mật khẩu không được có khoảng trắng!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            txtPassword.textColor = UIColor.red
        }
    }
    
    //Kiem tra mat khau xac nhan co trung khop khong
    @IBAction func txtConfirmPass(_ sender: UITextField) {
        if txtConfirmPassword.text != txtPassword.text {
            let alert = UIAlertController(title: "Thông báo", message: "Mật khẩu xác nhận không trùng khớp!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            txtConfirmPassword.textColor = UIColor.red
        } else {
            txtConfirmPassword.textColor = UIColor.black
        }
    }
    
    //Dang ky tai khoan moi
    @IBAction func btnRegister(_ sender: UIButton) {
        //Lay du lieu
        //Kiem tra du lieu duoc nhap chua
        if txtUsername.text!.count < 6 {
            let alert = UIAlertController(title: "Thông báo", message: "Tài khoản đăng nhập tối thiểu phải 6 ký tự!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if txtPassword.text!.count < 6{
            let alert = UIAlertController(title: "Thông báo", message: "Mật khẩu tối thiểu phải 6 ký tự!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        //Kiem tra mat khau xac nhan co trung khop khong
        if txtConfirmPassword.text != txtPassword.text {
            let alert = UIAlertController(title: "Thông báo", message: "Mật khẩu xác nhận không trùng khớp!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if txtName.text!.count < 1 || txtName.text == " "{
            let alert = UIAlertController(title: "Thông báo", message: "Tên phải tối thiểu 1 ký tự!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if txtAddress.text!.count < 2 {
            let alert = UIAlertController(title: "Thông báo", message: "Địa chỉ tối thiểu phải 2 ký tự!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        //Kiem tra truoc khi insert
        var user : Tbl_Users = Tbl_Users()
        user.username = txtUsername.text!
        //Kiem tra tai khoan da ton tai chua
        if User_Provider().checkUsernameIsExists(username: txtUsername.text!){
            let alert = UIAlertController(title: "Thông báo", message: "Tài khoản đã tồn tại! Vui lòng chọn tài khoản khác!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        //Kiem tra khoang trang trong ten tai khoan
        if User_Provider().checkSpaceInString(string: txtUsername.text!) {
            let alert = UIAlertController(title: "Thông báo", message: "Tên tài khoản không được có khoảng trắng!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        user.password = EncryptPassword().encryptPass(password: txtPassword.text!)
        user.name = txtName.text!
        user.address = txtAddress.text!
        
        //Insert du lieu
        if UsersDAO().insertNewUser(user: user) {
            //Add quyen cho username
            let Permission : Tbl_Permission = Tbl_Permission()
            var arrayMenu : [String] = ["LO", "CSTT", "DMK", "TDL"]//chua mang menu thuoc username
            var arrayPermission : [String] = ["F", "V&M" , "M", "D&V"] //Mang chua quyen theo menu
            for i in 0...arrayMenu.count - 1 {
                PermissionDAO().insertNewPermission(username: user.username, menuID: arrayMenu[i], permission: arrayPermission[i])
            }
            
            let alert = UIAlertController(title: "Thông báo", message: "Đăng ký tài khoản thành công!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)

        } else {
            let alert = UIAlertController(title: "Thông báo", message: "Tài khoản đã tồn tại! Vui lòng thử lại!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        }
        
    }
}

