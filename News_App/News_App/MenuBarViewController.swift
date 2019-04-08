//
//  MenuBarViewController.swift
//  News_App
//
//  Created by huongnguyen on 18/11/2018.
//  Copyright © 2018 huongnguyen. All rights reserved.
//

import UIKit

class MenuBarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var imgeLogin: UIImageView!
     var arrayMenu = NSMutableArray()
    
    

    @IBOutlet weak var imageLogin: UIImageView!
    @IBOutlet weak var myTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Goi tableview
        myTable.delegate = self
        myTable.dataSource = self

        // //Chen hinh anh vao imageView
//        imageLogin.image = UIImage(named: "imageLogin.png")
        
        // Do any additional setup after loading the view.
    }
    
    //Truoc khi xuat hien man hinh thi tien hanh ket noi CSDL va lay du lieu ve de hien thi
    override func viewWillAppear(_ animated: Bool) {
        arrayMenu = FMDBDatabaseModel.getInstance().getDataFromDB()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenu.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
         // Configure the cell to display information of menu
        var objectMenu = Tbl_Menu()
        objectMenu = arrayMenu.object(at: indexPath.row) as! Tbl_Menu
        
        //Khoi tao 1 UIImageView
        let imgNew : UIImageView = UIImageView(frame: CGRect(x: 4, y: 2, width: 40, height: 40))
        imgNew.image = UIImage(named: objectMenu.menuPhoto)//Gan ten hinh anh
        cell.addSubview(imgNew) //add hinh anh vao cell
        
        //Khoi tao 1 label de hien thi ten menu
        let lblContent = UILabel(frame: CGRect(x: 52, y: 2, width: 245, height: 40))
        lblContent.text = objectMenu.menuContent
        lblContent.font = UIFont(name: "Times New Roman", size: 20)//Thay doi font va size cua chu
        cell.addSubview(lblContent)
        
        return cell
        
    }
    
    //Ham chinh kich thuoc cua  cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        //Bat dong dang chon
//        let indexSelected = myTable.indexPathForSelectedRow
//
//        var objectMenu = Tbl_Menu()
//        objectMenu = arrayMenu.object(at: (indexSelected?.row)!) as! Tbl_Menu
//        var menu_id: String! = objectMenu.menuID
//
//        if menu_id == "TC"{
//              var secondController = segue.destination as! MainTableViewController
//        } else{
//            //Truyen tham so
//            var secondController = segue.destination as! CategoriesViewController
//           secondController.thamSoMenu_id = menu_id
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
