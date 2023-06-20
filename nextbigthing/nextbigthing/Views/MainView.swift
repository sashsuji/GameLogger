//
//  MainView.swift
//  nextbigthing
//
//  Created by Daniel Heffron and Sash Sujith on 4/6/23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var playerManager: PlayerManager
    @State var addingGame: Bool = false
    @State var addingPlayer: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                List() {
                    ForEach(gameManager.games){ game in
                        
                        NavigationLink {
                            GameDetailsView(game: game).environmentObject(gameManager).environmentObject(playerManager)
                        }label: {
                            GameLineView(game: game).environmentObject(gameManager).environmentObject(playerManager)
                        }
                        
                    }
                }.listStyle(.insetGrouped)
                .padding()
                
                Spacer()
                
                NavigationLink(destination: AddGameView(isShowing: $addingGame)
                    .environmentObject(gameManager)
                    .environmentObject(playerManager)
                    .navigationTitle(Text("Add Game")),
                isActive: $addingGame) {
                    Text("Add Game").onTapGesture {
                        addingGame = true
                    }
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(GameManager())
    }
}
