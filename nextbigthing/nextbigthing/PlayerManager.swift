//
//  PlayerManager.swift
//  nextbigthing
//
//  Created by Daniel Heffron and Sash Sujith on 4/20/23.
//

import Foundation

enum Avatars: String, CaseIterable, Codable {
    case 🚘
    case 🌮
    case 🦥
    case 🐢
    case 👑
    case 🪖
    case 👩🏿
    case 👩🏻
    case 👩🏼
    case 👩🏽
    case 👩🏾
    case 👨🏿
    case 👨🏻
    case 👨🏼
    case 👨🏽
    case 👨🏾
}

struct Player: Hashable, Equatable, Codable, Identifiable {
    var name: String
    var age: String
    var favGame: String
    var avatar: Avatars
    var wins: Int = 0
    var losses: Int = 0
    var id = UUID()
}


class PlayerManager: ObservableObject {
    @Published var players: [Player] = []
    @Published var selected: Int? = nil
    
    let fname = "players.json"
    var url: URL? {
        let baseURL = try? FileManager.default.url(
           for: .documentDirectory, in: .userDomainMask,
           appropriateFor: nil, create: false )
        return baseURL?.appendingPathComponent(fname)
    }
    
    init() {
        loadPlayers()
    }
    
    func addPlayer(player: Player) {
        players.append(player)
        savePlayers()
    }
    
    func deletePlayer(player: Player) {
        var found: Int? = nil
        for i in 0..<players.count {
            if players[i] == player {
                found = i
                break
            }
        }
        
        if let idx = found {
            players.remove(at: idx)
            selected = nil
            savePlayers()
        }
    }
    
    func savePlayers() {
        var playerData: Data? = try? JSONEncoder().encode(players)
        if let file = url {
            try? playerData?.write(to: file)
        }
    }
    
    func loadPlayers() {
        if let file = url {
            if let data = try? Data(contentsOf: file) {
                if let playerData = try? JSONDecoder().decode(Array<Player>.self, from: data) {
                             players = playerData
                }
            }
        }
    }
    
    func select(player: Player) {
        for i in 0..<players.count {
            if players[i] == player {
                selected = i
            }
        }
    }
    
    func unselect() {
        selected = nil
    }
}

