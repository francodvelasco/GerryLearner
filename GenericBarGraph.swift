//
//  File.swift
//  WWDC2022
//
//  Created by Franco Velasco on 4/10/22.
//

import Foundation
import SwiftUI

struct GenericBarGraph: View {
    var description: String
    var blue: Int
    var red: Int
    var total: Int
    
    init(description: String, blue: Int, red: Int, total: Int) {
        self.description = description
        self.blue = blue
        self.red = red
        self.total = total
    }
    
    init(description: String, mapInfo: MapInfo) {
        self.description = description
        self.blue = mapInfo.blues
        self.red = mapInfo.reds
        self.total = mapInfo.total
    }
    
    init(description: String, currentSeats: (blue: Int, red: Int)?, totalSeats: Int) {
        self.description = description
        self.blue = currentSeats?.blue ?? 0
        self.red = currentSeats?.red ?? 0
        self.total = totalSeats
    }
    
    var body: some View {
        HStack(spacing: 0) {
            HStack {
                Spacer()
                Text(description)
                    .font(.title3)
                    .fontWeight(.medium)
                    .frame(width: 100, alignment: .trailing)
            }
            .frame(width: 100, alignment: .trailing)
            .padding(.horizontal, 4)
            
            GeometryReader { g in
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color("RedParty"))
                        .frame(width: CGFloat(red) / CGFloat(total) * g.size.width)
                        .overlay {
                            HStack(spacing: 2) {
                                Text("\(red)")
                                    .font(.title2)
                                    .fontWeight(Double(red) / Double(total) > 0.5 ? .bold : .regular)
                                if description != "Population" {
                                    Image(systemName: "checkmark")
                                        .opacity(Double(red) / Double(total) > 0.5 ? 1 : 0)
                                }
                                Spacer()
                                if description != "Population" && Double(red) / Double(total) > 0.5 {
                                    Text("Red Party Control")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                }
                            }
                            .padding(.horizontal, 4)
                        }
                    Rectangle()
                        .fill(Color.white)
                    Rectangle()
                        .fill(Color("BlueParty"))
                        .frame(width: CGFloat(blue) / CGFloat(total) * g.size.width)
                        .overlay {
                            HStack(spacing: 2) {
                                if description != "Population" && Double(blue) / Double(total) > 0.5 {
                                    Text("Blue Party Control")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                }
                                Spacer()
                                if description != "Population" {
                                    Image(systemName: "checkmark")
                                        .opacity(Double(blue) / Double(total) > 0.5 ? 1 : 0)
                                }
                                Text("\(blue)")
                                    .font(.title2)
                                    .fontWeight(Double(blue) / Double(total) > 0.5 ? .bold : .regular)
                            }
                            .padding(.horizontal, 4)
                        }
                    }
                .overlay {
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 2)
                        .position(x: g.size.width / 2, y: g.size.height / 2)
                }
                }
                .foregroundColor(.white)
        }
        .frame(height: 40)
    }
}
