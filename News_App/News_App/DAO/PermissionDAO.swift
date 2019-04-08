//
//  PermissionDAO.swift
//  News_App
//
//  Created by huongnguyen on 08/12/2018.
//  Copyright © 2018 huongnguyen. All rights reserved.
//

import Foundation
class PermissionDAO {
    //MARK: Define table name and column name of Permission
    //Khai bao ten va cot cua bang Permission
    let tableNamePermission : String = "Permission"
    let colUsernamePermiss: String = "username"
    let colMenuIDPermiss = "MenuID"
    let colPermiss = "Permiss"
    
    //MARK: Define func excute func with database
    //Lay du lieu bang Permission de hien thi menu theo tai khoan
    func getPermissionFromDB(username: String!) -> NSMutableArray {
        shareInstance.database!.open() //Mo ket noi CSDL
        
        let resultSet: FMResultSet! = shareInstance.database!.executeQuery("SELECT " + colMenuIDPermiss + " , " + colPermiss + " FROM " + tableNamePermission + " WHERE " + colUsernamePermiss + " = " + "'"+username+"'" + " ORDER BY " + "'" + colMenuIDPermiss + "'" + " DESC" , withArgumentsIn: [0])
        
        let arrayPermission:NSMutableArray = NSMutableArray()
        if resultSet != nil{
            while resultSet.next(){
                let item: Tbl_Permission = Tbl_Permission()
                item.MenuIDPermiss = String(resultSet.string(forColumn: colMenuIDPermiss)!)
                item.Permiss = String(resultSet.string(forColumn: colPermiss)!)
                arrayPermission.add(item)
            }
        }
        shareInstance.database!.close() //Dong ket noi CSDL
        return arrayPermission //Tra ve danh sach phan quyen user
    }
    
    //Lay permission cua menu
    func getPermissionAccordingMenuID(menu_id: String!) -> Tbl_Permission {
        shareInstance.database!.open() //Mo ket noi CSDL
        let resultSet: FMResultSet! = shareInstance.database!.executeQuery("SELECT " + colMenuIDPermiss + " , " + colPermiss + " FROM " + tableNamePermission + " WHERE " + colMenuIDPermiss + " = " + "'"+menu_id+"'" , withArgumentsIn: [0])
        
        let item : Tbl_Permission  = Tbl_Permission()
        if resultSet != nil{
            while resultSet.next(){
                item.MenuIDPermiss = String(resultSet.string(forColumn: colMenuIDPermiss)!)
                item.Permiss = String(resultSet.string(forColumn: colPermiss)!)
            }
        }
        shareInstance.database!.close() //Dong ket noi CSDL
        return item //Tra ve danh sach phan quyen user
    }
    
    //MARK: Insert/Update/Delete
    //Insert du lieu vao bang permission
    func insertNewPermission(username : String, menuID : String, permission : String) -> Bool {
        shareInstance.database!.open()//Mo ket noi CSDL
        let sql : String = "INSERT INTO " + tableNamePermission + "(" + colUsernamePermiss + ", " + colMenuIDPermiss + ", " + colPermiss + ") VALUES(?,?,?)"
        let isInsert = shareInstance.database!.executeUpdate(sql, withArgumentsIn: [username, menuID, permission])
        shareInstance.database!.close()//Dong ket noi CSDL
        return (isInsert != nil)
    }
    
    //Update du lieu bang Permission
    func updatePermission(permissionUpdate : Tbl_Permission) -> NSMutableArray{
        shareInstance.database!.open()//Mo ket noi CSDL
        let sql : String = "UPDATE SET " + tableNamePermission + " " + colMenuIDPermiss + " = ?, " + colPermiss + " = ? WHERE " + colUsernamePermiss + " = " + "'" + permissionUpdate.Username + "'"
        let resultSet = shareInstance.database!.executeQuery(sql, withArgumentsIn: [permissionUpdate.MenuIDPermiss, permissionUpdate.Permiss])
        let arrayPermission:NSMutableArray = NSMutableArray()
        if resultSet != nil{
            while resultSet!.next(){
                let item: Tbl_Permission = Tbl_Permission()
                item.MenuIDPermiss = String(resultSet!.string(forColumn: colMenuIDPermiss)!)
                item.Permiss = String(resultSet!.string(forColumn: colPermiss)!)
                arrayPermission.add(item)
            }
        }
        shareInstance.database!.close() //Dong ket noi CSDL
        return arrayPermission //Tra ve danh sach phan quyen user
    }
    
    
    //Delete du lieu bang Permission
    func deletePermission(usernameDele : String) -> NSMutableArray{
        FMDBDatabaseModel.getInstance().database?.open()
        shareInstance.database!.open()//Mo ket noi CSDL
        let sql : String = "DELETE FROM " + tableNamePermission + " WHERE " + colUsernamePermiss + " = ? "
        let resultSet = shareInstance.database!.executeQuery(sql, withArgumentsIn: [usernameDele])
        let arrayPermission:NSMutableArray = NSMutableArray()
        if resultSet != nil{
            while resultSet!.next(){
                let item: Tbl_Permission = Tbl_Permission()
                item.MenuIDPermiss = String(resultSet!.string(forColumn: colMenuIDPermiss)!)
                item.Permiss = String(resultSet!.string(forColumn: colPermiss)!)
                arrayPermission.add(item)
            }
        }
        shareInstance.database!.close() //Dong ket noi CSDL
        return arrayPermission //Tra ve danh sach phan quyen user
    }
}
