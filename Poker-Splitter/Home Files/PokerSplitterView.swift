//
//  HomeView.swift
//  Poker-Splitter
//
//  Created by Max Pintchouk on 8/2/23.
//

import SwiftUI

struct PokerSplitterView: View {
    @State private var currentInput: String = ""
    @State private var host: String = ""
    @State private var moveToSplitter = false
    @State private var moveToGameHistory = false
    
    var body: some View {
        
        if moveToSplitter {
            SplitterView()
                .background(Color.white)
                .edgesIgnoringSafeArea(.all)
        }
        else if moveToGameHistory {
            GameHistoryView()
                .background(Color.white)
                .edgesIgnoringSafeArea(.all)
        } else {
            
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
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
                    
                    Button(action: {
                        self.moveToSplitter = true
                    }) {
                        Text("SPLITTER")
                            .font(.system(size: 25))
                            .padding()
                            .foregroundColor(.white)
                    }
                    .frame(width: 200, height: 50)
                    .background(Color.gray)
                    .cornerRadius(20)

                    
                    Button(action: {
                        self.moveToGameHistory = true
                    }) {
                        Text("GAME HISTORY")
                            .font(.system(size: 25))
                            .padding()
                            .foregroundColor(.white)
                    }
                    .frame(width: 200, height: 50)
                    .background(Color.gray)
                    .cornerRadius(20)
                }
            }
        }
    }
}

struct PokerSplitterView_Previews: PreviewProvider {
    static var previews: some View {
        PokerSplitterView()
    }
}
