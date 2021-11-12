//
//  DatabaseManager.swift
//  Schingen
//
//  Created by Ozan Barış Günaydın on 11.11.2021.
//

import Foundation
import FirebaseDatabase

//Singleton:

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
   
}

//MARK: - Account Management

extension DatabaseManager {
    /// Checking the user E-mail
    public func userExists(with email: String, completion: @escaping ((Bool) -> Void)) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        }
        
    }
    
    /// Insert new users to Firebase Database
    public func  insertUser(with user: SchingenUser) {
        database.child(user.safeEmail).setValue([
            "firs_name" : user.firstName,
            "last_name" : user.lastName
        ])
    }
}

struct SchingenUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
//    let profilePicture: String
}
