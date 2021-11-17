//
//  UserModel.swift
//  Schingen
//
//  Created by Ozan Barış Günaydın on 17.11.2021.
//

import Foundation

struct SchingenUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    var profilePictureFileName: String {
//        blabla-gmail-com_profile_picture.png
        return "\(safeEmail)_profile_picture.png"
    }
}
