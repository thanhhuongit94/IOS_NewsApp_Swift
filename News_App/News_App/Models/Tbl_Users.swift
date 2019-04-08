//
//  Tbl_Users.swift
//  News_App
//
//  Created by huongnguyen on 27/11/2018.
//  Copyright © 2018 huongnguyen. All rights reserved.
//

import Foundation
class Tbl_Users {
    //MARK: Properties
    var username: String = String()
    var password : String = String()
    var name: String = String()
    var address: String = String()
    var postsInterested : String? = String()
    
    //Contructor
    init(){}
    
    init? (username: String, password : String, name : String, address: String, postsEnjoy: String?){
        if username.isEmpty || password.isEmpty || name.isEmpty || address.isEmpty {
            return nil
        }
        
        self.username = username
        self.password = password
        self.name = name
        self.address = address
        self.postsInterested = postsEnjoy
    }
    
    func getNewsEnjoy() -> [String] {
        return self.postsInterested!.components(separatedBy: "&")
    }
}
