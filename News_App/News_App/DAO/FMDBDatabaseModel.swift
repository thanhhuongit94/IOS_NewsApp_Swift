//
//  FMDBDatabaseModel.swift
//  News_App
//
//  Created by huongnguyen on 19/11/2018.
//  Copyright © 2018 huongnguyen. All rights reserved.
//

import Foundation
import UIKit

let shareInstance = FMDBDatabaseModel()
class FMDBDatabaseModel : NSObject{
    var database: FMDatabase? = nil
  
    //MARK: Connect and defintion of action database
    class func getInstance() -> FMDBDatabaseModel{
        if shareInstance.database == nil{
            shareInstance.database = FMDatabase(path: Util.getPath(fileName: "News_App_DB.db"))
        }
        return shareInstance
    }
}
