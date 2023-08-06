//
//  SaveGame.swift
//  Poker-Splitter
//
//  Created by Max Pintchouk on 8/3/23.
//

import FirebaseFirestore

let db = Firestore.firestore()

struct SaveGame {
    var host: String
    var comments: String
    var players: [Player]
    var userID: String

    func saveToFirestore() {
        
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let formattedDate = formatter.string(from: currentDate)
        
        var playersArray: [[String: Any]] = []

        for player in players {
            let playerData: [String: Any] = [
                "name": player.name,
                "buyin": player.buyin,
                "cashout": player.cashout
            ]
            playersArray.append(playerData)
        }

        let sessionData: [String: Any] = [
            "host": host,
            "comments": comments,
            "players": playersArray,
            "date": formattedDate
            // Any other session-specific data...
        ]

        // Save the session data under the current user's collection
        db.collection("users").document(userID).collection("sessions").addDocument(data: sessionData) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}
