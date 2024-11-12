//
//  UserCellView.swift
//  GitHubExplorer
//
//  Created by Afnan Alotaibi on 08/05/1446 AH.
//

import SwiftUI

struct UserCellView: View {
    var username: String
    var imageURL: URL?

    var body: some View {
        HStack {
            AsyncImage(url: imageURL) { image in
                image.resizable().scaledToFit().frame(width: 40, height: 40)
            } placeholder: {
                ProgressView()
            }

            Text(username)
                .font(.headline)
                .padding(.leading, 10)
        }
        .padding()
    }
}
