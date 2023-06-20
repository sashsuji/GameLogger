//
//  nextbigthingApp.swift
//  nextbigthing
//
//  Created by Daniel Heffron and Sash Sujith on 4/6/23.
//

import SwiftUI

@main
struct nextbigthingApp: App {
    @StateObject var gameManager = GameManager()
    @StateObject var playerManager = PlayerManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(gameManager).environmentObject(playerManager)
        }
    }
}
