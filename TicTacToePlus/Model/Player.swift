//
//  Player.swift
//  TicTacToePlus
//
//  Created by Shawn Cole on 7/15/24.
//

import Foundation

class Player {
    var symbol: PlayerSymbol
    var moves: Set<Move>
    
    init(symbol: PlayerSymbol) {
        self.symbol = symbol
        self.moves = Set<Move>()
    }
    
    func addMove(row: Int, col: Int) {
        moves.insert(Move(row: row, col: col))
    }
    
    func clearMoves() {
        moves.removeAll()
    }
}
