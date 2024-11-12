//
//  UsersListView.swift
//  GitHubExplorer
//
//  Created by Afnan Alotaibi on 06/05/1446 AH.
//

import SwiftUI

struct UserListView: View {
    @ObservedObject var viewModel: UsersListViewModel
    let onPressUser: (String) -> Void
    
    var body: some View {
        VStack {
            if !viewModel.isConnected {
                NetworkStatusBannerView()
                    .frame(height: 40)
            }
            switch viewModel.state {
            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
                Text("Loading...")
                    .padding(.top, 8)
            case .noData:
                Text("No data available")
                    .font(.title2)
                    .foregroundColor(.gray)
            case .success(let usersData):
                List(usersData) { user in
                    UserRowView(
                        name: user.login,
                        image: user.avatarURL,
                        followers: user.followers,
                        Repos: user.publicRepos
                    )
                    .onTapGesture {
                        onPressUser(user.login)
                    }
                }.listStyle(.plain)
            case .failure(let massege):
                Text(massege)
                    .font(.title2)
                    .foregroundColor(.gray)
                
            }
        }
        .animation(.easeInOut, value: viewModel.isConnected)
    }
}

