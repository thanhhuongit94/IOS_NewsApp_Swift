////
////  BuildLayout.swift
////  News_App
////
////  Created by huongnguyen on 27/11/2018.
////  Copyright © 2018 huongnguyen. All rights reserved.
////
//
//import UIKit
//import Foundation
//class BuilLayout : UIViewController {
//     //Build layout
//    public func BuilLayout(menuID : String, menuContent : String){
//        //Lay du lieu thong tin layout tu CSDL
//        let item : Tbl_Layout = FMDBDatabaseModel.getInstance().getLayoutAccordingMenuID(menu_id: menuID)//lay du lieu tu csdl
//        let layout : String = item.layout
//        let position : String = item.position
//        let arrayLayout : [String] = layout.components(separatedBy: "&") //Cat chuoi gan vao mang
//        let arrayPosition : [String] = position.components(separatedBy: ";")
//        
//        for i in 0 ..< arrayLayout.count {
//            //Lay ra vi tri layout tuong ung
//            let arrayDetailPosition : [String] = arrayPosition[i].components(separatedBy: "&")
//            
//            switch arrayLayout[i] {
//            case "UILable":
//                let label = UILabel(frame: CGRect(x: Int(arrayDetailPosition[0])!, y: Int(arrayDetailPosition[1])!, width: Int(arrayDetailPosition[2])!, height: Int(arrayDetailPosition[3])!))
//                label.textAlignment = .center
//                label.font = UIFont(name: "Times New Roman", size: 18)
//                label.text = menuContent
//                self.view.addSubview(label)
//            case "UIButton":
//                let button = UIButton()
//                button.frame = CGRect(x: self.view.frame.size.width - 60, y: 60, width: 50, height: 50)
//                button.backgroundColor = UIColor.red
//                button.setTitle("Name your Button ", for: .normal)
//               // button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
//                self.view.addSubview(button)
//            default:
//                break
//            }
//        }
//       
//    }
//}
