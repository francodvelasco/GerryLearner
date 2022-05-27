//
//  File.swift
//  WWDC2022
//
//  Created by Franco Velasco on 4/17/22.
//

import Foundation
import SwiftUI

struct DistrictDetailsView: View {
    @ObservedObject var model: HubViewModel
    
    var districtWinners: (blue: Int, red: Int)? {
        model.districts.districtCounts
    }
    
    var body: some View {
        VStack(spacing: 4) {
            GenericBarGraph(description: "Districts", currentSeats: districtWinners, totalSeats: 5)
            HStack(spacing: 4) {
                ForEach(District.allCases, id: \.self) { district in
                    let winner = model.districts[district]!.getWinner()
                    
                    Menu(content: {
                        Button(action: {
                            withAnimation {
                                model.changeDistrict(to: district, winningDetails: winner)
                            }
                        }) {
                            Label("Select District", systemImage: "highlighter")
                        }
                        
                        Button(action: {
                            withAnimation {
                                model.clearDistrict(district)
                                model.currentDistrictFocused = district
                            }
                        }) {
                            Label("Clear District", systemImage: "clear")
                        }
                    }, label: {
                        HStack(spacing: 0) {
                            HStack(spacing: 0) {
                                Rectangle()
                                    .fill(district.color)
                                    .frame(width: 10)
                                VStack {
                                    Spacer()
                                    HStack {
                                        Text("\(district.ordinal) District")
                                        Spacer()
                                        if let name = winner?.name {
                                            Text(String(name.first!))
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal, 8)
                                .background(winner?.color ?? district.color)
                                .frame(height: 40)
                                .foregroundColor(winner != nil ? .white : .black)
                            }
                            .frame(height: 40)
                        }
                    })
                }
            }
            .frame(height: 40)
        }
    }
}
