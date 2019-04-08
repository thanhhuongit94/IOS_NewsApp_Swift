//
//  MainViewController.swift
//  News_App
//
//  Created by huongnguyen on 03/12/2018.
//  Copyright © 2018 huongnguyen. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    //MARK: Define variable
    var arrayNews = NSMutableArray()
    let conditional: String = " WHERE parent_ID != 'NULL' ORDER BY news_id DESC LIMIT 20"
    
    //MARK: Properties
    @IBOutlet var tableviewMain: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var btnLogin: UIBarButtonItem!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    //Truoc khi xuat hien man hinh thi tien hanh ket noi CSDL va lay du lieu ve de hien thi
    override func viewWillAppear(_ animated: Bool) {
        print(User_Provider.username)
        self.tabBarController?.tabBar.isHidden = false
        if User_Provider.username != "" {
            self.navigationItem.rightBarButtonItem!.title = "Đăng xuất"
        }
        tableviewMain.delegate = self
        tableviewMain.dataSource = self
        txtSearch.delegate = self
        
        //Doi mau nen cho navigation item
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGray;
        
        //Doi font cho navigation item
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Times New Roman", size: 22)]
        
        self.navigationItem.setHidesBackButton(true, animated: true)//An button navigation
        let news : Tbl_News = Tbl_News()
        arrayNews = NewsDAO().getDataNewsFromDB(conditional)
        tableviewMain.reloadData()//Reload data after insert, delete, update
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayNews.count
    }
    
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell to display information of news
        
        var objectNews = Tbl_News()
        objectNews = arrayNews.object(at: indexPath.row) as! Tbl_News
        
        //Khoi tao 1 UIImageView
        let imgNew : UIImageView = UIImageView(frame: CGRect(x: 0, y: 11, width: 180, height: 119))
        imgNew.image = objectNews.news_photo//Gan ten hinh anh
        cell.addSubview(imgNew) //add hinh anh vao cell
        
        //Khoi tao 1 textview de hien thi ten bai viet
        let txtContent = UITextView(frame: CGRect(x: 185, y: 0, width: 190, height: 110))
        txtContent.text = objectNews.news_name
        txtContent.backgroundColor = UIColor.white//Thay doi mau nen textview
        txtContent.font = UIFont(name: "Times New Roman", size: 19)
        txtContent.isEditable = false//Khong cho hien ban phim de chinh sua noi dung trong text view
        txtContent.textColor = UIColor.black//Set mau chu cho textview
        cell.addSubview(txtContent)
        
        //Khoi tao 1 label de hien thi ngay viet bai
        let lblDate = UILabel(frame: CGRect(x: 185, y: 116, width: 190, height: 15))
        lblDate.text = objectNews.datePost//Gan du lieu
        
        lblDate.textColor = UIColor.black//Thay doi mau chu
        lblDate.font = UIFont(name: "Times New Roman", size: 17)//Thay doi font va size cua chu
        cell.addSubview(lblDate)
        //cell.textLabel?.text = objectMenu.menuPhoto
        
        
        //Boder cell
        cell.layer.borderWidth = 0.5
        let borderColor : UIColor = UIColor.lightGray
        cell.layer.borderColor = borderColor.cgColor
        
        return cell
    }
    
    //Ham chinh kich thuoc cua  cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    //Chinh sua mau nen cho tableviewCell moi khi khi chon
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    //MARK : Table view delegate
    //Ham de truyen tham so truoc khi chuyen man hinh
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Bat dong dang chon
      if let indexSelected = tableviewMain.indexPathForSelectedRow {
            var objectNews = Tbl_News()
        objectNews = arrayNews.object(at: (indexSelected.row)) as! Tbl_News
            var id_news: String! = objectNews.news_id
            
            //Truyen tham so
            var secondController = segue.destination as! Detail_NewsViewController
            secondController.thamSoNews_ID = id_news
        }
    }
    
    //MARK: Tim kiem tin tuc
    //Tim kiem thong tin
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtSearch.resignFirstResponder()
        return true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard var keyword = txtSearch.text else {
            return
        }
        
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
        txtSearch.text = ""
        tableviewMain.reloadData()//Reload data after search, insert, delete, update
    }
    
    //MARK: Login
    @IBAction func btnLoginApp(_ sender: UIBarButtonItem) {
        if self.navigationItem.rightBarButtonItem?.title != "Đăng nhập" {
            User_Provider.username = ""
            //dismiss(animated: true, completion: nil)
            let sb = UIStoryboard(name: "Main", bundle: nil)
            //Khoi dong man hinh home luc khoi dong app
            let screenHome = sb.instantiateViewController(withIdentifier: "sbTabMain_Controller") as! TabMain_Controller
            self.present(screenHome, animated: true)
        } else {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            //Khoi dong man hinh home luc khoi dong app
            let screenLogin = sb.instantiateViewController(withIdentifier: "sbLoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(screenLogin, animated: true)
        }
    }
    
}

