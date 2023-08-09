//
//  SingleGameView.swift
//  Poker-Splitter
//
//  Created by Max Pintchouk on 8/6/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct SingleGameView: View {
    var session: GameSession
    @State private var moveBack = false
    @State private var commentBar = "No comments added"
    
    var body: some View {
        if moveBack {
            GameHistoryView()
                .background(Color.white)
                .edgesIgnoringSafeArea(.all)
        } else {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                VStack {
                    // Display details of the game session here
                    Text("Host: \(session.host)")
                        .font(.title2)
                    
                    List(session.players, id: \.name) { player in
                        VStack(alignment: .leading) {
                            Text("Player: \(player.name)")
                                .foregroundColor(.black)

                            
                            if player.buyin > player.cashout {
                                Text("Buy-in: \(String(format: "%.2f", player.buyin)), Cash-out: \(String(format: "%.2f", player.cashout))")
                                Text("Loss: \(String(format: "%.2f", player.buyin - player.cashout)), ROI: -\(String(format: "%.2f", ((player.buyin - player.cashout)/player.buyin)*100 ))%")
                                    .foregroundColor(.red)

                            }
                            else if player.buyin < player.cashout {
                                Text("Buy-in: \(String(format: "%.2f", player.buyin)), Cash-out: \(String(format: "%.2f", player.cashout))")
                                Text("Profit: \(String(format: "%.2f", player.cashout - player.buyin)), ROI: +\(String(format: "%.2f", ((player.cashout - player.buyin)/player.buyin)*100 ))%")
                                    .foregroundColor(.green)

                            } else {
                                Text("Buy-in: \(String(format: "%.2f", player.buyin)), Cash-out: \(String(format: "%.2f", player.cashout))")
                                Text("Broke Even Profit: $0, ROI: 0%")
                                    .foregroundColor(.gray)

                            }
                            if player.cashout == 0 {
                                Text("Wow, that's awkward....")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.bottom)
                    }
                    .padding(.bottom)
                    
                    VStack {
                        if session.comments == "" {
                            Text("\(commentBar)")
                        } else {
                            Text("\(session.comments)")
                        }
                    }
                    .frame(width: 325, height: 80)
                    
                    // Add a delete button
                    HStack {
                        Button(action: {
                            deleteSessionAndGoBack()
                            moveBack = true
                        }) {
                            Text("Delete Session")
                                .font(.system(size: 20))
                                .padding()
                                .background(.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                        
                        
                        Button(action: {
                            moveBack = true
                        }) {
                            Text("Go Back")
                                .font(.system(size: 20))
                                .padding()
                                .background(.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                }
            }
        }
    }
    
    func deleteSessionAndGoBack() {
            // Reference to Firestore database
            let db = Firestore.firestore()
            guard let userID = Auth.auth().currentUser?.uid else { return }
            
            // Delete the specific game session from Firestore
            db.collection("users").document(userID).collection("sessions").document(session.id).delete { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    // Navigate back
                }
            }
        }
}

struct SingleGameView_Previews: PreviewProvider {
    static var mockGameSession = GameSession(id: "", host: "", comments: "", players: [
        Player(name: "", buyin: 0, cashout: 0),
        Player(name: "", buyin: 0, cashout: 0)
    ], date: Date())
    
    static var previews: some View {
        SingleGameView(session: mockGameSession)
    }
}
