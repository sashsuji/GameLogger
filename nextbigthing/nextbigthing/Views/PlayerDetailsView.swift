//
//  PlayerDetailsView.swift
//  nextbigthing
//
//  Created by Sash Sujith and Daniel Heffron on 5/5/23.
//

import SwiftUI

struct PlayerDetailsView: View {
    @State var player: Player
    
    var body: some View {
        Text("\(player.name)")
        
        List {
            Section {
                LabeledContent("Age", value: player.age)
                LabeledContent("Favorite Game:", value: player.favGame)
                LabeledContent("Avatar", value: player.avatar.rawValue)
                LabeledContent("Total Wins:", value: String(player.wins))
                LabeledContent("Total Losses:", value: String(player.losses))
            }
        }
    }
}

/*struct PlayerDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerDetailsView()
    }
}
*/
