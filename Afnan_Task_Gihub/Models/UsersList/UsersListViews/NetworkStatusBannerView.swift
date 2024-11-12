//
//  NetworkStatusBannerView.swift
//  GitHubExplorer
//
//  Created by Afnan Alotaibi on 10/05/1446 AH.
//

import SwiftUI

struct NetworkStatusBannerView: View {
    var body: some View {
        HStack {
            Image(systemName: "wifi.exclamationmark")
                .imageScale(.large)
            Text("You are not connected to the Internet")
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .background(Color.red.opacity(0.7))
    }
}
