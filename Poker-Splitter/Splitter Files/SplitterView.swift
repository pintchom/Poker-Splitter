//
//  HomeView.swift
//  Poker-Splitter
//
//  Created by Max Pintchouk on 8/2/23.
//

import SwiftUI

struct SplitterView: View {
    @State private var hostInput: String = ""
    @State private var paymentInput: String = ""
    @State var host: String = ""
    @State var payment: String = ""
    @State private var navigateToPlayersView = false
    @State private var moveBack = false

    var body: some View {
        if moveBack {
            PokerSplitterView()
                .background(Color.white)
                .edgesIgnoringSafeArea(.all)
        } else {
            NavigationView {
                ZStack {
                    Color.white.edgesIgnoringSafeArea(.all)
                    VStack {
                        Spacer()
                        HStack {
                            Image(systemName: "suit.spade.fill")
                                .resizable()
                                .foregroundColor(.black)
                                .frame(width: 50, height: 50)
                            Image(systemName: "heart.fill")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 50, height: 50)
                            Image(systemName: "suit.club.fill")
                                .resizable()
                                .foregroundColor(.black)
                                .frame(width: 50, height: 50)
                            Image(systemName: "suit.diamond.fill")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 50, height: 50)
                        }
                        Text("SPLITTER")
                            .font(.largeTitle)
                        TextField("Enter host name", text: $hostInput)
                            .padding([.leading, .bottom, .trailing])
                            .multilineTextAlignment(.center)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Enter host venmo/zelle", text: $paymentInput)
                            .padding([.leading, .bottom, .trailing])
                            .multilineTextAlignment(.center)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: {
                            self.host = self.hostInput
                            self.payment = self.paymentInput
                            print("Host: \(self.host)")
                            print("Payment Destination: \(self.payment)")
                            self.navigateToPlayersView = true
                        }) {
                            Text("SUBMIT")
                                .font(.system(size: 25))
                                .padding()
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .frame(width: 200, height: 50)
                        .background(Color.gray)
                        .cornerRadius(20)
                        NavigationLink("", destination: PlayersView(host: host, payment: payment), isActive: $navigateToPlayersView)
                            .hidden()
                            .background(Color.white)
                            .edgesIgnoringSafeArea(.all)
                        
                        Button(action: {
                            moveBack = true
                        }) {
                            Text("Go Back")
                                .font(.headline)
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top, 225)
                    }
                }
            }
        }
    }
}

struct SplitterView_Previews: PreviewProvider {
    static var previews: some View {
        SplitterView()
    }
}
