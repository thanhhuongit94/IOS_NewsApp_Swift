//
//  EncryptPassword.swift
//  News_App
//
//  Created by huongnguyen on 28/11/2018.
//  Copyright © 2018 huongnguyen. All rights reserved.
//

import Foundation
class EncryptPassword {
    //encypt password
    public func encryptPass(password : String) -> String{
        var passAfterEncrypt : String? = ""
        for passChar in password {
            if passChar >= "0" && passChar <= "9" {
                passAfterEncrypt = passAfterEncrypt! + String((Int(String(passChar))! + 7) * 3 - 16 + (Int(String(passChar))! * 2) * 7) + "@af77df"
            } else {
                var number : Int = Int(passChar.unicodeScalars[passChar.unicodeScalars.startIndex].value) // Chuyen sang ma ASCII
                if number < 70 {
                    number = ((number + 18) * 4) / 3
                    passAfterEncrypt = passAfterEncrypt! + String(number) + "@ff00#"
                } else {
                    number = (((number - 7) * 11) / 2) * 5
                    passAfterEncrypt = passAfterEncrypt! + String(number) + "@#fbf00#@"
                }
                
            }
        }
        return passAfterEncrypt!
    }
}
