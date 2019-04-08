//
//  AdminViewController.swift
//  News_App
//
//  Created by huongnguyen on 25/11/2018.
//  Copyright © 2018 huongnguyen. All rights reserved.
//

import UIKit

class AdminViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    //MARK: Define variable
    var arrayPermission = NSMutableArray() //Mang chua MenuID va Permiss cua user dang dang nhap
    let LOGOUT : String = "LO"
    let EDITINFORMATION : String = "CSTT"
    let EXITAPP : String = "EX"
    let CHANGEPASS : String = "DMK"
    let HOME : String = "TC"
    var checkScreen: String = ""//kiem tra xem man hinh nay duoc mo len tu dau
    
    //MARK: Properties
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var lblHeader: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        //navigationItem.leftBarButtonItem?.isEnabled = false
        if User_Provider.username == "" {
            //Update tai khoan duoc chon
            let alert = UIAlertController(title: "Thông báo", message: "Hãy đăng nhập để có trải nghiệm tốt nhất!", preferredStyle: UIAlertController.Style.alert)
            //Nhan OK
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {action in
                //Day man hinh sua ra khoi navigation
                let sb = UIStoryboard(name: "Main", bundle: nil)
                //Khoi dong man hinh home luc khoi dong app
                let screenEdit = sb.instantiateViewController(withIdentifier: "sbTabMain_Controller") as! TabMain_Controller
                self.present(screenEdit, animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        myTable.dataSource = self
        myTable.delegate = self
        
        //Lay danh sach bang phan quyen thuoc ve username dang dang nhap
        myTable.reloadData()
        arrayPermission = PermissionDAO().getPermissionFromDB(username: User_Provider.username)
    }
    
    //MARK: Table view datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPermission.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //Hien thi noi dung menu duoc phep su dung theo phan quyen cua username 
        //Lay noi dung menu_content theo menuid
            var objectPermission = Tbl_Permission()
            objectPermission = arrayPermission.object(at: indexPath.row) as! Tbl_Permission
            
            let objectMenu = MenuDAO().getMenuContentAccordingPermission(menuID: objectPermission.MenuIDPermiss)
            
            //Hien thi len cell cua tableview
            //Khoi tao 1 UIImageView
            let imgNew : UIImageView = UIImageView(frame: CGRect(x: 10, y: 5 , width: 40, height: 40))
            imgNew.image = objectMenu.menuPhoto//Gan ten hinh anh
            cell.addSubview(imgNew) //add hinh anh vao cell
            
            //Khoi tao 1 label de hien thi noi dung menu
            let lblMenuContent = UILabel(frame: CGRect(x: 70, y: 5, width: 250, height: 40))
            lblMenuContent.text = objectMenu.menuContent//Gan du lieu
            
            //lblCategoryName.textColor = UIColor.white//Thay doi mau chu
            lblMenuContent.font = UIFont(name: "Times New Roman", size: 20)//Thay doi font va size cua chu
            cell.addSubview(lblMenuContent)
            
            //Boder cell
            cell.layer.borderWidth = 0.2
            let borderColor : UIColor = UIColor.black
            cell.layer.borderColor = borderColor.cgColor
        
        return cell
    }
    
    //MARK: Table view delegate
    //Ham chinh kich thuoc cua  cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    //Bat su kien click vao cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Bat dong dang chon
        let indexSelected = myTable.indexPathForSelectedRow
        var objectPermission = Tbl_Permission()
        objectPermission = arrayPermission.object(at: (indexSelected?.row)!) as! Tbl_Permission
        let menu_id: String! = objectPermission.MenuIDPermiss
        
        let objectMenu = MenuDAO().getMenuContentAccordingPermission(menuID: objectPermission.MenuIDPermiss)
        
        //MARK: su kien chon vao cell cua tableview chuyen man hinh
        //Neu chon logout
        //MARK: Logout
        if menu_id == LOGOUT {
            if checkScreen.isEmpty{
                let sb = UIStoryboard(name: "Main", bundle: nil)
                self.tabBarController?.tabBar.isHidden = false //hien thi tabbar
                User_Provider.username = ""
                let screenEdit = sb.instantiateViewController(withIdentifier: "sbTabMain_Controller") as! TabMain_Controller
                self.present(screenEdit, animated: true)
            }
            self.tabBarController?.tabBar.isHidden = false //hien thi tabbar
            User_Provider.username = ""
           self.navigationController?.popViewController(animated: true)
        }
            //MARK: Change password or edit information
        else if menu_id == CHANGEPASS || menu_id == EDITINFORMATION {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            //Khoi dong man hinh home luc khoi dong app
            let screenEdit = sb.instantiateViewController(withIdentifier: "sbAddOrEditInformationViewController") as! AddOrEditInformationViewController
            self.navigationController?.pushViewController(screenEdit, animated: true)
            if menu_id == CHANGEPASS {
                screenEdit.thamSo = CHANGEPASS
            } else{
                screenEdit.thamSo = EDITINFORMATION
            }
            screenEdit.thamSo_IDisSelected = User_Provider.username//gui thong tin username dang dang nhap
        }
            //MARK: Exit app
        else if menu_id == EXITAPP {
            //exit app
        }
            //MARK: Ve trang chu
        else if menu_id == HOME {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let secondController = sb.instantiateViewController(withIdentifier: "sbTabMain_Controller") as! TabMain_Controller
               // secondController.navigationController?.navigationItem.title = "Logout"
            self.navigationController?.pushViewController(secondController, animated: true)
        }   //MARK: QLBD, QLDM, QLTK
        else {
            //Truyen tham so
            let sb = UIStoryboard(name: "Main", bundle: nil)
            //Khoi dong man hinh home luc khoi dong app
            let secondController = sb.instantiateViewController(withIdentifier: "sbOptionScreenViewController") as! OptionScreenViewController
            self.navigationController?.pushViewController(secondController, animated: true)
            secondController.thamSoMenuID = menu_id
            secondController.thamSoMenuContent = objectMenu.menuContent
        }
    }
    
}
