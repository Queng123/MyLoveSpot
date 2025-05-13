//
//  UserView.swift
//  MyLoveSpot-V2
//
//  Created by Quentin Brejoin on 5/6/25.
//

import SwiftUI
struct UserView: View {
    
    @State private var name = ""
    @State private var email = ""
    @State private var oldPassword = ""
    @State private var newPassword: String = ""
    @State private var message: String?
    @State private var isLoading: Bool = false
    @State private var showSaveSuccess: Bool = false
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        
        Group{
            if !name.isEmpty {
                
                VStack (alignment: .leading, spacing: 20){
                    HStack{
                        Text("Profile")
                            .font(.largeTitle).bold()
                            .padding(.top, 20)
                            .padding(.leading,30)
                        Spacer()
                    }
                    
                    
                    
                    HStack {
                        Text("Username")
                            .font(.title3).bold()
                        Spacer()
                        Text(name)
                            .padding(.trailing,80)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .padding(.horizontal)
                    
                    HStack {
                        Text("Email")
                            .font(.title3).bold()
                        Spacer()
                        Text(email)
                            .padding(.trailing,80)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .padding(.horizontal)
                    
                    Text("Change password")
                        .font(.title3).bold()
                        .padding(.leading,25)
                    
                    VStack{
                        HStack{
                            SecureField("Current Password", text: $oldPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                            SecureField("New Password", text: $newPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                            
                        }
                        
                        Button(action: {
                            saveChanges()
                        }) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                } else {
                                    Text("Save Changes")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                        
                        if showSaveSuccess {
                            Text("Changed successfully!")
                                .foregroundColor(.green)
                                .transition(.opacity)
                                .padding()
                        }
                    }.padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                        .padding(.horizontal)
                    Spacer()
                }
                
            } else {
                ProgressView().onAppear {
                    authManager.fetchUserProfile { result in
                        switch result {
                        case .success(let profile):
                            self.name = profile["name"] as? String ?? ""
                            self.email = profile["email"] as? String ?? ""
                        case .failure(let error):
                            print("Failed to fetch profile:", error)
                            
                        }
                    }
                }
            }
        }
        
        
    }
    
    func saveChanges() {
        isLoading = true
        message = nil
        
        authManager.changePassword(oldPassword: oldPassword, newPassword: newPassword) { success, error in
            DispatchQueue.main.async {
                isLoading = false
                if success {
                    message = "Password changed successfully"
                    showSaveSuccess = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showSaveSuccess = false
                    }
                } else {
                    message = error ?? "Failed to change password"
                }
            }
        }
    }
    
}
