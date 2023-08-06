//
//  GameHistoryView.swift
//  Poker-Splitter
//
//  Created by Max Pintchouk on 8/3/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

// Define a struct to represent a game session
struct GameSession {
    var id: String
    var host: String
    var players: [Player]
}

struct GameHistoryView: View {
    // Add a state variable to hold the game sessions
    @State private var gameSessions: [GameSession] = []
    @State private var moveBack = false
    @State private var selectedGame: GameSession?
    
    var body: some View {
        
        if moveBack {
            PokerSplitterView()
        }
        
        else if let gameSelected = selectedGame {
            SingleGameView(session: gameSelected)
        }
        
        else {
            NavigationView {
                ZStack {
                    ScrollView {
                        Spacer().frame(maxHeight: .infinity)
                        VStack {
                            ForEach(gameSessions, id: \.id) { game in
                                
                                
                                Button(action: {
                                    self.selectedGame = game
                                }) {
                                    VStack(alignment: .leading) {
                                        Text("Host: \(game.host)")
                                            .font(.headline)
                                        ForEach(game.players, id: \.name) { player in
                                            Text("Player: \(player.name), Buy-in: \(player.buyin), Cash-out: \(player.cashout)")
                                        }
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                                }
                                
                            }
                        }
                    }
                    VStack {
                        Spacer()
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
                        .padding(.bottom)
                        .opacity(0.6)
                    }
                }
                .navigationTitle("Game History")
                .onAppear(perform: loadData)
            }
        }
    }
    
    func loadData() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        db.collection("users").document(userID).collection("sessions").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                gameSessions = querySnapshot!.documents.compactMap { queryDocumentSnapshot -> GameSession? in
                    let data = queryDocumentSnapshot.data()
                    
                    guard let host = data["host"] as? String else { return nil }
                    guard let playersData = data["players"] as? [[String: Any]] else { return nil }
                    
                    let players = playersData.compactMap { playerData -> Player? in
                        guard let name = playerData["name"] as? String,
                              let buyin = playerData["buyin"] as? Double,
                              let cashout = playerData["cashout"] as? Double else { return nil }
                        
                        return Player(name: name, buyin: buyin, cashout: cashout)
                    }
                    
                    return GameSession(id: queryDocumentSnapshot.documentID, host: host, players: players)
                }
            }
        }
    }
}

struct GameHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        GameHistoryView()
    }
}
