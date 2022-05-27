//
//  File.swift
//  WWDC2022
//
//  Created by Franco Velasco on 4/7/22.
//

import Foundation
import SwiftUI

struct MapView: View {
    @ObservedObject var viewModel: MapViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.gridAreas, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(row, id: \.self) { block in
                        GridView(model: block) { row, column in
                            //handle taps here
                            withAnimation(.default) {
                                viewModel.handleGridTap(row: row, column: column)
                            }
                        }
                    }
                }
            }
        }
        .border(Color.black, width: 4)
        .cornerRadius(4)
    }
}


