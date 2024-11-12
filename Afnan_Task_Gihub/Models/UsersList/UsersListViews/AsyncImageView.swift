//
//  AsyncImageView.swift
//  Afnan_Task_Gihub
//
//  Created by Afnan Alotaibi on 10/05/1446 AH.
//
import SwiftUI

struct AsyncImageView: View {
    let url: URL?
    
    var body: some View {
        AsyncImage(url: url) { image in
            image.resizable()
        } placeholder: {
            Color.gray.opacity(0.2)
        }
    }
}
