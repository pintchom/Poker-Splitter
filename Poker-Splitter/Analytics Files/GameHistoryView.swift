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
    var comments: String
    var players: [Player]
    var date: Date
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
                                        Text(game.formattedDate)
                                            .fontWeight(.bold)
                                            .font(.title2)
                                            .foregroundColor(.black)
                                            .padding(.bottom)
                                            .multilineTextAlignment(.leading)
                                        Text("Host: \(game.host)")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                            .padding(.bottom)
                                        ForEach(game.players, id: \.name) { player in
                                            VStack(alignment: .leading) {
                                                Text("Player: \(player.name)")
                                                    .foregroundColor(.black)
                                                
                                                
                                                if player.buyin > player.cashout {
                                                    Text("Buy-in: \(String(format: "%.2f", player.buyin)), Cash-out: \(String(format: "%.2f", player.cashout))")
                                                        .foregroundColor(.red)
                                                    
                                                }
                                                else if player.buyin < player.cashout {
                                                    Text("Buy-in: \(String(format: "%.2f", player.buyin)), Cash-out: \(String(format: "%.2f", player.cashout))")
                                                        .foregroundColor(.green)
                                                    
                                                } else {
                                                    Text("Buy-in: \(String(format: "%.2f", player.buyin)), Cash-out: \(String(format: "%.2f", player.cashout))")
                                                        .foregroundColor(.gray)
                                                    
                                                }
                                                if player.cashout == 0 {
                                                    Text("Wow, that's awkward....")
                                                        .foregroundColor(.red)
                                                }
                                            }
                                            .padding(.bottom)
                                        }
                                        Text("Click to View More")
                                            .foregroundColor(.blue)
                                    }
                                    .padding()
                                    .frame(width:325)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                                    .multilineTextAlignment(.leading)
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
                    guard let comments = data["comments"] as? String else { return nil }
                    guard let playersData = data["players"] as? [[String: Any]] else { return nil }
                    
                    let players = playersData.compactMap { playerData -> Player? in
                        guard let name = playerData["name"] as? String,
                              let buyin = playerData["buyin"] as? Double,
                              let cashout = playerData["cashout"] as? Double else { return nil }
                        
                        return Player(name: name, buyin: buyin, cashout: cashout)
                    }
                    
                    if let timestamp = data["date"] as? Timestamp {
                        let dateSaved = timestamp.dateValue()
                        // Use dateSaved when initializing GameSession
                        return GameSession(id: queryDocumentSnapshot.documentID, host: host, comments: comments, players: players, date: dateSaved)
                    }
                    else {
                        return GameSession(id: queryDocumentSnapshot.documentID, host: host, comments: comments, players: players, date: Date())
                    }
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

extension GameSession {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }
}
