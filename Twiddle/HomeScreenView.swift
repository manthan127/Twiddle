//
//  HomeScreenView.swift
//  Twiddle
//
//  Created by home on 17/03/22.
//

import SwiftUI

enum GameType: String {
    case rowsOnly = "rows only"
    case normal
}

struct BoardDetail: Hashable {
    var size: Int
    var gameType: GameType
    var rotation: Int
    
    var discerption: String {
        "\(size)x\(size) " + (gameType != .normal ? gameType.rawValue : (rotation != 2 ? "rotating \(rotation)x\(rotation) blocks" : "normal"))
    }
}

struct HomeScreenView: View {
    
    let gameTypes: [BoardDetail] = [
        BoardDetail(size: 3, gameType: .rowsOnly, rotation: 2),
        BoardDetail(size: 3, gameType: .normal, rotation: 2),
        BoardDetail(size: 4, gameType: .normal, rotation: 2),
        BoardDetail(size: 4, gameType: .normal, rotation: 3),
        BoardDetail(size: 5, gameType: .normal, rotation: 3),
        BoardDetail(size: 6, gameType: .normal, rotation: 4)
    ]

    @State var selectedType: BoardDetail = BoardDetail(size: 3, gameType: .normal, rotation: 2)
    
    @State var nav = false 
    
    var body: some View {
        ZStack {
            if nav {
                NavigationLink(
                    "", destination: GameScreenView(size: selectedType.size, gameType: selectedType.gameType, rotation: selectedType.rotation),
                    isActive: $nav)
            }
            VStack {
                Button(action: {nav.toggle()}, label: {
                    Text("Play")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .frame(width: 170, height: 75, alignment: .center)
                        .background(Color(#colorLiteral(red: 0.5, green: 0, blue: 1, alpha: 1)))
                        .cornerRadius(10)
                })
                
                Picker("game Type", selection: $selectedType) {
                    ForEach(gameTypes, id:\.self) { gameType in
                        Text(gameType.discerption)
                    }
                }
            }
        }
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NavigationView {
                HomeScreenView()
            }
        }
    }
}
