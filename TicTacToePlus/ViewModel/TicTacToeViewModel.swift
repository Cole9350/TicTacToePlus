//
//  TicTacToeViewModel.swift
//  TicTacToePlus
//
//  Created by Shawn Cole on 7/16/24.
//

import Foundation

class TicTacToeViewModel {
    var playerX = Player(symbol: .X)
    var playerO = Player(symbol: .O)
    var currentPlayer: Player
    var isGameActive: Bool
    
    let gridSize: Int
    
    var onWin: ((PlayerSymbol, [Move]) -> Void)?
    var onUpdate: (() -> Void)?
    
    init(gridSize: Int) {
        self.gridSize = gridSize
        self.currentPlayer = playerX
        self.isGameActive = true
    }
    
    func resetGame() {
        playerX.clearMoves()
        playerO.clearMoves()
        currentPlayer = playerX
        isGameActive = true
        onUpdate?()
    }
    
    func makeMove(row: Int, col: Int) {
        // Do nothing if clicked grid is already filled or winner already found
        guard !isMoveTaken(row: row, col: col) else { return }
        guard isGameActive else { return }
                
        currentPlayer.addMove(row: row, col: col)
        onUpdate?()
        
        if let winningMoves = checkForWin(player: currentPlayer) {
            isGameActive = false
            onWin?(currentPlayer.symbol, winningMoves)
        } else {
            togglePlayer()
        }
    }
    
    private func isMoveTaken(row: Int, col: Int) -> Bool {
        return playerX.moves.contains(Move(row: row, col: col)) || playerO.moves.contains(Move(row: row, col: col))
    }
    
    private func togglePlayer() {
        currentPlayer = (currentPlayer.symbol == .X) ? playerO : playerX
    }
    
    func checkForWin(player: Player) -> [Move]? {
        // Vertical + Horizontal
        for i in 0..<gridSize {
            let rowWin = (0..<gridSize).allSatisfy { player.moves.contains(Move(row: i, col: $0)) }
            let colWin = (0..<gridSize).allSatisfy { player.moves.contains(Move(row: $0, col: i)) }
            if rowWin {
                return (0..<gridSize).map { Move(row: i, col: $0) }
            }
            if colWin {
                return (0..<gridSize).map { Move(row: $0, col: i) }
            }
        }
        
        // Diagonals
        let diag1Win = (0..<gridSize).allSatisfy { player.moves.contains(Move(row: $0, col: $0)) }
        let diag2Win = (0..<gridSize).allSatisfy { player.moves.contains(Move(row: $0, col: gridSize - 1 - $0)) }
        if diag1Win {
            return (0..<gridSize).map { Move(row: $0, col: $0) }
        }
        if diag2Win {
            return (0..<gridSize).map { Move(row: $0, col: gridSize - 1 - $0) }
        }
        
        // 4 corners
        if gridSize >= 4 {
            let corners = [
                Move(row: 0, col: 0),
                Move(row: 0, col: gridSize - 1),
                Move(row: gridSize - 1, col: 0),
                Move(row: gridSize - 1, col: gridSize - 1)
            ]
            if corners.allSatisfy({ player.moves.contains($0) }) {
                return corners
            }
        }
        
        // Center 4
        for i in 0..<(gridSize - 1) {
            for j in 0..<(gridSize - 1) {
                let box = [
                    Move(row: i, col: j),
                    Move(row: i, col: j + 1),
                    Move(row: i + 1, col: j),
                    Move(row: i + 1, col: j + 1)
                ]
                if box.allSatisfy({ player.moves.contains($0) }) {
                    return box
                }
            }
        }
        
        return nil
    }
}
