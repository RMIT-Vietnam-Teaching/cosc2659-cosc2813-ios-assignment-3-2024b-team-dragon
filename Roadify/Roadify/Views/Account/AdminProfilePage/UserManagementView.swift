//
//  UserManagementView.swift
//  Roadify
//
//  Created by Lê Phước on 19/9/24.
//

import SwiftUI

struct UserManagementView: View {
    @ObservedObject var viewModel = UserManagementViewModel()

    var body: some View {
        VStack {
            HStack {
                Text("User Management")
                    .font(.title2)
                    .bold()
                Spacer()
                Image(systemName: "magnifyingglass")
                    .font(.title3)
                    .foregroundColor(.white)
            }
            .padding()

            ScrollView {
                ForEach(viewModel.users) { user in
                    UserRow(user: user, approveAction: {
                        viewModel.approveUser(user)
                    }, rejectAction: {
                        viewModel.rejectUser(user)
                    })
                }
            }
        }
        .background(Color("MainColor"))
        .foregroundColor(.white)
        .padding()
    }
}

struct UserRow: View {
    let user: User
    let approveAction: () -> Void
    let rejectAction: () -> Void

    var body: some View {
        HStack {
            // Static profile image
            Image("staticProfilePlaceholder")  // Use your placeholder image name
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(Circle())

            VStack(alignment: .leading) {
                Text(user.username)
                    .font(.headline)
                    .foregroundColor(.green)
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            Button(action: approveAction) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.green)
            }
            .padding(.trailing, 8)

            Button(action: rejectAction) {
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 8)
        .background(Color("ThirdColor").opacity(0.2))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
