//
//  GithubUsersView.swift
//  GithubUserList_MVVM_CoreData (iOS)
//
//  Created by Vince Santos on 2/9/22.
//

import SwiftUI

struct GithubUsersView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .padding()
                        TextField("Search...", text: $viewModel.searchText)
                            .onTapGesture {
                                viewModel.startSearching()
                            }
                        if viewModel.isSearching {
                            Button {
                                viewModel.clearSearchText()
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .padding(.vertical)
                                    .padding(.trailing)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .frame(maxHeight: 44)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                    .padding()
                    .transition(.move(edge: .trailing))
                    .animation(.spring())
                    if viewModel.isSearching {
                        Button {
                            viewModel.stopSearching()
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        } label: {
                            Text("Cancel")
                                .padding(.trailing)
                                .padding(.leading, 0)
                        }
                        .transition(.move(edge: .trailing))
                        .animation(.spring())
                    }
                }
                
                Divider()
                
                ScrollView(showsIndicators: false) {
                    ForEach((0..<viewModel.users.count).filter({
                        viewModel.users[$0].login.lowercased().contains(viewModel.searchText.lowercased()) || viewModel.searchText.isEmpty
                    }), id: \.self) { index in
                        GithubUsersListView(login: viewModel.users[index].login, avatarUrl: viewModel.users[index].avatarUrl)
                    }
                }
            }
            if viewModel.isLoading {
                ZStack {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
            }
        }
        .alert(isPresented: $viewModel.isAlertPresented) {
            Alert(title: Text(viewModel.currentAlertMessage))
        }
        .onAppear {
            viewModel.getGithubUsers()
        }
    }
}

struct GithubUsersView_Previews: PreviewProvider {
    static var previews: some View {
        GithubUsersView()
    }
}
