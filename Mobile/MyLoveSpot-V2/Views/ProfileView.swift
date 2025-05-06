//
//  ProfileView.swift
//  MyLoveSpot-V2
//
//  Created by Quentin Brejoin on 3/4/25.
//

import SwiftUI

struct SettingsRow: View {
    var icon: String
    var label: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .frame(width: 35, height: 35)
                .padding(.leading, 30)
                .padding(.trailing, 10)

            Text(label)
                .font(.title2)
                .fontWeight(.medium)

            Spacer()

            Image(systemName: "chevron.right")
                .resizable()
                .frame(width: 12, height: 19)
                .foregroundColor(.black)
                .padding(.trailing, 30)
        }
        Divider()
            .padding(.horizontal, 15)
    }
}

struct ProfileView: View {
    @Binding var spots: [Spots]
    @Binding var selectedSpot: Spots?
    @EnvironmentObject var authManager: AuthenticationManager

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Profile")
                        .font(.largeTitle).bold()
                        .padding(.leading,30)
                        .padding(.top, 20)
                    
                    // Profile Card REPLACE This with the actual UserView
                    NavigationLink(destination: UserView()) {
                        HStack {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 55, height: 55)
                                .foregroundColor(.black)
                                .padding()

                            VStack(alignment: .leading) {
                                Text("User name")
                                    .foregroundColor(.black)

                                Text("Show Profile")
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .resizable()
                                .frame(width: 12, height: 19)
                                .foregroundColor(.black)
                                .padding(.trailing, 20)
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 15)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    }

                    Text("Settings")
                        .font(.largeTitle).bold()
                        .padding(.leading,30)

                    HStack {
                        Image(systemName: "bell.circle")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .padding(.leading, 30)
                            .padding(.trailing, 10)

                        Text("Notifications")
                            .font(.title2)
                            .fontWeight(.medium)

                        Spacer()
                        Toggle(isOn: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is On@*/.constant(true)/*@END_MENU_TOKEN@*/) {
                            
                        }.padding(.trailing, 30)
                    }
                    Divider()
                        .padding(.horizontal, 15)
                

                    Text("Support")
                        .font(.largeTitle).bold()
                        .padding(.leading,30)

                    SettingsRow(icon: "questionmark.circle", label: "Help Center")
                    SettingsRow(icon: "envelope.circle", label: "Contact us")
                    SettingsRow(icon: "pencil", label: "Give us feedback")
                }
                .padding(.bottom, 40)
                Button("Logout") {
                    authManager.logout()
                }
                .foregroundColor(Color.red)
                Spacer()
            }
        }
    }
}

// helpcenter create FAQ's for user to look through

// user profile will just be the spots the have posted/created

// Contact us is what you expect it to be
// feedback is a link to write a review for the app on the app store
