//
//  NewsDAO.swift
//  News_App
//
//  Created by huongnguyen on 08/12/2018.
//  Copyright © 2018 huongnguyen. All rights reserved.
//

import Foundation
import UIKit

class NewsDAO {
    //MARK: Define table name and column name table News
    //Khai bao ten va cac cot cua bang News
    let tableNameNews : String = "News"
    let colNewsID : String = "news_id"
    let colNewsName: String = "news_name"
    let colNameNotStamp : String = "contentNotStamp"
    let colNewsContent : String = "news_content"
    let colAuthor: String = "author"
    let colDate : String = "datePost"
    let colNewsPhoto: String = "new_photo"
    let colParentID : String = "parent_ID"
    let colUsername: String = "username"
    
    init(){}
    
    //MARK: Define func with database
    //Lay du lieu tu database tu tablename = News
    func getDataNewsFromDB(_ conditional: String) -> NSMutableArray {
        FMDBDatabaseModel.getInstance().database?.open()
        shareInstance.database!.open() //Mo ket noi CSDL
        
        let resultSet: FMResultSet! = shareInstance.database!.executeQuery("SELECT * FROM " + tableNameNews + conditional, withArgumentsIn: [0])
        
        let arrayNews:NSMutableArray = NSMutableArray()
        if resultSet != nil{
            while resultSet.next(){
                let item: Tbl_News = Tbl_News()
                item.news_id = String(resultSet.int(forColumn: colNewsID))
                item.news_name = String(resultSet.string(forColumn: colNewsName)!)
                item.nameNotStamp = String(resultSet.string(forColumn: colNameNotStamp)!)
                item.news_content = String(resultSet.string(forColumn: colNewsContent)!)
                item.author = String(resultSet.string(forColumn: colAuthor)!)
                item.datePost = String(resultSet.string(forColumn: colDate)!)
                
                //lay anh
                let news_photo = String(resultSet.string(forColumn: colNewsPhoto)!)
                //MARK: Change string-> image
                let dataDecoded : Data = Data(base64Encoded: news_photo ?? "", options: .ignoreUnknownCharacters)!
                let decodedimage = UIImage(data: dataDecoded)
                item.news_photo = decodedimage
                
                item.parent_ID = String(resultSet.string(forColumn: colParentID)!)
                item.username = String(resultSet.string(forColumn: colUsername)!)
                arrayNews.add(item)
            }
        }
        shareInstance.database!.close() //Dong ket noi CSDL
        return arrayNews //Tra ve danh sach Menu
    }
    
    //Lay du lieu tu database tu tablename = News theo columName va keyword
    func getDataNewsIntoKeyword(keyWord: String!, colName: String!,_ conditional: String) -> NSMutableArray {
        shareInstance.database!.open() //Mo ket noi CSDL
        
        let resultSet: FMResultSet! = shareInstance.database!.executeQuery("SELECT * FROM " + tableNameNews + " WHERE " + colName + " = " + "'"+keyWord+"'" + conditional, withArgumentsIn: [0])
        
        let arrayNews:NSMutableArray = NSMutableArray()
        if resultSet != nil{
            while resultSet.next(){
                let item: Tbl_News = Tbl_News()
                item.news_id = String(resultSet.int(forColumn: colNewsID))
                item.news_name = String(resultSet.string(forColumn: colNewsName)!)
                item.nameNotStamp = String(resultSet.string(forColumn: colNameNotStamp)!)
                item.news_content = String(resultSet.string(forColumn: colNewsContent)!)
                item.author = String(resultSet.string(forColumn: colAuthor)!)
                item.datePost = String(resultSet.string(forColumn: colDate)!)
                
                //lay anh
                let news_photo = String(resultSet.string(forColumn: colNewsPhoto)!)
                //MARK: Change string-> image
                let dataDecoded : Data = Data(base64Encoded: news_photo ?? "", options: .ignoreUnknownCharacters)!
                let decodedimage = UIImage(data: dataDecoded)
                item.news_photo = decodedimage
                
                item.parent_ID = String(resultSet.string(forColumn: colParentID)!)
                item.username = String(resultSet.string(forColumn: colUsername)!)
                arrayNews.add(item)
            }
        }
        shareInstance.database!.close() //Dong ket noi CSDL
        return arrayNews //Tra ve danh sach Menu
    }
    
