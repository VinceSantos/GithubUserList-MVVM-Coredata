//
//  APIServiceModel.swift
//  GithubUserList_MVVM_CoreData (iOS)
//
//  Created by Vince Santos on 12/29/21.
//

import Foundation

struct ErrorMessages {
    static let serverErrorMessage = "Failed to reach server."
}

struct StringError: Error {
    var message: String
}
