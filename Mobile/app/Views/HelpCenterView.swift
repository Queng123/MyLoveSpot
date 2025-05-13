//
//  HelpCenter.swift
//  MyLoveSpot-V2
//
//  Created by Marco Robles on 5/1/25.
//

import SwiftUI


var list_of_FAQs = ["How can I create an account?" : "To create an account, if already logged into one navigate to the user profile and log out. You will then be shown a login screen. There will be a button at the bottom that says 'sign up'. Click sign up and enter in your information.", "How can I turn notifications off?" : "To turn notificaitons off naviate to the setting at and toggle the button next to notificaitons. If it is already off navigate to the setting on your mobile device. Enter the notification tab and look for our app there to change the notification settings!", "How can I create a post?" : "Naviate to the list of spots by pressing the pin icon on the bottom left of the screen. Click on the black plus button on the bottom right, above the navigation bar", "How can I review a spot?" : "Navigate to the spot you would like to review. Click on the star rating, give your rating out of five stars and click on the blue button that says submit. ", "How can I add a spot to my favorites?" : "Navigate to the spot you would like to favorite, click on the red heart, a popup to rate the spot will show up. Above the rating will be the name of spot and a red heart. Click on the read heart and when it is added to your favorites the heart will change colors to red"]
// CONVERT THIS TO an array of key value pairs
 
struct FAQBox: View{
    var Question: String
    var Answer: String
    var body: some View {
        GroupBox(label: Text(Question)) {
            Text(Answer).padding(5)
        }.padding(10)
            .shadow(color: Color.gray.opacity(0.4), radius: 10, x: 0, y: 5)

    }
    
}

struct HelpCenterView: View{
    var body: some View{
        
        VStack(alignment: .leading, spacing: 20) {
            
            // Profile Header
            Text("Help Center FAQ's")
                .font(.largeTitle).bold()
                .padding(.leading,5)
                .padding( 20)
        }.frame(maxWidth: .infinity)
        
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(Array(list_of_FAQs), id: \.0) { q, a in
                            FAQBox(Question: q, Answer: a)
                        }
            }
        }.frame(maxWidth: .infinity)
    }
}

#Preview{
    HelpCenterView()
}
