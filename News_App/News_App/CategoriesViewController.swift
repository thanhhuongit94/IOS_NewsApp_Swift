//
//  CategoriesViewController.swift
//  News_App
//
//  Created by huongnguyen on 21/11/2018.
//  Copyright © 2018 huongnguyen. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
  
    //MARK : Variable
    var arrayCategories = NSMutableArray()
    let conditional: String = " WHERE parent_ID = 'NULL'"
    
    //MARK: Properties
    @IBOutlet weak var myTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.dataSource = self
        myTable.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Doi mau nen cho navigation item
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGray;
        
        //Doi font cho navigation item
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Times New Roman", size: 22)]
        
        //Lay du lieu
        arrayCategories = NewsDAO().getDataNewsFromDB(conditional)
        myTable.reloadData()
    }
    
    //MARK: Table view datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell to display information of categories
        var objectCategory = Tbl_News()
        objectCategory = arrayCategories.object(at: indexPath.row) as! Tbl_News
        
        //Khoi tao 1 UIImageView
        let imgNew : UIImageView = UIImageView(frame: CGRect(x: 20, y: 5 , width: 70, height: 70))
        imgNew.image = objectCategory.news_photo!//Gan ten hinh anh
        cell.addSubview(imgNew) //add hinh anh vao cell
        
        //Khoi tao 1 label de hien thi ten danh muc
        let lblCategoryName = UILabel(frame: CGRect(x: 120, y: 5, width: 150, height: 40))
        lblCategoryName.text = objectCategory.news_name//Gan du lieu
        
        //lblCategoryName.textColor = UIColor.white//Thay doi mau chu
        lblCategoryName.font = UIFont(name: "Times New Roman", size: 21)//Thay doi font va size cua chu
        cell.addSubview(lblCategoryName)
        
        
        //Boder cell
        cell.layer.borderWidth = 0.5
        let borderColor : UIColor = UIColor.lightGray
        cell.layer.borderColor = borderColor.cgColor
        return cell
    }
    
    //MARK: Table view delegate
    //Ham chinh kich thuoc cua  cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    //Ham de truyen tham so truoc khi chuyen man hinh
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Bat dong dang chon
        let indexSelected = myTable.indexPathForSelectedRow
        var objectNews = Tbl_News()
        objectNews = arrayCategories.object(at: (indexSelected?.row)!) as! Tbl_News
        var id_news: String! = objectNews.news_id
        
        //Truyen tham so
        var secondController = segue.destination as! Display_CategoryViewController
        secondController.thamSoCategoryID = id_news
    }

}
