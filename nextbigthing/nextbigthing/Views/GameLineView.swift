//
//  GameLineView.swift
//  nextbigthing
//
//  Created by Daniel Heffron and Sash Sujith on 4/11/23.
//

import SwiftUI

struct GameLineView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var playerManager: PlayerManager
    @State var gameDelete = false

    var completed: Bool{
        if (game.winnerIDs.isEmpty){
            return false
        }
        return true
    }
    
    let game: Game
    var players: [Player] {
        var temp: [Player] = []
        
        for player in playerManager.players {
            if game.playerIDs.contains(player.id) {
                temp.append(player)
            }
        }
        
        return temp
    }
    
    init (game: Game) {
        self.game = game
    }
    
    var body: some View {
        HStack {
            VStack {
                Text("\(game.name)")
                Text("\(game.dateStarted.formatted(date: .abbreviated, time: .standard))").font(.caption)
            }
            Spacer()
            VStack {
                ForEach (players, id: \.self) { player in
                    Text(String("\(player.name) \(player.avatar.rawValue)"))
                        .font(.caption)
                }
            }
        }
        .foregroundColor(completed ? .green : .red)
        .onTapGesture {
            gameManager.select(game: game)
        }
        .alert(isPresented: $gameDelete) {
            Alert(title: Text("Are you sure you want to delete \(game.name)?"),
                  primaryButton: .default(Text("Cancel")) {
                gameDelete = false },
                  secondaryButton: .destructive(Text("OK")) {
                gameManager.deleteGame(game: game)
                gameDelete = false
            }
            )
        }
        .onLongPressGesture {
            gameDelete = true
        }

    }
}
