//
//  AddOrEditInformationViewController.swift
//  News_App
//
//  Created by huongnguyen on 01/12/2018.
//  Copyright © 2018 huongnguyen. All rights reserved.
//

import UIKit

class AddOrEditInformationViewController: UIViewController {
    
    var thamSo : String?//Nhan menuid duoc gui sang tu Admin VD: QLTK
    var thamSo_IDisSelected: String = ""//luu id dong duoc chon de update, duoc gui tu Option
    let QLTK : String = "QLTK"
    let CSTT : String = "CSTT"
    let DMK : String = "DMK"
    
    //MARK: Properties
    @IBOutlet var AddUserView: UserAddView!
    @IBOutlet var EditInformationView: EditInformationView!
    @IBOutlet var ChangePasswordView: ChangePasswordView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //MARK: An tabbar
        self.tabBarController?.tabBar.isHidden = true
        
        //MARK: Tao button bar
        let add = UIBarButtonItem(title: "Lưu", style: .plain, target: self, action: #selector(btnNofycation(sender:)))
        navigationItem.rightBarButtonItem = add
        
        //MARK: Add view
        switch thamSo {
        //MARK: Quan ly tai khoan
        case QLTK:
            //MARK: Sua du lieu Users
            if !thamSo_IDisSelected.isEmpty{//Sua
                AddUserView.txtUsername.text = thamSo_IDisSelected
                AddUserView.txtUsername.isUserInteractionEnabled = false
                AddUserView.txtPassword.isUserInteractionEnabled = false
                AddUserView.txtConfirmPass.isUserInteractionEnabled = false
                //Lay du lieu hien thi man hinh de chinh sua
                let conditional = " WHERE username = '" + AddUserView.txtUsername.text! + "'"
                let arrayUser = UsersDAO().getAllUsers(conditional: conditional)
                let object = arrayUser.object(at: 0) as! Tbl_Users
                //Hien thi len man hinh
                AddUserView.lblHeader.text = "SỬA THÔNG TIN TÀI KHOẢN"//Sua tieu de
                AddUserView.txtAddress.text = object.address
                AddUserView.txtPassword.text = object.password
                AddUserView.txtConfirmPass.text = object.password
                AddUserView.txtName.text = object.name
                AddUserView.oldPass = AddUserView.txtPassword.text
                AddUserView.tagAddOrModify = 0//Gan tag
            }
            self.view.addSubview(AddUserView)
        //MARK: Doi mat khau
        case DMK:
            self.view.addSubview(ChangePasswordView)//add view
        //MARK: Chinh sua thong tin
        case CSTT:
            EditInformationView.txtUsername.isUserInteractionEnabled = false
            //Hien thi du lieu len man hinh
            let conditional = " WHERE username = '"+thamSo_IDisSelected+"'"
            var arrayUser = UsersDAO().getAllUsers(conditional: conditional)
            var object = arrayUser.object(at: 0) as! Tbl_Users
            print(thamSo_IDisSelected)
            EditInformationView.txtName.text = object.name
            EditInformationView.txtAddress.text = object.address
            EditInformationView.txtUsername.text = object.username
            
            self.view.addSubview(EditInformationView)//add view
        default:
            break
        }
    }
    
    //Hien thi hop thoai thong bao
    private func showAlertButtonTapped(title : String , message : String, titleAction : String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: titleAction, style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        present(alert, animated: true, completion: nil)
    }
    
