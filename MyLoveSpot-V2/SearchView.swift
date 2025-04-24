//
//  SearchView.swift
//  MyLoveSpot-V2
//
//  Created by Mael Pompilius on 4/22/25.
//

import SwiftUI

struct SearchModule: View {
    @Binding var isShowing: Bool
    @State private var showNearby = false
    @State private var showFunExperiences = false
    @State private var showClassicPlaces = false
    @State private var showWhenSection = false
    @Binding var searchText: String
    @FocusState private var isSearchFieldFocused: Bool
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 10)
                
                TextField("Search", text: $searchText)
                    .padding(10)
                    .focused($isSearchFieldFocused)
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isShowing = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 10)
                }
            }
            .background(Color(.systemGray6))
            .cornerRadius(20)
            .padding(.horizontal)
            .padding(.top)
            
            VStack(spacing: 16) {
                if showNearby || isShowing {
                    CategoryButton(
                        icon: "location.north.fill",
                        iconBackground: Color.blue.opacity(0.2),
                        title: "Nearby"
                    )
                    .transition(.scale.combined(with: .opacity))
                }
                
                if showFunExperiences || isShowing {
                    CategoryButton(
                        icon: "flame.fill",
                        iconBackground: Color.red.opacity(0.2),
                        title: "Fun experiences"
                    )
                    .transition(.scale.combined(with: .opacity))
                }
                
                if showClassicPlaces || isShowing {
                    CategoryButton(
                        icon: "bed.double.fill",
                        iconBackground: Color.green.opacity(0.2),
                        title: "Classic places"
                    )
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding()
            
            if showWhenSection || isShowing {
                VStack(alignment: .leading, spacing: 16) {
                    Text("When")
                        .font(.headline)
                        .padding(.leading)
                    
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(.red)
                                Text("Now")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        }
                        
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.gray)
                                Text("Dates")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
                .background(Color.white)
                .cornerRadius(20)
                .padding()
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            Spacer()
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .onAppear {
            animateElements()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isSearchFieldFocused = true
            }
        }
    }
    
    private func animateElements() {
        withAnimation(.easeInOut(duration: 0.3).delay(0.1)) {
            showNearby = true
        }
        withAnimation(.easeInOut(duration: 0.3).delay(0.2)) {
            showFunExperiences = true
        }
        withAnimation(.easeInOut(duration: 0.3).delay(0.3)) {
            showClassicPlaces = true
        }
        withAnimation(.easeInOut(duration: 0.3).delay(0.4)) {
            showWhenSection = true
        }
    }
}

struct CategoryButton: View {
    let icon: String
    let iconBackground: Color
    let title: String
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(iconBackground)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .foregroundColor(iconBackground.opacity(2))
                        .font(.system(size: 20))
                }
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.leading, 8)
        }
        .background(Color.white)
        .cornerRadius(12)
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.3).edgesIgnoringSafeArea(.all)
        SearchModule(isShowing: .constant(true), searchText: .constant(""))
            .padding()
    }
}
