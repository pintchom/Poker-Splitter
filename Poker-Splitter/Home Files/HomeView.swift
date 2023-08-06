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
    @State var isAuthenticated = false
    @State var errorMessage: String?

    var body: some View {
        VStack {
            if isAuthenticated {
                PokerSplitterView()
            } else {
                if let userSession = session.session, !userSession.uid.isEmpty {
                    Text("Welcome Back!")
                        .padding()
                        .foregroundColor(.black)
                        .font(.largeTitle)
                        .fontWeight(.black)
                    TextField("Email", text: $email)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(50)
                        .multilineTextAlignment(.center)
                    SecureField("Password", text: $password)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(50)
                        .multilineTextAlignment(.center)
                    HStack {
                        Button(action: signIn) {
                            Text("Sign In")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding()
                                .background(.red)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                        
                        Button(action: signUp) {
                            Text("Sign Up")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding()
                                .background(.red)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                    }
                    if let errorMessage = errorMessage {
                                        Text(errorMessage)
                                            .foregroundColor(.red)
                                            .padding()
                                    }
                } else {
                    Text("PokerSplitter")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .frame(width: 400)
                        .ignoresSafeArea()
                        .padding()
                    TextField("Email", text: $email)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(50)
                        .multilineTextAlignment(.center)
                    SecureField("Password", text: $password)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(50)
                        .multilineTextAlignment(.center)
                    
                    HStack {
                        Button(action: signIn) {
                            Text("Sign In")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding()
                                .background(.red)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                        
                        Button(action: signUp) {
                            Text("Sign Up")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding()
                                .background(.red)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                    }
                    .padding(.top)
                    .padding(.top)
                    if let errorMessage = errorMessage {
                                        Text(errorMessage)
                                            .foregroundColor(.red)
                                            .padding()
                                    }
                }
            }
        }.padding(.horizontal).onAppear(perform: session.listen)
    }

    func signIn() {
        session.signIn(email: email, password: password) { (result, error) in
            if let error = error {
                print("Error signing in: \(error)")
                errorMessage = "Account not found. Please try again." // Set error message
                return
            }
           print("Sign In")
            isAuthenticated = true
        }
    }
    func signUp() {
        session.signUp(email: email, password: password) { (result, error) in
            if let error = error {
                print("Error signing up: \(error)")
                return
            }
            print("Signed Up")
            isAuthenticated = true
        }
    }
    func authenticate() {
        isAuthenticated = true
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(SessionStore())
    }
}
