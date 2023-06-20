//
//  DetailView.swift
//  nextbigthing
//
//  Created by Sash Sujith and Daniel Heffron on 4/30/23.
//
import SwiftUI

struct GameDetailsView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var playerManager: PlayerManager
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
    var winners: String {
        var str = ""
        if (!(game.winnerIDs.isEmpty)){
            for player in playerManager.players{
                if game.winnerIDs.contains(player.id){
                    if (str == ""){
                        str += ("\(player.name)")
                    }
                    else{
                        str += ("\n\(player.name)")
                    }
                }
            }
        }
        return str
    }
    let dateFormatter = DateFormatter()
        
    init (game: Game) {
        self.game = game
    }
    
    func createFormatter() -> String{
        dateFormatter.dateFormat = "MM/dd/yy hh:mm"
        return dateFormatter.string(from: game.dateStarted);
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if let data = game.imageData, let uiimage = UIImage(data: data) {
                    Image(uiImage: uiimage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                
                List {
                    Section(header: Text("Details").fontWeight(.bold)) {
                        VStack(spacing: 5) {
                            HStack {
                                Text("Name: ").bold()
                                Spacer()
                                Text(game.name)
                            }
                            HStack {
                                Text("Genre: ").bold()
                                Spacer()
                                Text(game.genre.rawValue)
                            }
                            HStack {
                                Text("Date Logged: ").bold()
                                Spacer()
                                Text(createFormatter())
                            }
                            HStack {
                                Text("Description: ").bold()
                                Spacer()
                                Text(game.description)
                            }
                        }
                        if(!(game.winnerIDs.isEmpty)){
                            VStack{
                                HStack{
                                    Text("Winners: ").bold()
                                    Spacer()
                                    Text(winners)
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Players").fontWeight(.bold)) {
                        ForEach(Array(players.enumerated()), id: \.offset) { i,player in
                            NavigationLink {
                                PlayerDetailsView(player: player)
                            } label: {
                                PlayerLineView(player: player)
                                if !(game.points.isEmpty){
                                    Text("Points: \(game.points[player.id]!)")
                                }
                            }
                        }
                    }
                }
            }
        }.navigationTitle("Game Details")
    }
    
}

/*struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(game1: ga)
    }
}*/
