//
//  AddPlayerView.swift
//  nextbigthing
//
//  Created by Daniel Heffron and Sash Sujith on 4/6/23.
//

import SwiftUI

struct AddPlayerView: View {
    @EnvironmentObject var playerManager: PlayerManager
    @State var playerName: String = ""
    @State var playerAge: String = ""
    @State var favoriteGame: String = ""
    @State var newAvatar: Avatars? = nil
    @State var showAvatarAction = false
    @Binding var isShowing: Bool
    
    var currentAvatar: String {
        newAvatar?.rawValue ?? "Select Avatar"
    }

    func allAvatars() -> [ActionSheet.Button] {
        var retval: [ActionSheet.Button] = []
        for avatar in Avatars.allCases {
            retval.append(.default(Text(avatar.rawValue)){
                newAvatar = avatar
            })
        }
        return retval
    }

    var body: some View {
        VStack {
            HStack {
                Text("Player Name:").padding()
                TextField("name", text: $playerName).padding()
                    .autocorrectionDisabled()
            }
            
            HStack {
                Text("Age:").padding()
                TextField("age", text: $playerAge).padding()
            }
            
            HStack {
                Text("Favorite game:").padding()
                TextField("fav game", text: $favoriteGame).padding()
                    .autocorrectionDisabled()
            }
            
            Button(newAvatar?.rawValue ?? "Select Avatar"){ showAvatarAction = true}.actionSheet(isPresented: $showAvatarAction) {
                ActionSheet(
                    title: Text("Select Genre"),
                    message: Text("Please choose one of these"),
                    buttons: allAvatars()
                )
            }.padding()

            Button("Add Player") {
                if let avatar = newAvatar {
                    playerManager.addPlayer(
                        player: Player(
                            name: playerName,
                            age: playerAge,
                            favGame: favoriteGame,
                            avatar: avatar
                        )
                    )
                    
                    playerName = ""
                    playerAge = ""
                    favoriteGame = ""
                    isShowing = false
                }
            }
        }
    }
}
