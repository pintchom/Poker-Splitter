//
//  PlayersView.swift
//  Poker-Splitter
//
//  Created by Max Pintchouk on 8/2/23.
//

import FirebaseAuth
import FirebaseFirestore
import SwiftUI

struct Player {
    var name: String
    var buyin: Double
    var cashout: Double
}

struct PlayersView: View {
    var host: String
    var payment: String
    @State private var players = [Player(name: "", buyin: 0.0, cashout: 0.0)]
    @State private var showResults = false
    @State private var currentUserID: String = ""
    @State private var saveButtonText: String = "Save Game"
    
    
    
    var body: some View {
        VStack {
            List {
                if !showResults {
                    ForEach(players.indices, id: \.self) { index in
                        GeometryReader { geometry in
                            HStack {
                                TextField("Name", text: $players[index].name)
                                    .frame(width: geometry.size.width * 0.3)
                                HStack {
                                    Text("Buy-in:")
                                    TextField("Buyin", value: $players[index].buyin, formatter: NumberFormatter())
                                }
                                .fixedSize()
                                .frame(width: geometry.size.width * 0.35)
                                HStack {
                                    Text("Cash-out:")
                                    TextField("Cashout", value: $players[index].cashout, formatter: NumberFormatter())
                                }
                                .fixedSize()
                                .frame(width: geometry.size.width * 0.4)
                            }
                            .frame(height: 30, alignment: .center)
                        }
                    }
                } else {
                    ForEach(players, id: \.name) { player in
                        Text(resultStatement(for: player))
                    }
                    Text("Send Money to \(payment)")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .fontWeight(.bold)
                }
            }
            HStack {
                if !showResults {
                    Button(action: {
                        players.append(Player(name: "", buyin: 0.0, cashout: 0.0))
                    }) {
                        Text("Add Player")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                Button(action: {
                    showResults.toggle()
                }) {
                    Text(showResults ? "Reset" : "Submit")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                if showResults {
                    Button(action: {
                        saveButtonText = "Saved!"
                        saveGame()
                    }) {
                        Text(saveButtonText)
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
                    if let user = Auth.auth().currentUser {
                        currentUserID = user.uid
                    } else {
                        print("No user is signed in.")
                    }
                }
    }
    
    private func resultStatement(for player: Player) -> String {
        let difference = player.cashout - player.buyin
        if difference < 0 {
            return "\(player.name) owes \(host) $\(abs(difference))"
        } else {
            return "\(player.name) gets $\(difference) from \(host)"
        }
    }
    func saveGame() {
        let game = SaveGame(host: host, players: players, userID: currentUserID)
        game.saveToFirestore()
    }
}

struct PlayersView_Previews: PreviewProvider {
    static var previews: some View {
        PlayersView(host: "", payment: "")
    }
}
