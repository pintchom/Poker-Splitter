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
    
    var body: some View {
        if moveBack {
            GameHistoryView()
        } else {
            VStack {
                // Display details of the game session here
                Text("Host: \(session.host)")
                
                List(session.players, id: \.name) { player in
                    Text("Player: \(player.name), Buy-in: \(player.buyin), Cash-out: \(player.cashout)")
                }
                .padding(.bottom)
                
                // Add a delete button
                Button(action: {
                    deleteSessionAndGoBack()
                    moveBack = true
                }) {
                    Text("Delete Session")
                        .font(.system(size: 15))
                        .padding()
                        .background(.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
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
    static var mockGameSession = GameSession(id: "12345", host: "John Doe", players: [
        Player(name: "Alice", buyin: 100.0, cashout: 150.0),
        Player(name: "Bob", buyin: 50.0, cashout: 25.0)
    ])
    
    static var previews: some View {
        SingleGameView(session: mockGameSession)
    }
}
