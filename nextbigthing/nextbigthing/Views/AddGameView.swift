//
//  AddGameView.swift
//  nextbigthing
//
//  Created by Daniel Heffron and Sash Sujith on 4/6/23.
//

import SwiftUI
import PhotosUI

struct AddGameView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var playerManager: PlayerManager
    @State var selectedPhotos: [PhotosPickerItem] = []
    @State var data: Data?
    @State var newName: String = ""
    @State var desc: String = ""
    @State var selectedPlayers = Set<UUID>()
    @State var showPlayerAction = false
    @State var newGenre: Genres? = nil
    @State var showGenreAction = false
    @State var addingPlayer: Bool = false
    @State var isFinished: Bool = false
    @State var hasPoints: Bool = false
    @State var addInfo: Bool = false
    @State var temp = Game(
        name: "",
        playerIDs: [],
        description: "",
        dateStarted: Date(),
        genre: Genres.card,
        imageData: nil,
        winnerIDs: [],
        points: [:],
        id: 0
    )
    @Binding var isShowing: Bool
    
    
    var next: String {
        if isFinished || hasPoints {
            return "Next"
        }
        else {
            return "Add"
        }
    }

    var currentPlayers: String {
        var str = ""
        
        if selectedPlayers.count != 0 {
            for player in playerManager.players {
                if selectedPlayers.contains(player.id) {
                    str += ("\(player.name)\n")
                }
            }
        }
        
        return str
    }

    var currentGenre: String {
        newGenre?.rawValue ?? "Select Genre"
    }

    func allGenres() -> [ActionSheet.Button] {
        var retval: [ActionSheet.Button] = []
        for genre in Genres.allCases {
            retval.append(.default(Text(genre.rawValue)){
                newGenre = genre
            })
        }
        return retval
    }

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Enter new Game:").padding()
                TextField("name", text: $newName).padding()
                    .autocorrectionDisabled()
            }
            
            HStack {
                Text("Enter description:").padding()
                TextField("description", text: $desc).padding()
                    .autocorrectionDisabled()
            }
            
            HStack {
                Button("Select Players"){showPlayerAction = true}.sheet(isPresented: $showPlayerAction) {
                    MultipleSelectionList(players: playerManager.players, selectedPlayers: $selectedPlayers)
                }.disabled(playerManager.players.isEmpty)
                
                Text(currentPlayers)
            }
            
            NavigationLink(destination: AddPlayerView(isShowing: $addingPlayer).environmentObject(playerManager),
                           isActive: $addingPlayer) {
                Text("Add New Player").onTapGesture {
                    addingPlayer = true
                }
            }
            
            Button(currentGenre){ showGenreAction = true}.actionSheet(isPresented: $showGenreAction) {
                ActionSheet(
                    title: Text("Select Genre"),
                    message: Text("Please choose one of these"),
                    buttons: allGenres()
                )
            }
            
            Toggle("Does this game have points? ", isOn: $hasPoints).padding()
            Toggle("Is this game finished? ", isOn: $isFinished).padding()
            
            VStack {
                if let data = data, let uiimage = UIImage(data: data) {
                    Image(uiImage: uiimage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                PhotosPicker(
                    selection: $selectedPhotos,
                    maxSelectionCount: 1,
                    matching: .images
                ) {
                    Text("Pick Photo")
                }
                .onChange(of: selectedPhotos) { newValue in
                    guard let photo = selectedPhotos.first else {
                        return
                    }
                    photo.loadTransferable(type: Data.self) { result in
                        switch result {
                        case .success(let data):
                            if let data = data {
                                self.data = data
                            }
                            else {
                                print("Data is nil")
                            }
                        case .failure(let failure):
                            fatalError("\(failure)")
                        }
                    }
                }
            }

            Spacer()
            
            NavigationLink(destination: PointsView(temp: temp, addInfo: $addInfo, hasPoints: $hasPoints, isFinished: $isFinished, isShowing: $isShowing)
                .environmentObject(gameManager),
                           isActive: $addInfo) {
                Text(next).onTapGesture {
                    if selectedPlayers.count != 0, let genre = newGenre {
                        temp = Game(
                            name: newName,
                            playerIDs: selectedPlayers.reversed(),
                            description: desc,
                            dateStarted: Date(),
                            genre: genre,
                            imageData: data,
                            winnerIDs: [],
                            points: [:],
                            id: gameManager.gameIDs
                        )
                        
                        newName = ""
                        selectedPlayers.removeAll()
                        newGenre = nil
                        
                        if isFinished || hasPoints {
                            addInfo = true
                        }
                        else {
                            gameManager.addGame(game: temp)
                            isShowing = false
                        }
                    }
                }
            }
        }
    }
}

struct MultipleSelectionList: View {
    @State var players: [Player]
    @Binding var selectedPlayers: Set<UUID>

    var body: some View {
        Text("(Swipe down when done)").padding(10)
        NavigationView {
            List(selection: $selectedPlayers) {
                ForEach(players) {player in
                    MultipleSelectionRow(player: player, selectedPlayers: $selectedPlayers)
                }
                .listStyle(.inset)
                .navigationTitle("Selected \(selectedPlayers.count) players")
            }
        }
    }
}


struct MultipleSelectionRow: View {
    var player: Player
    @Binding var selectedPlayers: Set<UUID>
    
    var isSelected: Bool {
        selectedPlayers.contains(player.id)
    }

    var body: some View {
        HStack {
            Text("\(player.name) \(player.avatar.rawValue)")
            if isSelected {
                Image(systemName: "checkmark")
            }
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            if isSelected {
                selectedPlayers.remove(player.id)
            } else {
                selectedPlayers.insert(player.id)
            }
        }
            
    }
}
