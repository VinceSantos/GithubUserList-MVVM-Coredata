//
//  GithubUsersListView.swift
//  GithubUserList_MVVM_CoreData (iOS)
//
//  Created by Vince Santos on 2/9/22.
//

import SwiftUI
import Kingfisher

struct GithubUsersListView: View {
    var login: String
    var avatarUrl: String
    
    var body: some View {
        HStack {
            KFImage(URL(string: avatarUrl))
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .shadow(radius: 7)
            Text(login)
            Spacer()
        }
        .padding()
        Divider()
    }
}

struct GithubUsersListView_Previews: PreviewProvider {
    static var previews: some View {
        GithubUsersListView(login: "test", avatarUrl: "test")
    }
}
