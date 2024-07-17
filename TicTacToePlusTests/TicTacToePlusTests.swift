//
//  TicTacToePlusTests.swift
//  TicTacToePlusTests
//
//  Created by Shawn Cole on 7/15/24.
//

import XCTest
@testable import TicTacToePlus

final class TicTacToePlusTests: XCTestCase {
    var viewModel: TicTacToeViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = TicTacToeViewModel(gridSize: 4)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialSetup() {
        XCTAssertEqual(viewModel.gridSize, 4)
        XCTAssertEqual(viewModel.currentPlayer.symbol, .X)
        XCTAssertTrue(viewModel.playerX.moves.isEmpty)
        XCTAssertTrue(viewModel.playerO.moves.isEmpty)
    }
    
    func testMakeMove() {
        viewModel.makeMove(row: 0, col: 0)
        XCTAssertTrue(viewModel.playerX.moves.contains(Move(row: 0, col: 0)))
        XCTAssertEqual(viewModel.currentPlayer.symbol, .O)
        
        viewModel.makeMove(row: 1, col: 0)
        XCTAssertTrue(viewModel.playerO.moves.contains(Move(row: 1, col: 0)))
        XCTAssertEqual(viewModel.currentPlayer.symbol, .X)
    }
    
    func testResetGame() {
        viewModel.makeMove(row: 0, col: 0)
        viewModel.resetGame()
        XCTAssertTrue(viewModel.playerX.moves.isEmpty)
        XCTAssertTrue(viewModel.playerO.moves.isEmpty)
        XCTAssertEqual(viewModel.currentPlayer.symbol, .X)
    }
    
    func testWinConditionRow() {
        viewModel.makeMove(row: 0, col: 0)
        viewModel.makeMove(row: 1, col: 0)
        viewModel.makeMove(row: 0, col: 1)
        viewModel.makeMove(row: 1, col: 1)
        viewModel.makeMove(row: 0, col: 2)
        viewModel.makeMove(row: 1, col: 2)
        viewModel.makeMove(row: 0, col: 3)
        XCTAssertTrue(viewModel.checkForWin(player: viewModel.playerX) != nil)
    }
    
    func testWinConditionColumn() {
        viewModel.makeMove(row: 0, col: 0)
        viewModel.makeMove(row: 0, col: 1)
        viewModel.makeMove(row: 1, col: 0)
        viewModel.makeMove(row: 1, col: 1)
        viewModel.makeMove(row: 2, col: 0)
        viewModel.makeMove(row: 2, col: 1)
        viewModel.makeMove(row: 3, col: 0)
        XCTAssertTrue(viewModel.checkForWin(player: viewModel.playerX) != nil)
    }
    
    func testWinConditionDiagonal() {
        viewModel.makeMove(row: 0, col: 0)
        viewModel.makeMove(row: 0, col: 1)
        viewModel.makeMove(row: 1, col: 1)
        viewModel.makeMove(row: 1, col: 2)
        viewModel.makeMove(row: 2, col: 2)
        viewModel.makeMove(row: 2, col: 3)
        viewModel.makeMove(row: 3, col: 3)
        XCTAssertTrue(viewModel.checkForWin(player: viewModel.playerX) != nil)
    }
    
    func testWinConditionCorners() {
        viewModel.makeMove(row: 0, col: 0)
        viewModel.makeMove(row: 1, col: 1)
        viewModel.makeMove(row: 0, col: 3)
        viewModel.makeMove(row: 1, col: 2)
        viewModel.makeMove(row: 3, col: 0)
        viewModel.makeMove(row: 2, col: 1)
        viewModel.makeMove(row: 3, col: 3)
        XCTAssertTrue(viewModel.checkForWin(player: viewModel.playerX) != nil)
    }
    
    func testWinConditionBox() {
        viewModel.makeMove(row: 1, col: 1)
        viewModel.makeMove(row: 0, col: 0)
        viewModel.makeMove(row: 1, col: 2)
        viewModel.makeMove(row: 0, col: 1)
        viewModel.makeMove(row: 2, col: 1)
        viewModel.makeMove(row: 0, col: 2)
        viewModel.makeMove(row: 2, col: 2)
        XCTAssertTrue(viewModel.checkForWin(player: viewModel.playerX) != nil)
    }
}
