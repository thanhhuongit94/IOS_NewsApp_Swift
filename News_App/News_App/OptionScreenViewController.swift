//
//  OptionScreenViewController.swift
//  News_App
//
//  Created by huongnguyen on 27/11/2018.
//  Copyright © 2018 huongnguyen. All rights reserved.
//

import UIKit

class OptionScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{
    
    //MARK: Variable
    var thamSoMenuID : String?
    var thamSoMenuContent : String?
    static var news :Tbl_News? = nil
    
    let QLDM : String = "QLDM"
    let QLBD: String = "QLBD"
    let QLTK: String = "QLTK"
    let TDL: String = "TDL"
    let QLBVCT : String = "QLBVCT"
    
    //Phan quyen chuc nang
    let permission_provider : User_Provider! = User_Provider()
    
    var arrayNews = NSMutableArray()//chua danh sach cac tin tuc
    var arrayCategory = NSMutableArray() //chua danh muc
    var arrayUsers = NSMutableArray()//chua danh sach cac tai khoan
    let conditionalNews: String = " WHERE parent_ID != 'NULL'"
    var conditionalCategory : String = " WHERE parent_ID = 'NULL'"
    
    //MARK: Properties
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var lblHeader: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        //MARK: Tao UIBarButtonItem
        //Tao button right bar
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = add
        add.isEnabled = false
        self.navigationController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear;
        
        //MARK: Phan quyen chuc nang nut add
        //Lay du lieu phan quyen chuc nang
        permission_provider.User_Provider(MenuID: thamSoMenuID!)
        if permission_provider.canAdd == true {
            add.isEnabled = true
        }
        