    //MARK: Insert/Update/Delete
    //Insert du lieu vao bang News
    func insertNew(news : Tbl_News) -> Bool {
        shareInstance.database!.open()//Mo ket noi CSDL
        //UIImagePNGRepresentation = pngData()
        let imageData : NSData = news.news_photo!.pngData()! as! NSData// meal.mealPhoto : ten di theo data_models
        let news_img = imageData.base64EncodedString(options: .lineLength64Characters)
        
        let sql : String = "INSERT INTO " + tableNameNews + "(" + colNewsName + ", " + colNameNotStamp + " , " + colNewsContent + ", " + colAuthor + ", " + colDate + ", " + colNewsPhoto + ", " + colParentID + ", " + colUsername + ") VALUES(?,?,?,?,?,?,?,?)"
        let isInsert = shareInstance.database!.executeUpdate(sql, withArgumentsIn: [news.news_name, news.nameNotStamp, news.news_content, news.author, news.datePost, news_img, news.parent_ID, news.username])
        shareInstance.database!.close()//Dong ket noi CSDL
        return (isInsert != nil)
    }
    
    
    //Delete du lieu bang News
    func deleteNew(_idNew : String)->NSMutableArray{
        FMDBDatabaseModel.getInstance().database?.open()
        shareInstance.database!.open()//Mo ket noi CSDL
        let sql : String = "DELETE FROM " + tableNameNews + " WHERE " + colNewsID + " = ? "
        let resultSet = shareInstance.database!.executeQuery(sql, withArgumentsIn: [_idNew])
        
        let arrayNews : NSMutableArray = NSMutableArray()
        if resultSet != nil{
            while resultSet!.next(){
                let item: Tbl_News = Tbl_News()
                item.news_id = String(resultSet!.int(forColumn: colNewsID))
                item.news_name = String(resultSet!.string(forColumn: colNewsName)!)
                item.nameNotStamp = String(resultSet!.string(forColumn: colNameNotStamp)!)
                item.news_content = String(resultSet!.string(forColumn: colNewsContent)!)
                item.author = String(resultSet!.string(forColumn: colAuthor)!)
                item.datePost = String(resultSet!.string(forColumn: colDate)!)
               
                //lay anh
                let news_photo = String(resultSet!.string(forColumn: colNewsPhoto)!)
                //MARK: Change string-> image
                let dataDecoded : Data = Data(base64Encoded: news_photo ?? "", options: .ignoreUnknownCharacters)!
                let decodedimage = UIImage(data: dataDecoded)
                item.news_photo = decodedimage
                
                item.parent_ID = String(resultSet!.string(forColumn: colParentID)!)
                item.username = String(resultSet!.string(forColumn: colUsername)!)
                arrayNews.add(item)
            }
        }
        shareInstance.database!.close() //Dong ket noi CSDL
        return arrayNews
    }
    
    //Update du lieu bang News
    func updateNew(News : Tbl_News)->NSMutableArray{
        FMDBDatabaseModel.getInstance().database?.open()
        shareInstance.database!.open()//Mo ket noi CSDL
        
        //UIImagePNGRepresentation = pngData()
        let imageData : NSData = News.news_photo!.pngData()! as! NSData// meal.mealPhoto : ten di theo data_models
        let news_img = imageData.base64EncodedString(options: .lineLength64Characters)
        
        let sql : String = "UPDATE " + tableNameNews + " SET " + colNewsName + " = ?, " + colNameNotStamp + " = ?, " + colAuthor + " = ?, " + colDate + " = ?, " + colNewsContent + " = ?, " + colNewsPhoto + " = ?, " + colParentID + " = ? WHERE " + colNewsID + " = " + "'" + News.news_id + "'"
        let resultSet = shareInstance.database!.executeQuery(sql, withArgumentsIn: [News.news_name, News.nameNotStamp, News.author, News.datePost, News.news_content, news_img, News.parent_ID])
        
        let arrayNews : NSMutableArray = NSMutableArray()
        if resultSet != nil{
            while resultSet!.next(){
                let item: Tbl_News = Tbl_News()
                item.news_id = String(resultSet!.int(forColumn: colNewsID))
                item.news_name = String(resultSet!.string(forColumn: colNewsName)!)
                item.nameNotStamp = String(resultSet!.string(forColumn: colNameNotStamp)!)
                item.news_content = String(resultSet!.string(forColumn: colNewsContent)!)
                item.author = String(resultSet!.string(forColumn: colAuthor)!)
                item.datePost = String(resultSet!.string(forColumn: colDate)!)
               
                //lay anh
                let news_photo = String(resultSet!.string(forColumn: colNewsPhoto)!)
                //MARK: Change string-> image
                let dataDecoded : Data = Data(base64Encoded: news_photo ?? "", options: .ignoreUnknownCharacters)!
                let decodedimage = UIImage(data: dataDecoded)
                item.news_photo = decodedimage
                
                item.parent_ID = String(resultSet!.string(forColumn: colParentID)!)
                item.username = String(resultSet!.string(forColumn: colUsername)!)
                arrayNews.add(item)
            }
        }
        shareInstance.database!.close() //Dong ket noi CSDL
        return arrayNews
    }
    
