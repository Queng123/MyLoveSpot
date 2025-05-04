//
//  HelpCenter.swift
//  MyLoveSpot-V2
//
//  Created by Marco Robles on 5/1/25.
//

import SwiftUI


var list_of_FAQs = ["How can I delete a post?" : "To delete a post navigate to your account and select on the post you would like to delete, pressed the edit button in the top right and at the bottom there is a button you can delete the post with.", "How can I turn notifications off?" : "To turn notificaitons off naviate to the setting at and toddle the button next to notificaitons"]
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
                
                FAQBox(Question: "HOW", Answer: "THIS IS THE ANSWER")
                
                ForEach(Array(list_of_FAQs), id: \.0) { q, a in
                            FAQBox(Question: q, Answer: a)
                        }
            }
        }.frame(maxWidth: .infinity)
    }
}
