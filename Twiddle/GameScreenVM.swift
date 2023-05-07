//
//  GameScreenVM.swift
//  Twiddle
//
//  Created by home on 18/04/22.
//

import Foundation

class GameScreenVM: ObservableObject {
    @Published var size: Int
    @Published var gameType: GameType
    @Published var rotation: Int
    
    @Published var board: [[Int]] = []
    
    @Published var win = false
    
    var answerBoard: [[Int]] = []
    
    init(size: Int, gameType: GameType, rotation: Int) {
        self.size = size
        self.gameType = gameType
        self.rotation = rotation
        
        self.board = Array(repeating: Array(repeating: 0, count: size), count: size)
        
        self.answerBoard = self.board
    }
    
    func setBoard() {
        let max = size * size
        var tempBoard:[[Int]] = answerBoard
        
        var random: [Int] = []
        if gameType != .rowsOnly {
            random = Array(1...max)
        } else {
            for i in 1...size {
                random.append(contentsOf: Array(repeating: i, count: size))
            }
        }
        random = random.shuffled()
        
        for i in 0..<size {
            for j in 0..<size {
                let n = i * size + j
                answerBoard[i][j] = (gameType == .rowsOnly ? i : n)+1
                tempBoard[i][j] = random[n]
            }
        }
        board = tempBoard
    }
    
    func resetData() {
        win = false
        setBoard()
    }
    
    func cheakWin() {
        win = board == answerBoard
    }
    
    func rotate(row: Int, column: Int, clockWise: Bool) {
        
        if clockWise {
            transpose(row: row, column: column)
            reverse(row: row, column: column)
        } else {
            reverse(row: row, column: column)
            transpose(row: row, column: column)
        }
        
        cheakWin()
    }
    
    
    func reverse(row: Int, column: Int) {
        var c = column
        var rc = column+rotation - 1
        
        for i in row..<row+rotation {
            while c < rc {
                (board[i][c], board[i][rc]) = (board[i][rc], board[i][c])
                c+=1; rc-=1
            }
            c = column
            rc = column+rotation - 1
        }
    }
    
    func transpose(row: Int, column: Int) {
        var tempArr: [[Int]] = board[row..<row+rotation].map{Array($0[column..<column+rotation])}
        
        for i in tempArr.indices {
            for j in i..<tempArr.count {
                (tempArr[i][j], tempArr[j][i]) = (tempArr[j][i], tempArr[i][j])
            }
        }
        
        var x = 0, y = 0
        for i in row..<row+rotation {
            y = 0
            for j in column..<column+rotation {
                board[i][j] = tempArr[x][y]
                y+=1
            }
            x+=1
        }
    }
}
