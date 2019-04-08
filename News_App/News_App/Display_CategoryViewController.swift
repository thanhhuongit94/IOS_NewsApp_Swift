//
//  Display_CategoryViewController.swift
//  News_App
//
//  Created by huongnguyen on 22/11/2018.
//  Copyright © 2018 huongnguyen. All rights reserved.
//

import UIKit

class Display_CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{
    //MARK: Properties
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var myTable: UITableView!
    
    //MARK: Variable
    var arrayNewsAccorCategory = NSMutableArray()
    var thamSoCategoryID : String!
    let columName = "parent_ID"
    let conditional: String = " ORDER BY news_id DESC"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController!.tabBar.isHidden = false//MARK: Hien thi lai tabbar
        myTable.dataSource = self
        myTable.delegate = self
        
        txtSearch.delegate = self
        
        arrayNewsAccorCategory = NewsDAO().getDataNewsIntoKeyword(keyWord: thamSoCategoryID, colName: columName, conditional)
        myTable.reloadData()
    }
    
    //MARK: Table view datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayNewsAccorCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell to display information of news
        var objectNewAccorCategory = Tbl_News()
            objectNewAccorCategory = arrayNewsAccorCategory.object(at: indexPath.row) as! Tbl_News
        
        //Khoi tao 1 UIImageView
        let imgNew : UIImageView = UIImageView(frame: CGRect(x: 0, y: 11, width: 180, height: 119))
        imgNew.image = objectNewAccorCategory.news_photo!//Gan ten hinh anh
        cell.addSubview(imgNew) //add hinh anh vao cell
        
        //Khoi tao 1 label de hien thi ten bai viet
        let txtContent = UITextView(frame: CGRect(x: 185, y: 0, width: 190, height: 100))
        txtContent.text = objectNewAccorCategory.news_name
        //txtContent.backgroundColor = UIColor.black//Thay doi mau nen textview
        txtContent.font = UIFont(name: "Times New Roman", size: 18)
        txtContent.isEditable = false//Khong cho hien ban phim de chinh sua noi dung trong text view
        //txtContent.textColor = UIColor.white//Set mau chu cho textview
        cell.addSubview(txtContent)
        
        //Khoi tao 1 label de hien thi ngay viet bai
        let lblDate = UILabel(frame: CGRect(x: 185, y: 116, width: 190, height: 10))
        lblDate.text = objectNewAccorCategory.datePost//Gan du lieu
        
        //lblDate.textColor = UIColor.white//Thay doi mau chu
        lblDate.font = UIFont(name: "Times New Roman", size: 14)//Thay doi font va size cua chu
        cell.addSubview(lblDate)
        //cell.textLabel?.text = objectMenu.menuPhoto
        
        
        //Boder cell
        cell.layer.borderWidth = 0.3
        let borderColor : UIColor = UIColor.white
        cell.layer.borderColor = borderColor.cgColor
        
        return cell
    }

    //MARK: Table view delegate
    //Ham chinh kich thuoc cua  cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    //Ham de truyen tham so truoc khi chuyen man hinh
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Bat dong dang chon
        let indexSelected = myTable.indexPathForSelectedRow
        
        var objectNews = Tbl_News()
        objectNews = arrayNewsAccorCategory.object(at: (indexSelected?.row)!) as! Tbl_News
        var id_news: String! = objectNews.news_id

        //Truyen tham so
        var secondController = segue.destination as! Detail_NewsViewController
        secondController.thamSoNews_ID = id_news
        // thamSoTruyen_NewsID.setValue(id_news, forKey: "id_news_selected")
        // print(id_news!)
    }
   
    //Tim kiem thong tin danh muc
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtSearch.resignFirstResponder()
        return true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard var keyword = txtSearch.text else {
            return
        }
        
        //Tim theo ten bai viet (co dau/ khong dau) hoac tim bai viet theo ngay
        let conditional = " WHERE (news_name LIKE '%" + keyword + "%' OR datePost LIKE '%" + keyword + "%' OR author LIKE '%" + keyword + "%' OR news_content LIKE '%" + keyword + "%') AND parent_ID = '"+thamSoCategoryID+"'"
//        print(conditional)
        
        //OR news_content_NotStamped LIKE '%" + ConverHelper().convertVietNam(text: keyword) + "%'
        
        arrayNewsAccorCategory = NewsDAO().getDataNewsFromDB(conditional)
        if arrayNewsAccorCategory.count == 0 {
            let alert = UIAlertController(title: "Thông báo", message: "Không có tin tức bạn cần tìm!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
//        print(arrayNewsAccorCategory.count)
        txtSearch.text = ""
        myTable.reloadData()//Reload data after search, insert, delete, update
    }

    
}
