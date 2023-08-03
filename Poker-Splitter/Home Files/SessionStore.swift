//
//  SessionStore.swift
//  Poker-Splitter
//
//  Created by Max Pintchouk on 8/3/23.
//

import SwiftUI
import Firebase
import Combine

struct User {
    var uid: String
    var displayName: String?
    
    init(uid: String, displayName: String?) {
        self.uid = uid
        self.displayName = displayName
    }
}

class SessionStore: ObservableObject {
    @Published var session: User?
    var handle: AuthStateDidChangeListenerHandle?

    func listen() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.session = User(uid: user.uid, displayName: user.displayName)
            } else {
                self.session = nil
            }
        }
    }

    func signIn(email: String, password: String, handler: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    func signUp(email: String, password: String, handler: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }

    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            self.session = nil
            return true
        } catch {
            return false
        }
    }

    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    deinit {
        unbind()
    }
}
