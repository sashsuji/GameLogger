//
//  ContentView.swift
//  nextbigthing
//
//  Created by Daniel Heffron and Sash Sujith on 4/6/23.
//

import SwiftUI

let playersKey = "players"

struct ContentView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var playerManager: PlayerManager

    var body: some View {
        VStack {
            Text("Gamelogger")
                .font(.title)
                .foregroundColor(.purple)
                .padding()
            TabView {
                MainView()
                    .environmentObject(gameManager)
                    .environmentObject(playerManager)
                    .tabItem {Text("Games")}
                TimerView()
                    .tabItem {Text("Timer")}
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GameManager()).environmentObject(PlayerManager())
    }
}
