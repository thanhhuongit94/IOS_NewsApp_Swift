//
//  NewsAddOrEditViewController.swift
//  News_App
//
//  Created by huongnguyen on 09/12/2018.
//  Copyright © 2018 huongnguyen. All rights reserved.
//

import UIKit

class NewsAddOrEditViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblContent: UITextView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDatePost: UITextField!
    @IBOutlet weak var pickerViewCategory: UIPickerView!
    
    @IBOutlet weak var txtAthour: UITextField!
    @IBOutlet weak var imgeCategory: UIImageView!
    
    var thamSoNews_ID : String = ""
    var tagNews : Int = -1
    var tagDeleModifyCategory : Int = 0
    var tagOK = 1 //Xac nhan update
    var news_nameOld : String?
    var arrayCate = NSMutableArray()
    var danhMuc : String = ""
    var news : Tbl_News = Tbl_News()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        pickerViewCategory.delegate = self
        pickerViewCategory.dataSource = self
        
        txtName.delegate = self
        txtAthour.delegate = self
        lblContent.delegate = self
        
        //MARK: Tao UIBarButtonItem
        //Tao button right bar
        let add = UIBarButtonItem(title: "Lưu", style: .plain, target: self, action: #selector(btnSave))
        navigationItem.rightBarButtonItem = add
        
        //MARK: Quan ly danh muc
        //Lay danh sach danh muc
        let conditionalCategory : String = " WHERE parent_ID = 'NULL'"
        arrayCate = NewsDAO().getDataNewsFromDB(conditionalCategory)
        
        if !thamSoNews_ID.isEmpty {
            lblHeader.text = "SỬA THÔNG TIN TIN TỨC"
            //Lay thong tin tin tuc hien thi len man hinh
            var conditional = " WHERE news_id = '" + thamSoNews_ID + "'"
            var arrayNews = NewsDAO().getDataNewsFromDB(conditional)
            var object = arrayNews.object(at: 0) as! Tbl_News
            
            //Hien thi len man hinh
            txtName.text = object.news_name
            lblContent.text = object.news_content
            txtAthour.text = object.author
            imgeCategory.image = object.news_photo!
            
            tagDeleModifyCategory = 1//gan tag
            news_nameOld = object.news_name
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // check if the back button was pressed
        if (self.isMovingFromParent) {
            // do something here if that's the case
            print("Back button was pressed.")
        }
    }
    
    //MARK: Action
    @objc func btnSave() {
        //Kiem tra du lieu truoc khi them
        if (txtName.text?.isEmpty)! {
            tagNews = 0
            showNofication()
            return
        }
        
        if (lblContent.text?.isEmpty)!{
            tagNews = 1
            showNofication()
            return
        }
        
        if (txtAthour.text?.isEmpty)! {
            tagNews = 2
            showNofication()
            return
        }

        if thamSoNews_ID.isEmpty {
            if danhMuc.isEmpty {
                tagNews = 6
                showNofication()
                return
            }
        }
        
        //MARK: Them tin moi
        if tagDeleModifyCategory == 0{
            //Kiem tra ten tin tuc da ton tai chua
            let arrayNews = NewsDAO().getDataNewsFromDB(" WHERE news_name = '"+txtName.text!+"'")
            if arrayNews.count > 0{
                tagNews = 3
                showNofication()
                return
            }
            let name = txtName.text!
            let nameNotStamp = ConverHelper().convertVietNam(text: name)
            let content = lblContent.text!
            let author = txtAthour.text!
            let photo = imgeCategory.image
            let username = User_Provider.username
            
            //MARK: lay ngay thang nam mac dinh cua he thong
            let date = Date()//Lay ngay thang nam
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"//Dinh dang ngay thang nam
            let datePost : String = formatter.string(from: date)//Chuyen ve kieu string
            let news_date = datePost
            
            //Lay id_danh muc
            let parent_ID = danhMuc

            //MARK: Lay doi tuong news
            news = (Tbl_News(news_name: name, nameNotStamp: nameNotStamp, news_content: content, author: author, datePost: news_date, news_photo: photo, parent_ID: parent_ID, username: username) ?? nil)!
            
            //insert du lieu
            if NewsDAO().insertNew(news: news) {
                tagNews = 4
               showNofication()
                //navigationController?.popViewController(animated: true)
                //Resets
                txtName.text = ""
                lblContent.text = ""
                txtAthour.text = ""
                imgeCategory.image = UIImage(named: "default_news")
                
            }
        }
        else {//MARK: Sua du lieu
            tagNews = 5
            showNofication()
            let news : Tbl_News = Tbl_News()
            news.news_id = thamSoNews_ID
            news.news_name = txtName.text!
            news.nameNotStamp = ConverHelper().convertVietNam(text: news.news_name)
            news.news_content = lblContent.text!
            news.author = txtAthour.text!
            //MARK: lay ngay thang nam mac dinh cua he thong
            let date = Date()//Lay ngay thang nam
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"//Dinh dang ngay thang nam
            let datePost : String = formatter.string(from: date)//Chuyen ve kieu string
            news.datePost = datePost
            //Lay hinh anh
            news.news_photo = imgeCategory.image
            
            //Lay id_danh muc
            news.parent_ID = danhMuc
            if tagOK == 1{
                //Update
                //Kiem tra ten tin tuc da ton tai chua
                var arrayNews = NewsDAO().getDataNewsFromDB(" WHERE news_name = '"+txtName.text!+"'")
                if news_nameOld != txtName.text && arrayNews.count > 0{
                    tagNews = 3
                    showNofication()
                    return
                }
                NewsDAO().updateNew(News: news)
            }
        }
    }
    
    
    //MARK: Thiet lap cho picker view danh muc
    //Thiet lap so cot ho picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Thiet lap so dong cho pickerview
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayCate.count
    }
    
    //Tra ve dong duoc chon trong picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let object : Tbl_News = arrayCate.object(at: row) as! Tbl_News
        return object.news_name
    }
    
    //Khi nguoi dung chon dong nao do thi su kien nay se duoc goi den
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        /*
         Gia tri tai dong duoc chon se tuong ung voi phan tu thu row trong mang.
         Vi vay, moi thao tac voi gia tri cua picker deu duoc thong qua viec thao tac mang
         */
        if component == 0{
            //Lay danh muc dang duoc chon
            let object : Tbl_News = arrayCate.object(at: row) as! Tbl_News
            danhMuc = object.news_id
            print(object.news_id)
        }
    }
    
    //MARK: Thong bao
    private func showNofication(){
        switch tagNews{
        case 0:
            showAlertButtonTapped(title: "Thông báo", message: "Tiêu đề không được bỏ trống!", titleAction: "OK")
        case 1:
            showAlertButtonTapped(title: "Thông báo", message: "Nội dung tin tức không được bỏ trống", titleAction: "OK")
        case 2:
            showAlertButtonTapped(title: "Thông báo", message: "Tên tác giả không được bỏ trống", titleAction: "OK")
        case 3:
            showAlertButtonTapped(title: "Thông báo", message: "Tin tức đã tồn tại", titleAction: "OK")
        case 4:
            showAlertButtonTapped(title: "Thông báo", message: "Thêm mới thành công", titleAction: "OK")
        case 5:
            showAlertConfirm(message: "Sửa dữ liệu thành công!")
        case 6:
            showAlertButtonTapped(title: "Thông báo", message: "Bạn hãy chọn danh mục cho bài viết", titleAction: "OK")
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
    
    //MARK: Textfield delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtAthour.resignFirstResponder()
        txtName.resignFirstResponder()
        return true
    }
    
    //MARK: textview delegate
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        lblContent.resignFirstResponder()
        return true
    }
    
      //MARK: Change image
    @IBAction func changePhoto(_ sender: UITapGestureRecognizer) {
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
        dismiss(animated: true, completion: loadScreen)
    }
    
    //Load anh len
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //UIImagePickerControllerOriginalImage = UIImagePickerController.InfoKey.originalImage
        guard let selectImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("The image in \(info)is not exits!")//Thong bao va thoat chuong trinh
        }
        //Doi anh
        imgeCategory.image = selectImage
        dismiss(animated: true, completion: nil)//An picker controller va tra ve man hinh chinh chua anh
    }
    
    private func loadScreen(){
        print("Hello")
        //        let sb = UIStoryboard(name: "Main", bundle: nil)
        //        //Khoi dong man hinh home luc khoi dong app
        //        let home = sb.instantiateViewController(withIdentifier: "sbCategoryAddOrModifyViewController") as! CategoryAddOrModifyViewController
        //        self.present(home, animated: true, completion: nil);
    }
}
