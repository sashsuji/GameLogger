//
//  GameManager.swift
//  nextbigthing
//
//  Created by Daniel Heffron and Sash Sujith on 4/6/23.
//

import Foundation

enum Genres: String, CaseIterable, Codable {
    case grid = "Grid Game"
    case card = "Card Game"
    case conquest = "Conquest Game"
    case rollAndMove = "Roll and Move Game"
}

struct Game: Hashable, Codable, Identifiable {
    var name: String
    var playerIDs: [UUID]
    var description: String
    var dateStarted: Date
    var genre: Genres
    var imageData: Data?
    var winnerIDs: [UUID]
    var points: [UUID:Int] = [:]
    var id: Int
    
    static func == (g1: Self, g2: Self) -> Bool {
        g1.id == g2.id
    }
}

class GameManager: ObservableObject {
    @Published var games: [Game] = []
    @Published var selected: Int? = nil
    var gameIDs = 0
    
    let fname = "games.json"
    var url: URL? {
        let baseURL = try? FileManager.default.url(
           for: .documentDirectory, in: .userDomainMask,
           appropriateFor: nil, create: false )
        return baseURL?.appendingPathComponent(fname)
    }
    
    init() {
        loadGames()
    }
    
    func addGame(game: Game) {
        games.append(game)
        gameIDs += 1
        saveList()
    }
    
    func deleteGame(game: Game) {
        var found: Int? = nil
        for i in 0..<games.count {
            if games[i] == game {
                found = i
                break
            }
        }
        
        if let idx = found {
            games.remove(at: idx)
            selected = nil
            saveList()
        }
    }
    
    func saveList() {
        var gameData: Data? = try? JSONEncoder().encode(games)
        if let file = url {
            try? gameData?.write(to: file)
        }
    }
    
    func loadGames() {
        if let file = url {
            if let data = try? Data(contentsOf: file) {
                if let gameData = try? JSONDecoder().decode(Array<Game>.self, from: data) {
                             games = gameData
                }
            }
        }
    }
    
    func select(game: Game) {
        for i in 0..<games.count {
            if games[i] == game {
                selected = i
            }
        }
    }
    
    func unselect() {
        selected = nil
    }
}
