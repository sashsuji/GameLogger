//
//  PlayerLineView.swift
//  nextbigthing
//
//  Created by Daniel Heffron and Sash Sujith on 5/5/23.
//

import SwiftUI

struct PlayerLineView: View {
    @State var player: Player
    
    var body: some View {
        HStack {
            Text("\(player.name)")
            Spacer()
            Text("\(player.avatar.rawValue)")
        }
    }
}
