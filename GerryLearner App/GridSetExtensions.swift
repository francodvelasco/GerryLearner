//
//  SetExtensions.swift
//  WWDC2022
//
//  Created by Franco Velasco on 4/8/22.
//

import Foundation
import SwiftUI

extension Set where Element == GridModel {
    func popCount() -> Int {
        self.map { grid in
            return grid.population
        }.reduce(0, +)
    }
    
    func getWinner() -> (name: String, color: Color)? {
        var tallies: (blue: Int, red: Int) = (0, 0)
        
        for grid in self {
            grid.color == Color("BlueParty") ? (tallies.blue += grid.population) : (tallies.red += grid.population)
            
            if tallies.blue >= 3 {
                return ("Blue", Color("BlueParty"))
            } else if tallies.red >= 3 {
                return ("Red", Color("RedParty"))
            }
        }
        
        return nil
    }
    
    func isConnected(_ grid: GridModel) -> Bool {
        var connected = false
        
        for internalGrid in self {
            connected = connected || internalGrid.isNeighbor(grid)
        }
        
        return connected
    }
}

