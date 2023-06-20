//
//  PointsView.swift
//  nextbigthing
//
//  Created by Sash Sujith and Daniel Heffron on 5/5/23.
//

import SwiftUI

struct PointsView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var playerManager: PlayerManager
    @State var temp: Game
    @Binding var addInfo: Bool
    @Binding var hasPoints: Bool
    @Binding var isFinished: Bool
    @Binding var isShowing: Bool
    
    @State var winners = Set<UUID>()
    @State var showWinnerAction = false
    
    var gamePlayers: [Player]{
        var tempPlayers: [Player] = []
        for playerID in temp.playerIDs {
            for player in playerManager.players{
                if (playerID == player.id){
                    tempPlayers.append(player)
                }
            }
        }
        return tempPlayers
    }
    
    @State var localPts: [UUID: Int] = [:]
    
    var currentPlayers: String {
        var str = ""
        
        if winners.count != 0 {
            for player in gamePlayers {
                if winners.contains(player.id) {
                    str += ("\(player.name)\n")
                }
            }
        }
        
        return str
    }
    

    
    var body: some View {
        VStack{
            if hasPoints {
                ForEach(0..<gamePlayers.count) { i in
                    HStack{
                        Text("Enter points for \(gamePlayers[i].name):").padding()
                        TextField("Points", value: binding(for: gamePlayers[i].id), format: .number).keyboardType(.decimalPad)
                            .padding()
                    }
                }
                
            }
            if isFinished {
                HStack {
                    Button("Select Winners"){showWinnerAction = true}.sheet(isPresented: $showWinnerAction) {
                        MultipleSelectionList(players: gamePlayers, selectedPlayers: $winners)
                    }.frame(width: 200, height: 70, alignment: .center)
                        .cornerRadius(15)
                        .background(Color.yellow)
                        .offset(y:20)
                    
                    Text(currentPlayers)
                }
            }
            
            Button("Finish") {
                if isFinished {
                    for id in temp.playerIDs {
                        if (winners.contains(id)){
                            for player in playerManager.players {
                                if player.id == id {
                                    let newPlayer = Player(
                                        name: player.name,
                                        age: player.age,
                                        favGame: player.favGame,
                                        avatar: player.avatar,
                                        wins: (player.wins + 1),
                                        losses: player.losses,
                                        id: player.id
                                    )
                                    
                                    playerManager.deletePlayer(player: player)
                                    playerManager.addPlayer(player: newPlayer)
                                }
                            }
                        }
                        else {
                            for player in playerManager.players {
                                if player.id == id {
                                    let newPlayer = Player(
                                        name: player.name,
                                        age: player.age,
                                        favGame: player.favGame,
                                        avatar: player.avatar,
                                        wins: player.wins,
                                        losses: (player.losses + 1),
                                        id: player.id
                                    )
                                    
                                    playerManager.deletePlayer(player: player)
                                    playerManager.addPlayer(player: newPlayer)
                                }
                            }
                        }
                    }
                }
                
                let newTemp = Game(
                    name: temp.name,
                    playerIDs: temp.playerIDs,
                    description: temp.description,
                    dateStarted: temp.dateStarted,
                    genre: temp.genre,
                    imageData: temp.imageData,
                    winnerIDs: Array(winners),
                    points: localPts,
                    id: temp.id
                )
                gameManager.addGame(game: newTemp)

                addInfo = false
                isShowing = false
            }.frame(width: 200, height: 70, alignment: .center)
                .foregroundColor(Color.white)
                .background(Color.green)
                .offset(y: 90)
        }
    }
    
    private func binding(for index: UUID) -> Binding<Int> {
        return Binding<Int>(
            get: {
                if localPts[index] != nil {
                    return localPts[index]!
                } else {
                    return 0
                }
            },
            set: { newValue in
                localPts[index] = newValue
            }
        )
    }
}

/*struct PointsView_Previews: PreviewProvider {
    static var previews: some View {
        PointsView()
    }
}*/
