//
//  ContactUs.swift
//  MyLoveSpot-V2
//
//  Created by Marco Robles on 5/12/25.
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?

    var subject: String
    var recipients: [String]
    var messageBody: String

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(presentation: Binding<PresentationMode>, result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }

        func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            defer {
                $presentation.wrappedValue.dismiss()
            }

            if let error = error {
                self.result = .failure(error)
            } else {
                self.result = .success(result)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation, result: $result)
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.setSubject(subject)
        vc.setToRecipients(recipients)
        vc.setMessageBody(messageBody, isHTML: false)
        vc.mailComposeDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}


struct ContactUs: View{
    @State private var showMailView = false
     @State private var result: Result<MFMailComposeResult, Error>? = nil
     @State private var showAlert = false
    var body: some View{
        VStack(spacing: 20) {
                    Text("Contact Us")
                        .font(.largeTitle)
                        .bold()

                    Text("We'd love to hear from you! Tap the button below to send us an email.")
                        .multilineTextAlignment(.center)
                        .padding()

                    Button(action: {
                        if MFMailComposeViewController.canSendMail() {
                            showMailView = true
                        } else {
                            showAlert = true
                        }
                    }) {
                        Text("Send Email")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .cornerRadius(12)
                            .shadow(radius: 4)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Mail Not Setup"),
                              message: Text("Please configure your Mail app to send emails."),
                              dismissButton: .default(Text("OK")))
                    }
                }
                .sheet(isPresented: $showMailView) {
                    MailView(
                        result: $result,
                        subject: "App Feedback",
                        recipients: ["contact@mylovespot.org"],
                        messageBody: "Hi, I would like to..."
                    )
                }
                .padding()
            }
    }
    



#Preview {
    ContactUs()
}
