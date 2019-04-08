//
//  UsersDAO.swift
//  News_App
//
//  Created by huongnguyen on 08/12/2018.
//  Copyright © 2018 huongnguyen. All rights reserved.
//

import Foundation
class UsersDAO : FMDBDatabaseModel{
    //MARK: Define table name and column name
    //Khai bao ten va cot bang Users
    let tableNameUsers : String = "Users"
    let colUsername: String = "username"
    let colPassword : String = "password"
    let colName: String = "name"
    let colAddress: String = "address"
    let colPostsInterested = "postsInterested"
    
    //MARK: Define func
    //Lay du lieu xac nhan login
    func  checkLogin(_ username : String, _ password: String) -> Tbl_Users {
        shareInstance.database!.open() //Mo ket noi CSDL
        let resultSet: FMResultSet! = shareInstance.database!.executeQuery("SELECT * FROM " + tableNameUsers + " WHERE username = " + "'"+username+"'" + " AND password = " + "'"+EncryptPassword().encryptPass(password: password)+"'" , withArgumentsIn: [0])
        
        let item: Tbl_Users = Tbl_Users()
        
        if resultSet != nil{
            while resultSet.next(){
                item.username = String(resultSet.string(forColumn: colUsername)!)
                item.password = String(resultSet.string(forColumn: colPassword)!)
                item.name = String(resultSet.string(forColumn: colName)!)
                item.address = String(resultSet.string(forColumn: colAddress)!)
                item.postsInterested = String(resultSet.string(forColumn: colPostsInterested)!)
            }
        }
        shareInstance.database!.close() //Dong ket noi CSDL
        return item
    }
    
    //Lay du lieu bang Users
    func  getAllUsers(conditional : String) -> NSMutableArray {
        shareInstance.database!.open() //Mo ket noi CSDL
        let resultSet: FMResultSet! = shareInstance.database!.executeQuery("SELECT * FROM " + tableNameUsers + conditional, withArgumentsIn: [0])
        let arrayUsers : NSMutableArray = NSMutableArray()
        if resultSet != nil{
            while resultSet.next(){
                let item: Tbl_Users = Tbl_Users()
                item.username = String(resultSet.string(forColumn: colUsername)!)
                item.password = String(resultSet.string(forColumn: colPassword)!)
                item.name = String(resultSet.string(forColumn: colName)!)
                item.address = String(resultSet.string(forColumn: colAddress)!)
                item.postsInterested = String(resultSet.string(forColumn: colPostsInterested)!)
                arrayUsers.add(item)
            }
        }
        shareInstance.database!.close() //Dong ket noi CSDL
        return arrayUsers
    }
    
    //MARK: Insert/Update/Delete
    //Insert du lieu vao bang Users
    func insertNewUser(user : Tbl_Users) -> Bool {
        shareInstance.database!.open()//Mo ket noi CSDL
        let sql : String = "INSERT INTO " + tableNameUsers + "(" + colUsername + ", " + colPassword + ", " + colName + ", " + colAddress + ") VALUES(?,?,?,?)"
        let isInsert = shareInstance.database!.executeUpdate(sql, withArgumentsIn: [user.username, user.password, user.name, user.address])
        
        shareInstance.database!.close()//Dong ket noi CSDL
        return (isInsert != nil)
    }
    
    //Update du lieu bang Users
    func updateUser(user: Tbl_Users)->NSMutableArray{
        shareInstance.database!.open()//Mo ket noi CSDL
        let sql : String = "UPDATE " + tableNameUsers + " SET " + colName + " = ?, " + colAddress + " = ? , " + colPassword + " = ? WHERE " + colUsername + " = " + "'" + user.username + "'"
        let resultSet = shareInstance.database!.executeQuery(sql, withArgumentsIn: [user.name, user.address, user.password])
        let arrayUsers : NSMutableArray = NSMutableArray()
        if resultSet != nil{
            while resultSet!.next(){
                let item: Tbl_Users = Tbl_Users()
                item.username = String(resultSet!.string(forColumn: colUsername)!)
                item.password = String(resultSet!.string(forColumn: colPassword)!)
                item.name = String(resultSet!.string(forColumn: colName)!)
                item.address = String(resultSet!.string(forColumn: colAddress)!)
                item.postsInterested = String(resultSet!.string(forColumn: colPostsInterested)!)
                arrayUsers.add(item)
            }
        }
        shareInstance.database!.close() //Dong ket noi CSDL
        return arrayUsers
    }
    
    
    //Delete du lieu bang Users
    func deleteUser(usernameDele : String)->NSMutableArray{
        FMDBDatabaseModel.getInstance().database?.open()
        shareInstance.database!.open()//Mo ket noi CSDL
        let sql : String = "DELETE FROM " + tableNameUsers + " WHERE " + colUsername + " = ? "
        let resultSet = shareInstance.database!.executeQuery(sql, withArgumentsIn: [usernameDele])
        
        let arrayUsers : NSMutableArray = NSMutableArray()
        if resultSet != nil{
            while resultSet!.next(){
                let item: Tbl_Users = Tbl_Users()
                item.username = String(resultSet!.string(forColumn: colUsername)!)
                item.password = String(resultSet!.string(forColumn: colPassword)!)
                item.name = String(resultSet!.string(forColumn: colName)!)
                item.address = String(resultSet!.string(forColumn: colAddress)!)
                item.postsInterested = String(resultSet!.string(forColumn: colPostsInterested)!)
                arrayUsers.add(item)
            }
        }
        shareInstance.database!.close() //Dong ket noi CSDL
        return arrayUsers
    }
    
    //MARK: Change pass
    //Update du lieu bang Users
    func changePass(newPass : String , username : String)->Tbl_Users{
        shareInstance.database!.open()//Mo ket noi CSDL
        let sql : String = "UPDATE " + tableNameUsers + " SET " + colPassword + " = ?  WHERE " + colUsername + " = " + "'" + username + "'"
        let resultSet = shareInstance.database!.executeQuery(sql, withArgumentsIn: [newPass])
        let item: Tbl_Users = Tbl_Users()
        if resultSet != nil{
            while resultSet!.next(){
                item.username = String(resultSet!.string(forColumn: colUsername)!)
                item.password = String(resultSet!.string(forColumn: colPassword)!)
                item.name = String(resultSet!.string(forColumn: colName)!)
                item.address = String(resultSet!.string(forColumn: colAddress)!)
                item.postsInterested = String(resultSet!.string(forColumn: colPostsInterested)!)
            }
        }
        shareInstance.database!.close() //Dong ket noi CSDL
        return item
    }
    
    //Update du lieu bang Users
    func updateNewsEnjoy(newsEnjoy: String, username : String)->Tbl_Users{
        shareInstance.database!.open()//Mo ket noi CSDL
        let sql : String = "UPDATE " + tableNameUsers + " SET " + colPostsInterested + " = ? WHERE " + colUsername + " = " + "'" + username + "'"
        let resultSet = shareInstance.database!.executeQuery(sql, withArgumentsIn: [newsEnjoy])
        let user: Tbl_Users = Tbl_Users()
        if resultSet != nil{
            while resultSet!.next(){
                user.username = String(resultSet!.string(forColumn: colUsername)!)
                user.password = String(resultSet!.string(forColumn: colPassword)!)
                user.name = String(resultSet!.string(forColumn: colName)!)
                user.address = String(resultSet!.string(forColumn: colAddress)!)
                user.postsInterested = String(resultSet!.string(forColumn: colPostsInterested)!)
            }
        }
        shareInstance.database!.close() //Dong ket noi CSDL
        return user
    }
}
