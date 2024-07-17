//
//  TicTacToeViewController.swift
//  TicTacToePlus
//
//  Created by Shawn Cole on 7/15/24.
//

import UIKit

class TicTacToeViewController: UIViewController {
    // MARK: - Properties
    
    let gridContainer = UIStackView()
    var gridButtons: [[UIButton]] = []
    let newGameButton = UIButton(type: .system)
    
    let currentPlayerLabel = UILabel()
    let currentPlayerSymbolContainer = UIView()

    let currentPlayerXView = XView()
    let currentPlayerOView = OView()
    
    var viewModel: TicTacToeViewModel
    
    // Const
    private let gridSize = 4
    
    // MARK: - Initializer
    
    init() {
        self.viewModel = TicTacToeViewModel(gridSize: gridSize)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.resetGame()

    }
    
    func setupBindings() {
        viewModel.onWin = { [weak self] symbol, winningMoves in
            self?.highlightWinningCells(winningMoves)
            self?.showAlert(title: "Game Over", message: "\(symbol.rawValue) Wins!")
        }
        
        viewModel.onUpdate = { [weak self] in
            self?.updateUI()
        }
    }
    
    func setupUI() {
        view.backgroundColor = .systemGray6
        setupGridLayout()
        setupCurrentPlayerLabel()
        setupNewGameButton()
    }
    
    // MARK: - UI Update Methods
    
    func updateUI() {
        updateCurrentPlayerSymbol()
        updateGrid()
    }
    
    func updateCurrentPlayerSymbol() {
        let currentPlayer = viewModel.currentPlayer
        if currentPlayer.symbol == .X {
            currentPlayerXView.isHidden = false
            currentPlayerOView.isHidden = true
        } else {
            currentPlayerXView.isHidden = true
            currentPlayerOView.isHidden = false
        }
    }
    
    func updateGrid() {
        for (rowIndex, row) in gridButtons.enumerated() {
            for (colIndex, button) in row.enumerated() {
                button.subviews.forEach { $0.removeFromSuperview() }
                let move = Move(row: rowIndex, col: colIndex)
                if viewModel.playerX.moves.contains(move) {
                    addSymbolView(.X, to: button)
                } else if viewModel.playerO.moves.contains(move) {
                    addSymbolView(.O, to: button)
                }
            }
        }
    }
    
    // MARK: - Action Methods
    
    @objc func gridButtonTapped(_ sender: UIButton) {
        guard !gridButtons.isEmpty else { return }
        // Convert tag back to row / col
        let tag = sender.tag
        let row = tag / gridSize
        let col = tag % gridSize
        viewModel.makeMove(row: row, col: col)
    }
    
    @objc func newGameButtonTapped() {
        // Clear Grid & Reset players
        clearWinningCells()
        viewModel.resetGame()
    }
    
    // MARK: - Helper Methods
    
    func addSymbolView(_ symbol: PlayerSymbol, to button: UIButton) {
        let symbolView: UIView
        if symbol == .X {
            symbolView = XView()
        } else {
            symbolView = OView()
        }
        symbolView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(symbolView)
        
        NSLayoutConstraint.activate([
            symbolView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            symbolView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            symbolView.widthAnchor.constraint(equalTo: button.widthAnchor, multiplier: 0.6),
            symbolView.heightAnchor.constraint(equalTo: button.heightAnchor, multiplier: 0.6)
        ])
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
        let currentPlayerContainer = UIView()
        currentPlayerContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(currentPlayerContainer)

        currentPlayerLabel.text = "Current Player:"
        currentPlayerLabel.font = .systemFont(ofSize: 22, weight: .medium)
        currentPlayerLabel.textColor = UIColor(.customGray)
        currentPlayerLabel.translatesAutoresizingMaskIntoConstraints = false
        currentPlayerContainer.addSubview(currentPlayerLabel)
        
        // Container to hold X or O view
        currentPlayerSymbolContainer.translatesAutoresizingMaskIntoConstraints = false
        currentPlayerContainer.addSubview(currentPlayerSymbolContainer)
        
        currentPlayerXView.translatesAutoresizingMaskIntoConstraints = false
        currentPlayerXView.isHidden = true
        currentPlayerSymbolContainer.addSubview(currentPlayerXView)
        
        currentPlayerOView.translatesAutoresizingMaskIntoConstraints = false
        currentPlayerOView.isHidden = true
        currentPlayerSymbolContainer.addSubview(currentPlayerOView)
        
        // Constraints for the current player label and symbol
        NSLayoutConstraint.activate([
            currentPlayerContainer.topAnchor.constraint(equalTo: gridContainer.topAnchor, constant: -50),
            currentPlayerContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            currentPlayerLabel.leadingAnchor.constraint(equalTo: currentPlayerContainer.leadingAnchor),
            currentPlayerLabel.centerYAnchor.constraint(equalTo: currentPlayerContainer.centerYAnchor),
            
            currentPlayerSymbolContainer.leadingAnchor.constraint(equalTo: currentPlayerLabel.trailingAnchor, constant: 10),
            currentPlayerSymbolContainer.trailingAnchor.constraint(equalTo: currentPlayerContainer.trailingAnchor),
            currentPlayerSymbolContainer.centerYAnchor.constraint(equalTo: currentPlayerLabel.centerYAnchor),
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
    
    func highlightWinningCells(_ winningMoves: [Move]) {
        for move in winningMoves {
            let button = gridButtons[move.row][move.col]
            button.backgroundColor = .systemGreen
        }
    }
    
    func clearWinningCells() {
        for row in gridButtons {
            for button in row {
                button.backgroundColor = .white
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
