//
//  UserRowView.swift
//  Afnan_Task_Gihub
//
//  Created by Afnan Alotaibi on 10/05/1446 AH.
//

import SwiftUI

struct UserRowView: View {
    var name: String
    var image: String?
    var followers: Int?
    var Repos: Int?
    
    var body: some View {
        HStack {
            AsyncImageView(url: URL(string: image ?? ""))
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                if let followers = followers {
                    Text("Repos: \(Repos ?? 0) • Followers: \(followers)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.leading, 8)
            Spacer()
        }
    }
}
