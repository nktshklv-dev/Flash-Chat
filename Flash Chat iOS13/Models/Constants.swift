//
//  Constants.swift
//  Flash Chat iOS13
//
//  Created by Nikita  on 9/12/22.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import Foundation



struct K {
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "FromRegisterToChat"
    static let loginSegue = "FromLoginToChat"
    static let appName = "KrabskChat"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}

