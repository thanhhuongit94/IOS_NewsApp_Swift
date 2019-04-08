//
//  CategoryAddOrModifyViewController.swift
//  News_App
//
//  Created by huongnguyen on 09/12/2018.
//  Copyright © 2018 huongnguyen. All rights reserved.
//

import UIKit

class CategoryAddOrModifyViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    //MARK: Properties
    @IBOutlet weak var txtCategory_name: UITextField!
    @IBOutlet weak var txtCategory_content: UITextField!
    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var lblHeader: UILabel!
    
    var thamSoCategoryID: String = ""
    var categoryNameOld : String?
    var tagAlertCategory : Int = -1
    var tagDeleModifyCategory : Int = 0
    var tagOK = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        txtCategory_name.delegate = self
        txtCategory_content.delegate = self
        
        //MARK: Tao UIBarButtonItem
        //Tao button right bar
        let add = UIBarButtonItem(title: "Lưu", style: .plain, target: self, action: #selector(btnSaveData))
        navigationItem.rightBarButtonItem = add
        
        if !thamSoCategoryID.isEmpty {
            lblHeader.text = "SỬA THÔNG TIN DANH MỤC"
            
            //Lay thong tin danh muc dua tren id
            let conditional = " WHERE news_id = '" + thamSoCategoryID + "'"
            let arrayCategories = NewsDAO().getDataNewsFromDB(conditional)
            var object = arrayCategories.object(at: 0) as! Tbl_News
            
            txtCategory_name.text = object.news_name
            //Hien thi len man hinh
            txtCategory_content.text = object.news_content
            imgCategory.image = object.news_photo!
            categoryNameOld = txtCategory_name.text
            tagDeleModifyCategory = 1//gan tag
        }
    }
    
    //MARK: Action
    @objc func btnSaveData() {
        //MARK: Them
        //Kiem tra du lieu truoc khi them
        if (txtCategory_name.text?.isEmpty)! {
            tagAlertCategory = 0
            showNofication()
            return
        }
        
        if (txtCategory_content.text?.isEmpty)!{
            tagAlertCategory = 1
            showNofication()
            return
        }
        
        if tagDeleModifyCategory == 0{//THEM DU LIEU
            //Kiem tra ten danh muc da ton tai chua
            let arrayCategory = NewsDAO().getDataNewsFromDB(" WHERE news_name = '"+txtCategory_name.text!+"'")
            if arrayCategory.count > 0{
                tagAlertCategory = 2
                 showNofication()
                return
            } else {
                let news : Tbl_News = Tbl_News()
                news.news_name = txtCategory_name.text!
                news.nameNotStamp = ConverHelper().convertVietNam(text: news.news_name)
                news.news_content = txtCategory_content.text!
               
                news.news_photo = imgCategory.image

                news.parent_ID = "NULL"
                
                if NewsDAO().insertNew(news: news) {
                    tagAlertCategory = 3
                     showNofication()
                    //Resets
                    txtCategory_name.text = ""
                    txtCategory_content.text = ""
                    imgCategory.image = UIImage(named: "default_news")
                    
                }
            }
            //MARK: Sua thong tin
        } else {//Sua thong tin danh muc
            let category : Tbl_News = Tbl_News()
            category.news_id = thamSoCategoryID
            category.news_name = txtCategory_name.text!
            category.nameNotStamp = ConverHelper().convertVietNam(text: category.news_name)
            category.news_content = txtCategory_content.text!
            category.news_photo = imgCategory.image
            
            tagAlertCategory = 4
            showNofication()
            if tagOK == 1{
                //Update
                //Kiem tra ten danh muc da ton tai chua
                var arrayCategory = NewsDAO().getDataNewsFromDB(" WHERE news_name = '"+category.news_name+"'")
                if categoryNameOld != txtCategory_name.text && arrayCategory.count > 0{
                    tagAlertCategory = 2
                    return
                }
                NewsDAO().updateCategory(News: category)
            }
        }
    }
    
    //Hien thi thong bao tuong uwng
    private func showNofication () {
        switch tagAlertCategory {
        case 0:
            showAlertButtonTapped(title: "Thông báo", message: "Tên danh mục không được bỏ trống", titleAction: "OK")
        case 1:
            showAlertButtonTapped(title: "Thông báo", message: "Nội dung danh mục không được bỏ trống", titleAction: "OK")
        case 2:
            showAlertButtonTapped(title: "Thông báo", message: "Tên danh mục đã tồn tại", titleAction: "OK")
        case 3:
            showAlertButtonTapped(title: "Thông báo", message: "Thêm danh mục thành công!", titleAction: "OK")
        case 4 :
            showAlertConfirm(message: "Sửa dữ liệu thành công!")
        default:
            return
        }
    }
    
    //MARK: Show alert
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
        
        //Dong y xoa du lieu
        alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { action in
            //Update tai khoan duoc chon
            let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: UIAlertController.Style.alert)
            //Nhan OK
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {action in
                //Day man hinh sua ra khoi navigation
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
            
        }))
        
        //Huy qua trinh xoa du lieu
        alert.addAction(UIAlertAction(title: "Huỷ", style: .default, handler: { action in
            self.tagOK = 0
        }))
        self.present(alert, animated: true)
    }
    
    //MARK: Change image
    @IBAction func changeImageCategory(_ sender: UITapGestureRecognizer) {
        print("Thay doi anh")
        let imgPicker = UIImagePickerController()
        //Chi thu muc lay anh
        imgPicker.sourceType = .photoLibrary//Mo thu muc photo library
        //Uy quyen
        imgPicker.delegate = self
        present(imgPicker, animated: true, completion: nil)
        
    }
    
    //MARK: Delegation of image picker controller
    //Ham khi bam cancel se thuc hien
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //An cua so hien thi albums chon anh quay tro lai man hinh chinh
       // dismiss(animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //UIImagePickerControllerOriginalImage = UIImagePickerController.InfoKey.originalImage
        guard let selectImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("The image in \(info)is not exits!")//Thong bao va thoat chuong trinh
        }
        //Doi anh
        imgCategory.image = selectImage
        dismiss(animated: true, completion: nil)//An picker controller va tra ve man hinh chinh chua anh
    }

    //MARK: Textfield delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtCategory_content.resignFirstResponder()
        txtCategory_name.resignFirstResponder()
        return true
    }
}
