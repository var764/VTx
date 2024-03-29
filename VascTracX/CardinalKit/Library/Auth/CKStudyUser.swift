//
//  CKStudyUser.swift
//
//  Created for the CardinalKit Framework.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import Foundation
import Firebase
import CardinalKit

class CKStudyUser: ObservableObject {
    
    static let shared = CKStudyUser()

    private weak var authStateHandle: AuthStateDidChangeListenerHandle?
    
    /* **************************************************************
     * the current user only resolves if we are logged in
    **************************************************************/
    var currentUser: User? {
        // this is a reference to the
        // Firebase + Google Identity User
        return Auth.auth().currentUser
    }
    
    /* **************************************************************
     * store your Firebase objects under this path in order to
     * be compatible with CardinalKit GCP rules.
    **************************************************************/
    var authCollection: String? {
        if let userId = currentUser?.uid,
            let root = rootAuthCollection {
            return "\(root)\(userId)/"
        }
        
        return nil
    }
    
    var surveysCollection: String? {
        if let bundleId = Bundle.main.bundleIdentifier {
            return "/studies/\(bundleId)/surveys/"
        }
        
        return nil
    }
    
    var studyCollection: String?{
        if let bundleId = Bundle.main.bundleIdentifier {
            return "/studies/\(bundleId)/"
        }
        return nil
    }
    
    fileprivate var rootAuthCollection: String? {
        if let bundleId = Bundle.main.bundleIdentifier {
            return "/studies/\(bundleId)/users/"
        }
        
        return nil
    }

    var email: String? {
        get {
            return UserDefaults.standard.string(forKey: Constants.prefUserEmail)
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.set(newValue, forKey: Constants.prefUserEmail)
            } else {
                UserDefaults.standard.removeObject(forKey: Constants.prefUserEmail)
            }
        }
    }
    
    var isLoggedIn: Bool {
        return (currentUser?.isEmailVerified ?? false) && UserDefaults.standard.bool(forKey: Constants.prefConfirmedLogin)
    }

    init() {
        // listen for changes in authentication state from Firebase and update currentUser
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] (_, _) in
            self?.objectWillChange.send()
        }
    }

    /**
    Save a snapshot of our current user into Firestore.
    */
    func save() {
        if let dataBucket = rootAuthCollection,
            let email = currentUser?.email,
            let uid = currentUser?.uid {
            
            CKSession.shared.userId = uid
            CKSendHelper.createNecessaryDocuments(path:dataBucket)
            let settings = FirestoreSettings()
            settings.isPersistenceEnabled = false
            let db = Firestore.firestore()
            db.settings = settings
            db.collection(dataBucket).document(uid).setData(["userID":uid, "lastActive":Date().ISOStringFromDate(),"email":email])
        }
    }
    
    /**
    Remove the current user's auth parameters from storage.
    */
    func signOut() throws {
        email = nil
        try Auth.auth().signOut()
    }
    
}
