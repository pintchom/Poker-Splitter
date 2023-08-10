//
//  PlayersView.swift
//  Poker-Splitter
//
//  Created by Max Pintchouk on 8/2/23.
//

import FirebaseAuth
import FirebaseFirestore
import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isImagePickerPresented: Bool
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
            }
            
            parent.isImagePickerPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isImagePickerPresented = false
        }
    }
}


struct Player {
    var name: String
    var buyin: Double
    var cashout: Double
}

struct PlayersView: View {
    var host: String
    @State private var hostBuyin: Double = 0.0
    @State private var hostCashOut: Double = 0.0
    
    var payment: String
    @State private var players = [Player(name: "", buyin: 0.0, cashout: 0.0)]
    @State private var showResults = false
    @State private var currentUserID: String = ""
    @State private var saveButtonText: String = "Save Game"
    @State private var comments: String = ""
    
    var curBuyin: Double {
        players.reduce(0) { $0 + $1.buyin } + hostBuyin
    }

    var curCashout: Double {
        players.reduce(0) { $0 + $1.cashout } + hostCashOut
    }
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            VStack {
                List {
                    if !showResults {
                        GeometryReader { geometry in
                            HStack {
                                Text("Name")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .frame(width: geometry.size.width * 0.3)
                                Text("Buyin")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .frame(width: geometry.size.width * 0.3)
                                Text("Cashout")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .frame(width: geometry.size.width * 0.3)
                            }
                            .frame(height: 30, alignment: .center)
                        }
                        ForEach(players.indices, id: \.self) { index in
                            GeometryReader { geometry in
                                HStack {
                                    TextField("Name", text: $players[index].name)
                                        .frame(width: geometry.size.width * 0.3)
                                    HStack {
                                        Text("$")
                                        TextField("Buyin", value: $players[index].buyin, formatter: NumberFormatter().with { $0.numberStyle = .decimal; $0.minimumFractionDigits = 2; $0.maximumFractionDigits = 2 })
                                    }
                                    .fixedSize()
                                    .frame(width: geometry.size.width * 0.37)
                                    HStack {
                                        Text("$")
                                        TextField("Cashout", value: $players[index].cashout, formatter: NumberFormatter().with { $0.numberStyle = .decimal; $0.minimumFractionDigits = 2; $0.maximumFractionDigits = 2 })
                                    }
                                    .fixedSize()
                                    .frame(width: geometry.size.width * 0.3)
                                }
                                .frame(height: 30, alignment: .center)
                            }
                        }
                        GeometryReader { geometry in
                            HStack {
                                Text("\(host)")
                                    .frame(width: geometry.size.width * 0.3)
                                HStack {
                                    Text("$")
                                    TextField("Buyin", value: $hostBuyin, formatter: NumberFormatter().with { $0.numberStyle = .decimal; $0.minimumFractionDigits = 2; $0.maximumFractionDigits = 2 })
                                }
                                .fixedSize()
                                .frame(width: geometry.size.width * 0.37)
                                HStack {
                                    Text("$")
                                    TextField("Cashout", value: $hostCashOut, formatter: NumberFormatter().with { $0.numberStyle = .decimal; $0.minimumFractionDigits = 2; $0.maximumFractionDigits = 2 })
                                }
                                .fixedSize()
                                .frame(width: geometry.size.width * 0.3)
                            }
                            .frame(height: 30, alignment: .center)
                        }
                        
                    } else {
                        Text(resultStatement(for: Player(name: host, buyin: hostBuyin, cashout: hostCashOut)))
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
                    if curBuyin != curCashout {
                        Text("Total Buyin: \(String(format: "%.2f", curBuyin))")
                            .foregroundColor(.red)
                        Text("Total Cashouts: \(String(format: "%.2f", curCashout))")
                            .foregroundColor(.red)
                    } else {
                        Text("Total Buyin: \(String(format: "%.2f", curBuyin))")
                            .foregroundColor(.green)
                        Text("Total Cashouts: \(String(format: "%.2f", curCashout))")
                            .foregroundColor(.green)
                    }
                }
                TextField("Comments/Notes", text: $comments)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(width: 325, height: 120)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                
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
    }
    
    private func resultStatement(for player: Player) -> String {
        let difference = player.cashout - player.buyin
        if player.name == host {
            if hostBuyin > hostCashOut {
                return "\(host) lost $\(hostBuyin - hostCashOut)"
            } else {
                return "\(host) made $\(hostCashOut - hostBuyin)"
            }
        } else {
            if difference < 0 {
                return "\(player.name) owes \(host) $\(abs(difference))"
            } else {
                return "\(player.name) gets $\(difference) from \(host)"
            }
        }
    }
    func saveGame() {
        players.append(Player(name: host, buyin: hostBuyin, cashout: hostCashOut))
        let game = SaveGame(host: host, comments: comments, players: players, userID: currentUserID)
        game.saveToFirestore()
    }
}

struct PlayersView_Previews: PreviewProvider {
    static var previews: some View {
        PlayersView(host: "", payment: "")
    }
}

extension NumberFormatter {
    func with(_ changes: (NumberFormatter) -> Void) -> NumberFormatter {
        changes(self)
        return self
    }
}
