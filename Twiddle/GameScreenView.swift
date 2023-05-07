//
//  GameScreenView.swift
//  Twiddle
//
//  Created by home on 17/03/22.
//

import SwiftUI

struct GameScreenView: View {
    @Environment(\.presentationMode) var presentationMode
    
    init(size: Int, gameType: GameType, rotation: Int)  {
        vm = GameScreenVM(size: size, gameType: gameType, rotation: rotation)
    }
    @ObservedObject var vm: GameScreenVM
    
    var body: some View {
        VStack {
            boardView
                .frame(width: CGFloat(vm.size) * 50, height: CGFloat(vm.size) * 50, alignment: .topLeading)
            .overlay(
                buttons
            )
        }
        .onAppear {
            vm.setBoard()
        }
        .alert(isPresented: $vm.win, content: {
            Alert(title: Text("won"), primaryButton: Alert.Button.default(Text("Home Screen"), action: {
                presentationMode.wrappedValue.dismiss()
            }), secondaryButton: Alert.Button.default(Text("play again"), action: {
                vm.resetData()
            }))
        })
    }
    
    var boardView: some View {
        ZStack {
            ForEach(vm.board.indices, id: \.self) { row in
                ForEach(vm.board[row].indices, id:\.self) { column in
                    cellView(cell: vm.board[row][column])
                        .offset(x: CGFloat(column*50), y: CGFloat(row*50))
                }
            }
        }
    }
    
    func cellView(cell: Int)-> some View {
        Text(cell.description)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.green.opacity(0.5))
            .padding(2.5)
            .frame(width: 50, height: 50)
    }
    
    var buttons: some View {
        VStack(spacing: 0) {
            let x = vm.size - vm.rotation + 1
            ForEach(0..<x, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<x, id: \.self) { column in
                        Color.white.opacity(0.001)
                            .frame(maxWidth: column == 0 || column == x-1 ? .infinity : 50,
                                   maxHeight: row == 0 || row == x-1 ? .infinity : 50)
                            .onTapGesture(count: 2) {
                                vm.rotate(row: row, column: column, clockWise: true)
                            }
                            .onTapGesture {
                                vm.rotate(row: row, column: column, clockWise: false)
                            }
                            .border(Color.red.opacity(0.5), width: 0.3)
                    }
                }
            }
        }
    }    
}

struct GameScreenView_Previews: PreviewProvider {
    static var previews: some View {
        GameScreenView(size: 3, gameType: .normal, rotation: 2)
    }
}