    //Hien thi hop thoai xac nhan truoc khi chinh sua
    private func showAlertConfirm(message : String) {
        //Xac nhan truoc khi xoa du lieu
        let alert = UIAlertController(title: "Xác nhận!", message: "Bạn chắc chắn sửa thông tin này!", preferredStyle: .alert)
        //Dong y sua du lieu
        alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { action in
            //Update tai khoan duoc chon
            let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: UIAlertController.Style.alert)
            //Nhan OK
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {action in
                //Day man hinh sua ra khoi navigation
                if self.thamSo == self.CSTT{
                    //Lay du lieu va update thong tin
                    let conditional = " WHERE username = '"+User_Provider.username+"'"
                    var arrayUser = UsersDAO().getAllUsers(conditional: conditional)
                    var object = arrayUser.object(at: 0) as! Tbl_Users
                    let user : Tbl_Users = Tbl_Users()
                    user.username = User_Provider.username
                    user.address = self.EditInformationView.txtAddress.text!
                    user.name = self.EditInformationView.txtName.text!
                    user.password = object.password
                    
                    UsersDAO().updateUser(user: user)
                } else if self.thamSo == self.QLTK {
                    let user : Tbl_Users = Tbl_Users()
                    user.username = self.AddUserView.txtUsername.text!
                    user.name = self.AddUserView.txtName.text!
                    user.address = self.AddUserView.txtAddress.text!
                    if self.AddUserView.oldPass == self.AddUserView.txtPassword.text{
                        user.password = self.AddUserView.txtPassword.text!
                    } else {
                        user.password = EncryptPassword().encryptPass(password: self.AddUserView.txtPassword.text!)
                    }
                    UsersDAO().updateUser(user: user)
                    //Hien thi lai du lieu
                    var object : Tbl_Users = Tbl_Users()
                    let arrayUsers : NSMutableArray = UsersDAO().getAllUsers(conditional: " WHERE username = '"+user.username+"'")
                    if arrayUsers.count > 0{
                        object  = arrayUsers[0] as! Tbl_Users
                        self.AddUserView.txtAddress.text = object.address
                        self.AddUserView.txtPassword.text = object.password
                        self.AddUserView.txtConfirmPass.text = object.password
                        self.AddUserView.txtName.text = object.name
                    }
                }
                self.navigationController?.popViewController(animated: true)
                if self.thamSo == self.DMK {
                    UsersDAO().changePass(newPass: EncryptPassword().encryptPass(password: self.ChangePasswordView.txtNewPass.text!), username: User_Provider.username)
                    self.navigationController?.popViewController(animated: false)
                }
            }))
            self.present(alert, animated: true, completion: nil)
            
        }))
        
        //Huy qua trinh xoa du lieu
        alert.addAction(UIAlertAction(title: "Huỷ", style: .default, handler: { action in
            if self.thamSo! == self.QLTK {
                self.AddUserView.tagOK = 0
            } else if self.thamSo == self.DMK {
                self.ChangePasswordView.tagOK = 0
            } else if self.thamSo == self.CSTT{
                self.EditInformationView.tagOK = 0
            }
        }))
        self.present(alert, animated: true)
    }
    
    //MARK: Thuc hien them, sua du lieu User
    //Luu du lieu user moi tao
    @objc func btnNofycation(sender: UIButton){
        if thamSo == QLTK {
            AddUserView.btnSaveData(sender)
            //Show alert
            switch AddUserView.tagAlert {
            case 0:
                showAlertButtonTapped(title: "Thông báo", message: "Tài khoản đăng nhập tối thiểu phải 6 ký tự!", titleAction: "OK")
            case 1:
                showAlertButtonTapped(title: "Thông báo", message: "Mật khẩu  đăng nhập tối thiểu phải 6 ký tự!", titleAction: "OK")
            case 2:
                showAlertButtonTapped(title: "Thông báo", message: "Mật khẩu xác nhận không trùng khớp!", titleAction: "OK")
            case 3:
                showAlertButtonTapped(title: "Thông báo", message: "Tên phải tối thiểu 1 ký tự!", titleAction: "OK")
            case 4:
                showAlertButtonTapped(title: "Thông báo", message: "Địa chỉ tối thiểu phải 2 ký tự!", titleAction: "OK")
            case 5:
                showAlertButtonTapped(title: "Thông báo", message: "Tài khoản đã tồn tại! Vui lòng chọn tài khoản khác!", titleAction: "OK")
            case 6:
                showAlertButtonTapped(title: "Thông báo", message: "Tên tài khoản không được có khoảng trắng!", titleAction: "OK")
            case 7:
                showAlertButtonTapped(title: "Thông báo", message: "Thêm tài khoản thành công!", titleAction: "OK")
            case 8:
                showAlertConfirm(message: "Sửa dữ liệu thành công!")
            case 9:
                showAlertButtonTapped(title: "Thông báo", message: "Mật khẩu không được có khoảng trắng!", titleAction: "OK")
            default:
                return
            }
        } else if thamSo == DMK {
            ChangePasswordView.btnSave(sender)
            switch ChangePasswordView.tagAlert {
            case 0:
                showAlertButtonTapped(title: "Thông báo", message: "Mật khẩu đăng nhập tối thiểu phải 6 ký tự!", titleAction: "OK")
            case 1:
                showAlertButtonTapped(title: "Thông báo", message: "Mật khẩu xác nhận không trùng khớp!", titleAction: "OK")
            case 2:
                showAlertButtonTapped(title: "Thông báo", message: "Mật khẩu cũ không đúng", titleAction: "OK")
            case 3:
                showAlertButtonTapped(title: "Thông báo", message: "Mật khẩu mới trùng mật khẩu cũ", titleAction: "OK")
            case 4:
                showAlertConfirm(message: "Đổi mật khẩu thành công! Vui lòng đăng nhập lại!")
            case 5:
                showAlertButtonTapped(title: "Thông báo", message: "Mật khẩu không được có khoảng trắng!", titleAction: "OK")
            default:
                return
            }
           
        } else {
            EditInformationView.btnSave(sender)
            switch EditInformationView.tagAlert {
            case 0:
                showAlertButtonTapped(title: "Thông báo", message: "Tên người dùng không được bỏ trống!", titleAction: "OK")
            case 1:
                showAlertButtonTapped(title: "Thông báo", message: "Địa chỉ tối thiểu phải 2 ký tự trở lên!", titleAction: "OK")
            case 2:
                showAlertConfirm(message: "Sửa thông tin thành công!")
            default:
                return
            }
        }
    }
}
