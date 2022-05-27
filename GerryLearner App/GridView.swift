//
//  File.swift
//  WWDC2022
//
//  Created by Franco Velasco on 4/7/22.
//

import Foundation
import SwiftUI

struct GridView: View {
    var model: GridModel
    var onTap: (Int, Int) -> ()
    
    var body: some View {
        ZStack(alignment: .center) {
            //Background of the tile
            Rectangle()
                .fill(model.district?.color.opacity(0.5) ?? .white)
                .frame(width: 80, height: 80, alignment: .center)
            
            //Visual representation of the people in the tile
            VStack(alignment: .center, spacing: 8) {
                if model.population > 1 {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(model.color ?? .white)
                            .frame(width: 24, height: 24, alignment: .center)
                        Circle()
                            .fill(model.color ?? .white)
                            .frame(width: 24, height: 24, alignment: .center)
                    }
                }
                
                if model.population % 2 == 1 {
                    Circle()
                        .fill(model.color ?? .white)
                        .frame(width: 25, height: 25, alignment: .center)
                }
                
                if model.population > 3 {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(model.color ?? .white)
                            .frame(width: 24, height: 24, alignment: .center)
                        Circle()
                            .fill(model.color ?? .white)
                            .frame(width: 24, height: 24, alignment: .center)
                    }
                }
            }
            
            //Show the number for easier reading
            VStack {
                Spacer()
                HStack {
                    Text("\(model.population)\(model.color.personName)")
                        .foregroundColor(model.color ?? .black)
                        .font(.callout)
                    Spacer()
                }
            }
            .padding([.leading, .bottom], 2)
        }
        .frame(width: 80, height: 80, alignment: .center)
        .border(Color.gray, width: 1)
        .onTapGesture {
            onTap(model.row, model.column)
        }
    }
}

fileprivate extension Optional where Wrapped == Color {
    var personName: String {
        switch self {
            case .some(Color("BlueParty")):
                return "B"
            case .some(Color("RedParty")):
                return "R"
            default:
                return ""
        }
    }
}

