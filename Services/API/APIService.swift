//
//  APIService.swift
//  GithubUserList_MVVM_CoreData (iOS)
//
//  Created by Vince Santos on 02/09/22.
//

import Foundation
import SwiftyJSON
import SwiftUI

final class APIService: ObservableObject {
    static let shared = APIService()
    private let databaseService = DatabaseService.shared
    
    func getProductList(isUserInitiated: Bool, completion: @escaping (Result<[GithubUserModel], StringError>) -> Void){
        guard let url = URL(string: Constants.githubUsersUrl) else { return }
        
        DispatchQueue.global(qos: isUserInitiated ? .userInitiated : .background).async {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                DispatchQueue.main.async { [self] in
                    if let hasData = data {
                        if let dataJson = try? JSON(data: hasData) {
                            if let jsonArray = dataJson.array {
                                var githubUsers = [GithubUserModel]()
                                for item in jsonArray {
                                    let user = GithubUserModel(id: item["id"].int16Value, login: item["login"].stringValue, type: item["type"].stringValue, avatarUrl: item["avatar_url"].stringValue)
                                    githubUsers.append(user)
                                }
                                databaseService.saveGithubUsers(githubUsers: githubUsers) { result in
                                    switch result {
                                    case .success(let users):
                                        completion(.success(users))
                                    case .failure(let error):
                                        completion(.failure(.init(message: error.localizedDescription)))
                                    }
                                }
                            }
                        } else {
                            if let hasError = error {
                                completion(.failure(.init(message: hasError.localizedDescription)))
                            }
                        }
                    } else {
                        completion(.failure(.init(message: ErrorMessages.serverErrorMessage)))
                    }
                }
            }.resume()
        }
    }
}
