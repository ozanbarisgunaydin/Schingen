//
//  ProfileModels.swift
//  Schingen
//
//  Created by Ozan Barış Günaydın on 17.11.2021.
//

import Foundation

enum ProfileViewModelType {
    case info, logOut
}

struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}
