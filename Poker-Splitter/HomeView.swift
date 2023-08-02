//
//  HomeView.swift
//  Poker-Splitter
//
//  Created by Max Pintchouk on 8/2/23.
//

import SwiftUI

struct HomeView: View {
    @State private var currentInput: String = ""
    @State private var host: String = ""
    @State private var navigateToPlayersView = false

    var body: some View {
        NavigationView {
            VStack {
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
                Text("POKER SPLITTER")
                    .font(.largeTitle)
                TextField("Enter host name", text: $currentInput)
                    .padding([.leading, .bottom, .trailing])
                    .multilineTextAlignment(.center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                Button(action: {
                    self.host = self.currentInput
                    print("Host: \(self.host)")
                    self.navigateToPlayersView = true
                }) {
                    Text("Submit")
                        .font(.headline)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                NavigationLink("", destination: PlayersView(), isActive: $navigateToPlayersView)
                    .hidden()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
