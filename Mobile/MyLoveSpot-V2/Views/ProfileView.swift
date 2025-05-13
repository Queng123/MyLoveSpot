//
//  ProfileView.swift
//  MyLoveSpot-V2
//
//  Created by Quentin Brejoin on 3/4/25.
//

import SwiftUI

struct SettingsRow<Content: View>: View {
    var icon: String
    var label: String
    let destination: Content

    init(icon: String, label: String, @ViewBuilder destination: () -> Content) {
          self.icon = icon
          self.label = label
          self.destination = destination()
      }
    
    var body: some View {
        
        NavigationLink(destination: destination){
            
            
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
        }.foregroundColor(.black)
        Divider()
            .padding(.horizontal, 15)
    }
}


func openAppStoreReview() {
    let appStoreID = "YOUR_APP_ID"
        if let url = URL(string: "https://apps.apple.com/app/id\(appStoreID)?action=write-review") {
            UIApplication.shared.open(url)
        }
    }

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthenticationManager

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Profile")
                        .font(.largeTitle).bold()
                        .padding(.leading,30)
                        .padding(.top, 20)
                    
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

                    SettingsRow(icon: "questionmark.circle", label: "Help Center"){
                        HelpCenterView()
                    }
                    SettingsRow(icon: "envelope.circle", label: "Contact us"){
                        ContactUs()
                    }

                        
                    Button(action: openAppStoreReview){
                            
                            HStack {
                                Image(systemName: "pencil")
                                    .resizable()
                                    .frame(width: 35, height: 35)
                                    .padding(.leading, 30)
                                    .padding(.trailing, 10)
                                
                                Text("Give us feedback")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .frame(width: 12, height: 19)
                                    .foregroundColor(.black)
                                    .padding(.trailing, 30)
                            }
                        }.foregroundColor(.black)
                        Divider()
                            .padding(.horizontal, 15)
                    
                    
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
#Preview{
    ProfileView()
}
