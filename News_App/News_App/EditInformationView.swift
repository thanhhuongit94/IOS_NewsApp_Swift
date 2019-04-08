//
//  EditInformationView.swift
//  News_App
//
//  Created by huongnguyen on 07/12/2018.
//  Copyright © 2018 huongnguyen. All rights reserved.
//

import UIKit

class EditInformationView: UIView {
    
    //MARK: Properties
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtName: UITextField!
    
    var tagOK : Int = 1
    var tagAlert : Int = -1
    
    //MARK: Action
    func btnSave(_ sender: UIButton) {
        if (txtName.text?.isEmpty)!{
            return tagAlert = 0
        }
        
        if (txtAddress.text?.isEmpty)!{
            return tagAlert = 1
        }
        tagAlert = 2
    }
    
}
