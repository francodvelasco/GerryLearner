//
//  File.swift
//  WWDC2022
//
//  Created by Franco Velasco on 4/8/22.
//

import Foundation

extension GridModel {
    func isCorner() -> Bool {
        return [0, 4].contains(self.column) && [0, 4].contains(self.row)
    }
    
    func isEdge() -> Bool {
        return [0, 4].contains(self.column) || [0, 4].contains(self.row)
    }
    
    func isNeighbor(_ grid: GridModel) -> Bool {
        return (grid.row == self.row && abs(self.column - grid.column) == 1) || (grid.column == self.column && abs(self.row - grid.row) == 1)
    }
}
