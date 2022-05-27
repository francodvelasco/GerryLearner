//
//  File 2.swift
//  WWDC2022
//
//  Created by Franco Velasco on 4/10/22.
//

import Foundation
import SwiftUI

extension Dictionary where Value == Set<GridModel> {
    func allGridsPresent(_ count: Int = 25) -> Bool {
        var temp: Int = 0
        
        for gridSet in self.values {
            temp += gridSet.count
        }
        
        return count == temp
    }
    
    func councilWinner() -> (name: String, color: Color)? {
        guard allGridsPresent() else { return nil }
        
        let tallies = districtCounts ?? (0, 0)
        
        if tallies.blue >= 3 {
            return ("Blue", Color("BlueParty"))
        } else if tallies.red >= 3 {
            return ("Red", Color("RedParty"))
        }
        
        return nil
    }
    
    
    var districtCounts: (blue: Int, red: Int)? {
        var tallies: (blue: Int, red: Int) = (0, 0)
        
        for district in self.values {
            let winner = district.getWinner()?.name
            
            if winner == "Blue" {
                tallies.blue += 1
            } else if winner == "Red" {
                tallies.red += 1
            }
        }
        
        return tallies
    }
}