        myTable.dataSource = self
        myTable.delegate = self
        txtSearch.delegate = self
        lblHeader.text = thamSoMenuContent!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        myTable.reloadData()
    }
    
    //MARK: Load data
    func loadData(){
        //MARK: Tin da luu
        if thamSoMenuID == TDL {
            //lay du lieu
            let arrayUser = UsersDAO().getAllUsers(conditional: " WHERE username = '" + User_Provider.username + "'")
            if arrayUser.count > 0 {
                if let user = arrayUser[0] as? Tbl_Users {
                    let newsEnjoy = user.getNewsEnjoy()//lay danh sach bai viet yeu thich
                    if newsEnjoy.count > 0 {
                        arrayNews.removeAllObjects()//reset array truoc
                        for item in newsEnjoy {
                            if !item.isEmpty{
                                let itemNews = NewsDAO().getOneNewsIntoKeyword(keyWord: item)
                                if !itemNews.news_name.isEmpty{
                                    arrayNews.add(itemNews)
                                }
                            }
                        }
                        if arrayNews.count == 0{
                            let alert = UIAlertController(title: "Thông báo", message: "Bạn chưa có tin đã lưu!", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            // show the alert
                            present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
            //MARK: QLBD
            //Loc lay du lieu theo menu
        else if thamSoMenuID == QLBD {
            let conditionalNews: String = " WHERE parent_ID != 'NULL'"
            arrayNews = NewsDAO().getDataNewsFromDB(conditionalNews)
        }
        else if thamSoMenuID == QLDM {//MARK: QLDM
            conditionalCategory  = " WHERE parent_ID = 'NULL'"
            arrayCategory = NewsDAO().getDataNewsFromDB(conditionalCategory)
        }
        else if thamSoMenuID == QLTK {//MARK: QLTK
            arrayUsers = UsersDAO().getAllUsers(conditional: " WHERE username != '" + User_Provider.username + "'")
        } else if thamSoMenuID == QLBVCT {
            let conditionalMyNews: String = " WHERE parent_ID != 'NULL' AND username = '" + User_Provider.username + "'"
            arrayNews = NewsDAO().getDataNewsFromDB(conditionalMyNews)
        }
    }
    //MARK: Table view datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if thamSoMenuID == QLBD || thamSoMenuID == QLBVCT || thamSoMenuID == TDL {
            return arrayNews.count
        }
        else if thamSoMenuID == QLDM {
            return arrayCategory.count
        }
        return arrayUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OptionViewCell", for: indexPath) as? OptionViewCell else {
            fatalError("Can not get the cell")
        }
        //MARK: Phan quyen NUT XOA
        if permission_provider.canDelete == true {
            cell.btnDelete.isHidden = false
        }
        
        // Configure the cell to display information of news
        if thamSoMenuID == QLBD || thamSoMenuID == QLBVCT || thamSoMenuID == TDL{
            var objectNews : Tbl_News = Tbl_News()
                objectNews = arrayNews.object(at: indexPath.row) as! Tbl_News
                //Khoi tao 1 UIImageView
                let imgNew : UIImageView = UIImageView(frame: CGRect(x: 5, y: 15, width: 310, height: 200))
                imgNew.image = objectNews.news_photo!//Gan ten hinh anh
                cell.addSubview(imgNew) //add hinh anh vao cell
                
                //Khoi tao 1 label de hien thi ten bai viet
                let txtContent = UITextView(frame: CGRect(x: 5, y: 230, width: 370, height: 60))
                txtContent.text = objectNews.news_name
                txtContent.font = UIFont(name: "Times New Roman", size: 21)
                txtContent.isEditable = false//Khong cho hien ban phim de chinh sua noi dung trong text view
                cell.addSubview(txtContent)
                
//                //Khoi tao 1 label de hien thi ten tac gia bai viet
//                let lblAuthor = UILabel(frame: CGRect(x: 5, y: 280, width: 220, height: 20))
//                lblAuthor.text = "Tác giả: " + objectNews.author//Gan du lieu
//
//                lblAuthor.font = UIFont(name: "Times New Roman", size: 20)//Thay doi font va size cua chu
//                cell.addSubview(lblAuthor)
        }
        else if thamSoMenuID == QLDM {
            
            var objectCategory = Tbl_News()
            objectCategory = arrayCategory.object(at: indexPath.row) as! Tbl_News
            
            //Khoi tao 1 UIImageView
            let imgNew : UIImageView = UIImageView(frame: CGRect(x: 15, y: 20 , width: 80, height: 80))
            imgNew.image = objectCategory.news_photo!//Gan ten hinh anh
            cell.addSubview(imgNew) //add hinh anh vao cell
            
            //Khoi tao 1 label de hien thi ten danh muc
            let lblCategoryName = UILabel(frame: CGRect(x: 120, y: 35, width: 150, height: 40))
            lblCategoryName.text = objectCategory.news_name//Gan du lieu
            
            //lblCategoryName.textColor = UIColor.white//Thay doi mau chu
            lblCategoryName.font = UIFont(name: "Times New Roman", size: 21)//Thay doi font va size cua chu
            cell.addSubview(lblCategoryName)
            
        }
        else if thamSoMenuID == QLTK {
            var objectUser = Tbl_Users()
            objectUser = arrayUsers.object(at: indexPath.row) as! Tbl_Users
            
            //Khoi tao 1 label de hien thi ten bai viet
            let lblName = UILabel(frame: CGRect(x: 5, y: 5, width: 220, height: 20))
            lblName.text = "Tên: " + objectUser.name
            lblName.font = UIFont(name: "Times New Roman", size: 20)
            cell.addSubview(lblName)
            
            //Khoi tao 1 label de hien thi ten tac gia bai viet
            let lblUsername = UILabel(frame: CGRect(x: 5, y: 35, width: 220, height: 20))
            lblUsername.text = "Username: " + objectUser.username//Gan du lieu
            
            lblUsername.font = UIFont(name: "Times New Roman", size: 20)//Thay doi font va size cua chu
            cell.addSubview(lblUsername)
            
            //Khoi tao 1 label de hien thi ten tac gia bai viet
            let lblAdsress = UILabel(frame: CGRect(x: 5, y: 70, width: 220, height: 20))
            lblAdsress.text = "Địa chỉ:  " + objectUser.address//Gan du lieu
            
            lblAdsress.font = UIFont(name: "Times New Roman", size: 20)//Thay doi font va size cua chu
            cell.addSubview(lblAdsress)
            
        }
        //Boder cell
        cell.layer.borderWidth = 0.5
        let borderColor : UIColor = UIColor.gray
        cell.layer.borderColor = borderColor.cgColor
        
        return cell
    }
    
    //Chinh kich thuoc tableviewcell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if thamSoMenuID == QLBD || thamSoMenuID == TDL{
            return 310
        }
        else if thamSoMenuID == QLDM {
            return 110
        }
        return 120
    }
    
    //MARK: Sua du lieu hoac chon xem chi tiet du lieu(TDL)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //MARK: Xem chi tiet tin da luu
        if thamSoMenuID == TDL{
            //bat vi tri dong dang duoc chon sua du lieu
            let indexSelected = myTable.indexPathForSelectedRow
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let DetailNews = sb.instantiateViewController(withIdentifier: "sbDetail_NewsViewController") as! Detail_NewsViewController
            
            var objectNews = Tbl_News()
            objectNews = arrayNews.object(at: (indexSelected?.row)!) as! Tbl_News
            let id_news: String! = objectNews.news_id
            DetailNews.thamSoNews_ID = id_news
            DetailNews.screenSource = "TDL"
            self.navigationController?.pushViewController(DetailNews, animated: true)
            return
        }
        
        //MARK: Phan quyen nut sua
        if permission_provider.canModify == false {
            return
        }
        
        //bat vi tri dong dang duoc chon sua du lieu
        let indexSelected = myTable.indexPathForSelectedRow
        
        //Quan ly danh muc
        if thamSoMenuID == QLDM {
            //Khai bao man hinh CategoryAddOrEdit
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let CategoryAddOrEditScreen = sb.instantiateViewController(withIdentifier: "sbCategoryAddOrModifyViewController") as! CategoryAddOrModifyViewController
            var objectQLDM = Tbl_News()
            objectQLDM = arrayCategory.object(at: (indexSelected?.row)!) as! Tbl_News
            CategoryAddOrEditScreen.thamSoCategoryID = objectQLDM.news_id
            //Khoi dong man hinh sua thong tin
            self.navigationController?.pushViewController(CategoryAddOrEditScreen, animated: true)
        }
        else  if thamSoMenuID == QLBD  || thamSoMenuID == QLBVCT{
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let NewsAddOrEditScreen = sb.instantiateViewController(withIdentifier: "sbNewsAddOrEditViewController") as! NewsAddOrEditViewController
            var objectQLBD = Tbl_News()
            objectQLBD = arrayNews.object(at: (indexSelected?.row)!) as! Tbl_News
            NewsAddOrEditScreen.thamSoNews_ID = objectQLBD.news_id
            self.navigationController?.pushViewController(NewsAddOrEditScreen, animated: true)
        } else if thamSoMenuID == QLTK {
            //Khai bao man hinh AddOrEdit
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let addOrEditScreen = sb.instantiateViewController(withIdentifier: "sbAddOrEditInformationViewController") as! AddOrEditInformationViewController
            addOrEditScreen.thamSo = thamSoMenuID
            //Truyen tham so di
            var objectQLTK = Tbl_Users()
            objectQLTK = arrayUsers.object(at: (indexSelected?.row)!) as! Tbl_Users
            addOrEditScreen.thamSo_IDisSelected = objectQLTK.username
            //Khoi dong man hinh sua thong tin
            self.navigationController?.pushViewController(addOrEditScreen, animated: true)
        }
        
    }
    
    //MARK: Them du lieu
    @objc func addTapped(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if thamSoMenuID == QLDM {
            //Khai bao man hinh CategoryAddOrEdit
            let CategoryAddOrEditScreen = sb.instantiateViewController(withIdentifier: "sbCategoryAddOrModifyViewController") as! CategoryAddOrModifyViewController
            //Khoi dong man hinh sua thong tin
            self.navigationController?.pushViewController(CategoryAddOrEditScreen, animated: true)
        } else if thamSoMenuID == QLBD || thamSoMenuID == QLBVCT || thamSoMenuID == TDL{
            let NewsAddOrEditScreen = sb.instantiateViewController(withIdentifier: "sbNewsAddOrEditViewController") as! NewsAddOrEditViewController
            self.navigationController?.pushViewController(NewsAddOrEditScreen, animated: true)
        } else {
            let addOrEditScreen = sb.instantiateViewController(withIdentifier: "sbAddOrEditInformationViewController") as! AddOrEditInformationViewController
            addOrEditScreen.thamSo = thamSoMenuID
            self.navigationController?.pushViewController(addOrEditScreen, animated: true)
        }
    }
    
    //MARK: xoa du lieu
    //Bat su kien cho nut xoa
    @IBAction func btnDelete(_ sender: UIButton) {
        //bat vi tri dong dang duoc chon sua du lieu
        guard let cell = sender.superview?.superview as? OptionViewCell else{
            return
        }
        let indexSelected = myTable.indexPath(for: cell)
        
        //MARK: Xoa bai viet
        //Truyen tham so di
        if thamSoMenuID == QLBD || thamSoMenuID == QLBVCT{
            var objectQLBD = Tbl_News()
            objectQLBD = arrayNews.object(at: (indexSelected?.row)!) as! Tbl_News
            
            //Xac nhan truoc khi xoa du lieu
            let alert = UIAlertController(title: "Xác nhận!", message: "Bạn chắc chắn xoá tin này!", preferredStyle: .alert)
            
            //Dong y xoa du lieu
            alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { action in
                //Delete tai khoan duoc chon
                NewsDAO().deleteNew(_idNew: objectQLBD.news_id)
                let alert = UIAlertController(title: "Thông báo", message: "Xoá tin thành công!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                if self.thamSoMenuID == self.QLBD {
                    //Load lai du lieu
                    self.arrayNews.removeObject(at: (indexSelected?.row)!)
                    self.myTable.deleteRows(at: [indexSelected!], with: .fade)
                } else if self.thamSoMenuID == self.QLBVCT {
                    //load lai data
                    self.arrayNews.removeObject(at: (indexSelected?.row)!)
                    self.myTable.deleteRows(at: [indexSelected!], with: .fade)
                }
            }))
            
            //Huy qua trinh xoa du lieu
            alert.addAction(UIAlertAction(title: "Huỷ", style: .default, handler: { action in
                print("Cancel")
            }))
            
            self.present(alert, animated: true)
        }
            //MARK: Xoa danh muc
        else if thamSoMenuID == QLDM {
            var objectQLDM = Tbl_News()
            objectQLDM = arrayCategory.object(at: (indexSelected?.row)!) as! Tbl_News
            
            //Xac nhan truoc khi xoa du lieu
            let alert = UIAlertController(title: "Xác nhận!", message: "Bạn chắc chắn xoá danh mục này!", preferredStyle: .alert)
            
            //Dong y xoa du lieu
            alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { action in
                //Delete tai khoan duoc chon
                NewsDAO().deleteNew(_idNew: objectQLDM.news_id)
                let alert = UIAlertController(title: "Thông báo", message: "Xoá danh mục thành công!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                 //Load lai du lieu
                self.arrayCategory.removeObject(at: (indexSelected?.row)!)
                self.myTable.deleteRows(at: [indexSelected!], with: .fade)
            }))
            
            //Huy qua trinh xoa du lieu
            alert.addAction(UIAlertAction(title: "Huỷ", style: .default, handler: { action in
                print("Cancel")
            }))
            
            self.present(alert, animated: true)
        }
            //MARK: Xoa tai khoan
        else if thamSoMenuID == QLTK{
            var objectQLTK = Tbl_Users()
            objectQLTK = arrayUsers.object(at: (indexSelected?.row)!) as! Tbl_Users
            
            //Xac nhan truoc khi xoa du lieu
            let alert = UIAlertController(title: "Xác nhận!", message: "Bạn chắc chắn xoá tài khoản này!", preferredStyle: .alert)
            
            //Dong y xoa du lieu
            alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { action in                
                //Delete tai khoan duoc chon
                UsersDAO().deleteUser(usernameDele: objectQLTK.username)
                let alert = UIAlertController(title: "Thông báo", message: "Xoá tài khoản thành công!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                //Xoa tai khoan ra khoi bang han quyen
                PermissionDAO().deletePermission(usernameDele: objectQLTK.username)
                
                //Load lai du lieu
                self.arrayUsers.removeObject(at: (indexSelected?.row)!)
                self.myTable.deleteRows(at: [indexSelected!], with: .fade)
            }))
            
            //Huy qua trinh xoa du lieu
            alert.addAction(UIAlertAction(title: "Huỷ", style: .default, handler: { action in
                print("Cancel")
            }))
            
            self.present(alert, animated: true)
        }
            //MARK: Delete tin da luu ra khoi list
        else if thamSoMenuID == TDL{
            let objectQLBD = arrayNews.object(at: (indexSelected?.row)!) as! Tbl_News
            
            //Xac nhan truoc khi xoa du lieu
            let alert = UIAlertController(title: "Xác nhận!", message: "Bạn chắc chắn xoá tin này!", preferredStyle: .alert)
            //Dong y xoa du lieu
            alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { action in
                //Delete tai khoan duoc chon
                //lay du lieu
                var arrayUser = UsersDAO().getAllUsers(conditional: " WHERE username = '" + User_Provider.username + "'")
                var postNewsEnjoyToUpdate: String = ""
                
                if let user = arrayUser[0] as? Tbl_Users {
                    let newsEnjoy = user.getNewsEnjoy()//lay danh sach bai viet yeu thich
                    let news_id = objectQLBD.news_id

                    for item in newsEnjoy {
                        if item != news_id && item != ""{
                            postNewsEnjoyToUpdate += item + "&"
                        }
                    }
                    UsersDAO().updateNewsEnjoy(newsEnjoy: postNewsEnjoyToUpdate, username: User_Provider.username)
                }
                
                let alert = UIAlertController(title: "Thông báo", message: "Xoá tin thành công!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                self.arrayNews.removeObject(at: (indexSelected?.row)!)
                self.myTable.deleteRows(at: [indexSelected!], with: .fade)
            }))
            //Huy qua trinh xoa du lieu
            alert.addAction(UIAlertAction(title: "Huỷ", style: .default, handler: { action in
                print("Cancel")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: Textfield search delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtSearch.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard var keyword = txtSearch.text else {
            return
        }
        if thamSoMenuID == QLBD || thamSoMenuID == QLDM {
            //Tim theo ten bai viet (co dau/ khong dau) hoac tim bai viet theo ngay
            let conditional = " WHERE news_name LIKE '%" + keyword + "%' OR datePost LIKE '%" + keyword + "%' OR author LIKE '%" + keyword + "%' OR news_content LIKE '%" + keyword + "%' OR contentNotStamp LIKE '%" + ConverHelper().convertVietNam(text: keyword) + "%'"
            
            arrayNews = NewsDAO().getDataNewsFromDB(conditional)
            if arrayNews.count == 0 {
                let alert = UIAlertController(title: "Thông báo", message: "Không có tin tức bạn cần tìm!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            //        print(arrayNewsAccorCategory.count)
        } else if thamSoMenuID == QLTK {
            let conditional = " WHERE name LIKE '%" + keyword + "%' OR address LIKE '%" + keyword + "%' OR username = '" + keyword + "'"
            
            arrayUsers = UsersDAO().getAllUsers(conditional: conditional)
            if arrayUsers.count == 0 {
                let alert = UIAlertController(title: "Thông báo", message: "Không có tài khoản bạn cần tìm!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
        
        txtSearch.text = ""
        myTable.reloadData()//Reload data after search, insert, delete, update
    }
}
