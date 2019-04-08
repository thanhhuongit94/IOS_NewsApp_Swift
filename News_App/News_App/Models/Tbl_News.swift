//
//  Tbl_News.swift
//  News_App
//
//  Created by huongnguyen on 20/11/2018.
//  Copyright © 2018 huongnguyen. All rights reserved.
//

import Foundation
import UIKit

class Tbl_News{
    //MARK: Properties
    var news_id : String = String()
    var news_name: String = String()
    var nameNotStamp : String = String()
    var news_content: String = String()
    var author: String = String()
    var datePost: String = String()
    var news_photo: UIImage?
    var parent_ID: String? = String()
    var username : String? = String()
    
    //MARK: Contructor
    init(){}
    init?(news_name : String , nameNotStamp : String, news_content : String, author : String, datePost: String, news_photo: UIImage?, parent_ID: String?, username : String?){
        if news_name.isEmpty || nameNotStamp.isEmpty || news_content.isEmpty || author.isEmpty || datePost.isEmpty {
            return nil
        }
        self.news_name = news_name
        self.nameNotStamp = nameNotStamp
        self.news_content = news_content
        self.author = author
        self.datePost = datePost
        self.news_photo = news_photo
        self.parent_ID = parent_ID
        self.username = username
    }
}
