//
//  ViewController.swift
//  TicTacToePlus
//
//  Created by Shawn Cole on 7/15/24.
//

import UIKit

class ViewController: UIViewController {
    let gridContainer = UIStackView()
    var gridButtons: [[UIButton]] = []
    let newGameButton = UIButton(type: .system)
    
    let currentPlayerLabel = UILabel()
    let currentPlayerSymbolContainer = UIView()

    let currentPlayerXView = XView()
    let currentPlayerOView = OView()
    
    var playerX = Player(symbol: .X)
    var playerO = Player(symbol: .O)
    var currentPlayer: Player?
    
    // Const
    let gridSize = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        currentPlayer = playerX
        setupUI()
        updateCurrentPlayerSymbol()
    }
    
    func setupUI() {
        view.backgroundColor = .systemGray6
        setupGridLayout()
        setupCurrentPlayerLabel()
        setupNewGameButton()
        updateCurrentPlayerSymbol()
    }
    
    func updateCurrentPlayerSymbol() {
        if currentPlayer?.symbol == .X {
            currentPlayerXView.isHidden = false
            currentPlayerOView.isHidden = true
        } else {
            currentPlayerXView.isHidden = true
            currentPlayerOView.isHidden = false
        }
    }
    
    @objc func gridButtonTapped(_ sender: UIButton) {
        // Do nothing if clicked grid is already filled
        guard sender.subviews.filter({ $0 is XView || $0 is OView }).isEmpty else { return }
        guard let currentPlayer = currentPlayer else { return }
        // Convert tag back to row / col
        let tag = sender.tag
        let row = tag / gridSize
        let col = tag % gridSize
        currentPlayer.addMove(row: row, col: col)
        
        let symbolView: UIView
        if currentPlayer.symbol == .X {
            symbolView = XView()
        } else {
            symbolView = OView()
        }
        symbolView.translatesAutoresizingMaskIntoConstraints = false
        sender.addSubview(symbolView)
        
        NSLayoutConstraint.activate([
            symbolView.centerXAnchor.constraint(equalTo: sender.centerXAnchor),
            symbolView.centerYAnchor.constraint(equalTo: sender.centerYAnchor),
            symbolView.widthAnchor.constraint(equalTo: sender.widthAnchor, multiplier: 0.6),
            symbolView.heightAnchor.constraint(equalTo: sender.heightAnchor, multiplier: 0.6)
        ])
        
        if checkForWin(player: currentPlayer, gridSize: gridSize) {
            showAlert(title: "Game Over", message: "\(currentPlayer.symbol.rawValue) Wins!")
        } else {
            // Toggle player
            self.currentPlayer = (currentPlayer.symbol == .X) ? playerO : playerX
            updateCurrentPlayerSymbol()
        }
    }
    
    @objc func newGameButtonTapped() {
        // Clear Grid
        for row in gridButtons {
            for button in row {
                button.subviews.forEach { $0.removeFromSuperview() }
            }
        }
        // Reset players
        playerX.clearMoves()
        playerO.clearMoves()
        currentPlayer = playerX
        updateCurrentPlayerSymbol()
    }
    
    func setupGridLayout() {
        gridContainer.axis = .vertical
        gridContainer.distribution = .fillEqually
        gridContainer.alignment = .fill
        gridContainer.spacing = 2
        gridContainer.backgroundColor = .systemGray4
        gridContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gridContainer)
        
        NSLayoutConstraint.activate([
            gridContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gridContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gridContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            gridContainer.heightAnchor.constraint(equalTo: gridContainer.widthAnchor)
        ])
        
        // Row
        for row in 0..<gridSize {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.distribution = .fillEqually
            rowStackView.alignment = .fill
            rowStackView.spacing = 2
            gridContainer.addArrangedSubview(rowStackView)
            
            var rowButtons: [UIButton] = []
            // Column
            for col in 0..<gridSize {
                let button = UIButton(type: .system)
                button.backgroundColor = .white
                button.translatesAutoresizingMaskIntoConstraints = false
                // Set unique int for each grid cell
                button.tag = row * gridSize + col
                button.addTarget(self, action: #selector(gridButtonTapped(_:)), for: .touchUpInside)
                
                // Add clickable grid section
                rowStackView.addArrangedSubview(button)
                rowButtons.append(button)
            }
            gridButtons.append(rowButtons)
        }
    }
    
    func setupCurrentPlayerLabel() {
        currentPlayerLabel.text = "Current Player:"
        currentPlayerLabel.font = .systemFont(ofSize: 22, weight: .medium)
        currentPlayerLabel.textColor = UIColor(.customGray)
        currentPlayerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(currentPlayerLabel)
        
        // Container to hold X or O view
        currentPlayerSymbolContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(currentPlayerSymbolContainer)
        
        currentPlayerXView.translatesAutoresizingMaskIntoConstraints = false
        currentPlayerXView.isHidden = true
        currentPlayerSymbolContainer.addSubview(currentPlayerXView)
        currentPlayerOView.translatesAutoresizingMaskIntoConstraints = false
        currentPlayerOView.isHidden = true
        currentPlayerSymbolContainer.addSubview(currentPlayerOView)
        
        // Constraints for the current player label and symbol
        NSLayoutConstraint.activate([
            currentPlayerLabel.topAnchor.constraint(equalTo: gridContainer.topAnchor, constant: -80),
            currentPlayerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50),
            
            currentPlayerSymbolContainer.centerYAnchor.constraint(equalTo: currentPlayerLabel.centerYAnchor),
            currentPlayerSymbolContainer.leadingAnchor.constraint(equalTo: currentPlayerLabel.trailingAnchor, constant: 10),
            currentPlayerSymbolContainer.widthAnchor.constraint(equalToConstant: 50),
            currentPlayerSymbolContainer.heightAnchor.constraint(equalToConstant: 50),
            
            currentPlayerXView.widthAnchor.constraint(equalTo: currentPlayerSymbolContainer.widthAnchor),
            currentPlayerXView.heightAnchor.constraint(equalTo: currentPlayerSymbolContainer.heightAnchor),
            currentPlayerXView.centerXAnchor.constraint(equalTo: currentPlayerSymbolContainer.centerXAnchor),
            currentPlayerXView.centerYAnchor.constraint(equalTo: currentPlayerSymbolContainer.centerYAnchor),
            
            currentPlayerOView.widthAnchor.constraint(equalTo: currentPlayerSymbolContainer.widthAnchor),
            currentPlayerOView.heightAnchor.constraint(equalTo: currentPlayerSymbolContainer.heightAnchor),
            currentPlayerOView.centerXAnchor.constraint(equalTo: currentPlayerSymbolContainer.centerXAnchor),
            currentPlayerOView.centerYAnchor.constraint(equalTo: currentPlayerSymbolContainer.centerYAnchor)
        ])
    }
    
    func setupNewGameButton() {
        newGameButton.setTitle("New Game".uppercased(), for: .normal)
        newGameButton.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        newGameButton.backgroundColor = .systemMint
        newGameButton.setTitleColor(.white, for: .normal)
        newGameButton.translatesAutoresizingMaskIntoConstraints = false
        newGameButton.addTarget(self, action: #selector(newGameButtonTapped), for: .touchUpInside)
        view.addSubview(newGameButton)
        
        NSLayoutConstraint.activate([
            newGameButton.topAnchor.constraint(equalTo: gridContainer.bottomAnchor, constant: 50),
            newGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newGameButton.widthAnchor.constraint(equalToConstant: 200),
            newGameButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func checkForWin(player: Player, gridSize: Int) -> Bool {
        let consecutiveSymbolsToWin = gridSize
        
        // Vertical + Horizontal
        for i in 0..<gridSize {
            for j in 0..<(gridSize - consecutiveSymbolsToWin + 1) {
                if (0..<consecutiveSymbolsToWin).allSatisfy({ player.moves.contains(Move(row: i, col: j + $0)) }) ||
                   (0..<consecutiveSymbolsToWin).allSatisfy({ player.moves.contains(Move(row: j + $0, col: i)) }) {
                    return true
                }
            }
        }
        
        // Diagonals
        for i in 0..<(gridSize - consecutiveSymbolsToWin + 1) {
            for j in 0..<(gridSize - consecutiveSymbolsToWin + 1) {
                if (0..<consecutiveSymbolsToWin).allSatisfy({ player.moves.contains(Move(row: i + $0, col: j + $0)) }) ||
                   (0..<consecutiveSymbolsToWin).allSatisfy({ player.moves.contains(Move(row: i + $0, col: j + consecutiveSymbolsToWin - 1 - $0)) }) {
                    return true
                }
            }
        }
        
        // 4 corners
        if player.moves.contains(Move(row: 0, col: 0)) &&
            player.moves.contains(Move(row: 0, col: gridSize - 1)) &&
            player.moves.contains(Move(row: gridSize - 1, col: 0)) &&
            player.moves.contains(Move(row: gridSize - 1, col: gridSize - 1)) {
            return true
        }
        
        // Center 4
        for i in 0..<(gridSize - 1) {
            for j in 0..<(gridSize - 1) {
                if player.moves.contains(Move(row: i, col: j)) &&
                    player.moves.contains(Move(row: i, col: j + 1)) &&
                    player.moves.contains(Move(row: i + 1, col: j)) &&
                    player.moves.contains(Move(row: i + 1, col: j + 1)) {
                    return true
                }
            }
        }
        
        return false
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
