//
//  File.swift
//  WWDC2022
//
//  Created by Franco Velasco on 4/14/22.
//

import Foundation
import SwiftUI

struct MapPickerView: View {
    @ObservedObject var viewModel: HubViewModel
    
    var geom: GeometryProxy
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text("Choose a City")
                .font(.title2)
                .fontWeight(.semibold)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: .zero, maximum: geom.size.width / 4)), count: 2), spacing: 16) {
                ForEach(MapOptions.allCases, id: \.self) { option in
                    Button(action: {
                        withAnimation {
                            viewModel.currentMap = option
                            viewModel.goalsAchieved = Set<MapGoal>()
                            viewModel.resetDistricts()
                            viewModel.fetchMapFromOptions(option)
                            viewModel.fetchMapSolution(option)
                            viewModel.showMapPicker.toggle()
                        }
                    }) {
                        HStack {
                            Spacer()
                            VStack(alignment: .center) {
                                Text(option.name)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    
                                Text(option.identifiableName)
                                    .font(.footnote)
                            }
                            Spacer()
                        }
                    }
                    .padding(8)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .foregroundColor(.white)
                }
                
                //text about random
                VStack {
                    Text("Note: it is not guaranteed that the Random Maps have solutions for all possible Council configurations!")
                        .font(.caption)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .foregroundColor(.black)
        .frame(width: geom.size.width / 2, height: geom.size.height, alignment: .center)
        .cornerRadius(16)
    }
}