    //MARK: Insert/Update Category
    //Insert du lieu vao bang News
    func insertCategory(news : Tbl_News) -> Bool {
        shareInstance.database!.open()//Mo ket noi CSDL
        
        //UIImagePNGRepresentation = pngData()
        let imageData : NSData = news.news_photo!.pngData()! as! NSData// meal.mealPhoto : ten di theo data_models
        let news_img = imageData.base64EncodedString(options: .lineLength64Characters)
        
        let sql : String = "INSERT INTO " + tableNameNews + "(" + colNewsName + ", " + colNewsContent + ", " + colNameNotStamp + ", " + colNewsPhoto + ", " + colParentID + ") VALUES(?,?,?,?,?)"
        let isInsert = shareInstance.database!.executeUpdate(sql, withArgumentsIn: [news.news_name, news.news_content, news_img])
        shareInstance.database!.close()//Dong ket noi CSDL
        return (isInsert != nil)
    }
    
    //MARK: Update danh muc
    //Update du lieu danh muc
    func updateCategory(News : Tbl_News)->NSMutableArray{
        FMDBDatabaseModel.getInstance().database?.open()
        shareInstance.database!.open()//Mo ket noi CSDL
        
        //UIImagePNGRepresentation = pngData()
        let imageData : NSData = News.news_photo!.pngData()! as! NSData// meal.mealPhoto : ten di theo data_models
        let news_img = imageData.base64EncodedString(options: .lineLength64Characters)
        
        let sql : String = "UPDATE " + tableNameNews + " SET " + colNewsName + " = ?, " + colNameNotStamp + "= ?, " + colNewsContent + " = ?, " + colNewsPhoto + " = ? WHERE " + colNewsID + " = " + "'" + News.news_id + "'"
        let resultSet = shareInstance.database!.executeQuery(sql, withArgumentsIn: [News.news_name, News.nameNotStamp, News.news_content, news_img])
        
        let arrayNews : NSMutableArray = NSMutableArray()
        if resultSet != nil{
            while resultSet!.next(){
                let item: Tbl_News = Tbl_News()
                item.news_id = String(resultSet!.int(forColumn: colNewsID))
                item.news_name = String(resultSet!.string(forColumn: colNewsName)!)
                item.nameNotStamp = String(resultSet!.string(forColumn: colNameNotStamp)!)
                item.news_content = String(resultSet!.string(forColumn: colNewsContent)!)
                item.author = String(resultSet!.string(forColumn: colAuthor)!)
                item.datePost = String(resultSet!.string(forColumn: colDate)!)
               
                //lay anh
                let news_photo = String(resultSet!.string(forColumn: colNewsPhoto)!)
                //MARK: Change string-> image
                let dataDecoded : Data = Data(base64Encoded: news_photo ?? "", options: .ignoreUnknownCharacters)!
                let decodedimage = UIImage(data: dataDecoded)
                item.news_photo = decodedimage
                
                item.parent_ID = String(resultSet!.string(forColumn: colParentID)!)
                arrayNews.add(item)
            }
        }
        shareInstance.database!.close() //Dong ket noi CSDL
        return arrayNews
    }
    
    //Lay du lieu tu database theo news_id
    func getOneNewsIntoKeyword(keyWord: String!) -> Tbl_News {
        shareInstance.database!.open() //Mo ket noi CSDL
        
        let resultSet: FMResultSet! = shareInstance.database!.executeQuery("SELECT * FROM " + tableNameNews + " WHERE " + colNewsID + " = " + "'"+keyWord+"'", withArgumentsIn: [0])
        
        let item: Tbl_News = Tbl_News()
        if resultSet != nil{
            while resultSet.next(){
                item.news_id = String(resultSet.int(forColumn: colNewsID))
                item.news_name = String(resultSet.string(forColumn: colNewsName)!)
                item.nameNotStamp = String(resultSet.string(forColumn: colNameNotStamp)!)
                item.news_content = String(resultSet.string(forColumn: colNewsContent)!)
                item.author = String(resultSet.string(forColumn: colAuthor)!)
                item.datePost = String(resultSet.string(forColumn: colDate)!)
               
                //lay anh
                let news_photo = String(resultSet.string(forColumn: colNewsPhoto)!)
                //MARK: Change string-> image
                let dataDecoded : Data = Data(base64Encoded: news_photo ?? "", options: .ignoreUnknownCharacters)!
                let decodedimage = UIImage(data: dataDecoded)
                item.news_photo = decodedimage
                
                item.parent_ID = String(resultSet.string(forColumn: colParentID)!)
                item.username = String(resultSet!.string(forColumn: colUsername)!)
            }
        }
        shareInstance.database!.close() //Dong ket noi CSDL
        return item //Tra ve tin duoc tim thay
    }
}
