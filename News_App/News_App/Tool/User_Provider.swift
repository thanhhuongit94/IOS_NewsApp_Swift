//
//  User_Provider.swift
//  News_App
//
//  Created by huongnguyen on 27/11/2018.
//  Copyright © 2018 huongnguyen. All rights reserved.
//

import Foundation

class User_Provider{
    public var canAdd : Bool? , canModify : Bool = false, canDelete : Bool?;
    static var username : String = ""
    //Phan quyen theo chuc nang
    func User_Provider(MenuID : String)
    {
        let item : Tbl_Permission = PermissionDAO().getPermissionAccordingMenuID(menu_id: MenuID)//lay du lieu tu csdl
        let permissionString : String = item.Permiss
        let arrayPermiss : [String] = permissionString.components(separatedBy: "&") //Cat chuoi gan vao mang

        for permission in arrayPermiss
        {
            switch permission {
            case "A"://add enable true
                canAdd = true;
            case "M"://modify enable true
                canModify = true;
            case "D"://delete enable true
                canDelete = true;
            case "F"://all button enable true
                canAdd = true;
                canDelete = true;
                canModify = true;
            case "N"://all button enable false
                canAdd = false;
                canDelete = false;
                canModify = false;
            default:
                break
            }
        }
    }
    
    //Kiem tra khoang trang trong chuoi
    func checkSpaceInString(string : String) -> Bool {
        for char in string {
            if char == " " {
                return true
            }
        }
        return false
    }
    
    //Check username is exists
    func checkUsernameIsExists(username : String) -> Bool{
        let conditional : String = " WHERE username = '"+username+"'"
        let arrayUser = UsersDAO().getAllUsers(conditional: conditional)
        if arrayUser.count > 0 {
            return true
        }
        return false
    }
}
