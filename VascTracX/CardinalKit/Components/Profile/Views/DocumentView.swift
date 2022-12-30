//
//  DocumentView.swift
//  CardinalKit_Example
//
//  Created by Santiago Gutierrez on 10/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import SwiftUI
import Firebase
import CareKit
import CareKitStore
import UIKit
import FirebaseFirestore
import RealmSwift
import ResearchKit
import CardinalKit
import CareKitUI

struct DocumentView: View {

    @State private var showPreview = false
    var documentsURL: URL? = nil

    init() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        if let DocumentCollection = CKStudyUser.shared.authCollection {

            // download consent document from Firebase Cloud Storage and display it to the user
            let config = CKPropertyReader(file: "CKConfiguration")
            let consentFileName = config.read(query: "Consent File Name")
            let documentRef = storageRef.child("\(DocumentCollection)/\(consentFileName).pdf")

            var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last as NSURL?
            docURL = docURL?.appendingPathComponent("\(consentFileName).pdf") as NSURL?
            let url = docURL! as URL
            self.documentsURL = URL(fileURLWithPath: url.path, isDirectory: false)
            UserDefaults.standard.set(url.path, forKey: "consentFormURL")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                let downloadTask = documentRef.write(toFile: url) { url, error in
                    if let error = error {
                        print("Error downloading consent document: \(error)")
                    } else {
                        print("Consent document downloaded successfully.")
                    }
                }
            })
            //perform(#selector(downloadDoc(documentRef, url)), with: nil, afterDelay: 4.0)
        }
    }

    var body: some View {
        HStack {
            Text("View Consent Document")
            Spacer()
            Text("›")
        }.frame(height: 60)
            .contentShape(Rectangle())
            .gesture(TapGesture().onEnded({
                self.showPreview = true
            }))
            .background(DocumentPreviewViewController(self.$showPreview, url: self.documentsURL))
    }
}

struct DDocumentView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentView()
    }
}

/*import SwiftUI
import Firebase

struct DocumentView: View {
    
    @State private var showPreview = false
    var documentsURL: URL? = nil
    
    init() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        if let DocumentCollection = CKStudyUser.shared.authCollection {
            let config = CKPropertyReader(file: "CKConfiguration")
            let DocumentRef = storageRef.child("\(DocumentCollection)/Consent.pdf")
            // Create local filesystem URL
            var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last as NSURL?
            docURL = docURL?.appendingPathComponent("\(config.read(query: "Consent File Name")).pdf") as NSURL?
            let url = docURL! as URL
            self.documentsURL = URL(fileURLWithPath: url.path, isDirectory: false)
            UserDefaults.standard.set(url.path, forKey: "consentFormURL")
            // Download to the local filesystem
            let downloadTask = DocumentRef.write(toFile: url) { url, error in
              if let error = error {
                // Uh-oh, an error occurred!
                  print("error \(error)")
              } else {
                  print("download correctly")
              }
            }
        }
    }
    
    var body: some View {
        HStack {
            Text("View Consent Document")
            Spacer()
            Text("›")
        }.frame(height: 60)
            .contentShape(Rectangle())
            .gesture(TapGesture().onEnded({
                self.showPreview = true
            }))
            .background(DocumentPreviewViewController(self.$showPreview, url: self.documentsURL))
    }
}

struct DDocumentView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentView()
    }
} */


