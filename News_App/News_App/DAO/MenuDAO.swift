//
//  MenuDAO.swift
//  News_App
//
//  Created by huongnguyen on 08/12/2018.
//  Copyright © 2018 huongnguyen. All rights reserved.
//

import Foundation
import UIKit

class MenuDAO {
    //MARK: Properties of table in database
    //Khai bao tablename va cac column cua tablename do
    let tableNameMenu : String = "Menu"
    let colMenuID : String = "MenuID"
    let colMenuContent :String = "Menu_content"
    let colMenuPhoto : String = "Menu_photo"
    
    //MARK: Define func with database
    //Lay ten menu_content tuong ung voi menuID tu bang Menu de hien thi theo phan quyen cua user dang dang nhap
    func getMenuContentAccordingPermission(menuID: String!) -> Tbl_Menu {
        shareInstance.database!.open() //Mo ket noi CSDL
        
        let resultSet: FMResultSet! = shareInstance.database!.executeQuery("SELECT * FROM " + tableNameMenu + " WHERE " + colMenuID + " = " + "'"+menuID+"'", withArgumentsIn: [0])
        let item : Tbl_Menu = Tbl_Menu()
        if resultSet != nil{
            while resultSet.next(){
                item.menuID = String(resultSet.string(forColumn: colMenuID)!)
                item.menuContent = String(resultSet.string(forColumn: colMenuContent)!)
                
                let menuPhoto = String(resultSet.string(forColumn: colMenuPhoto)!)
                //MARK: Change string-> image
                let dataDecoded : Data = Data(base64Encoded: menuPhoto ?? "", options: .ignoreUnknownCharacters)!
                let decodedimage = UIImage(data: dataDecoded)
                item.menuPhoto = decodedimage
            }
        }
        shareInstance.database!.close() //Dong ket noi CSDL
        return item //Tra ve danh sach Menu
    }
}
