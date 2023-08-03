//
//  HomeView.swift
//  Poker-Splitter
//
//  Created by Max Pintchouk on 8/3/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct HomeView: View {
    @EnvironmentObject var session: SessionStore
    @State var email: String = ""
    @State var password: String = ""

    var body: some View {
        VStack {
            if session.session != nil {
                Text("Welcome, \(session.session!.displayName ?? "User")!")
            } else {
                TextField("Email", text: $email)
                SecureField("Password", text: $password)
                Button(action: signIn) {
                    Text("Sign In")
                }
            }
        }.onAppear(perform: session.listen)
    }

    func signIn() {
        session.signIn(email: email, password: password) { (result, error) in
            if let error = error {
                print("Error signing in: \(error)")
                return
            }
            // Handle successful sign in
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(SessionStore())
    }
}
