//
//  DatabaseService.swift
//  GithubUserList_MVVM_CoreData (iOS)
//
//  Created by Vince Santos on 12/27/21.
//

import Foundation
import CoreData

protocol DatabaseServiceDelegate: AnyObject {
    func coreDataDidError(error: String)
}

class DatabaseService: ObservableObject {
    static let shared = DatabaseService()
    weak var delegate: DatabaseServiceDelegate?
    private var managedContext: NSManagedObjectContext!
    private var entity: NSEntityDescription!
    private var localGithubUsers: NSManagedObject!
    private var fetchRequest: NSFetchRequest<NSManagedObject>!
    
    let container = NSPersistentContainer(name: "GithubUserList-MVVM-Coredata")
    
    init() {
        container.loadPersistentStores { [self] description, error in
            if let hasError = error {
                delegate?.coreDataDidError(error: hasError.localizedDescription)
            } else {
                managedContext = container.viewContext
                entity = NSEntityDescription.entity(forEntityName: GithubUser.description(), in: managedContext)
                localGithubUsers = NSManagedObject(entity: entity, insertInto: managedContext)
                fetchRequest = NSFetchRequest<NSManagedObject>(entityName: GithubUser.description())
            }
        }
    }
    
    func saveGithubUsers(githubUsers: [GithubUserModel], completion: @escaping (Result<[GithubUserModel], Error>) -> Void) {
        container.viewContext.perform { [self] in
            for user in githubUsers {
                let githubUserEntity = GithubUser(context: container.viewContext)
                githubUserEntity.id = user.id
                githubUserEntity.login = user.login
                githubUserEntity.type = user.type
                githubUserEntity.avatartUrl = user.avatarUrl
            }
            
            do {
                try container.viewContext.save()
                completion(.success(githubUsers))
            } catch {
                completion(.failure(error))
                fatalError(error.localizedDescription)
            }
        }
    }
}
