//
//  File.swift
//  WWDC2022
//
//  Created by Franco Velasco on 4/9/22.
//

import Foundation
import SwiftUI

class GridModel: Hashable, Decodable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func == (lhs: GridModel, rhs: GridModel) -> Bool {
        if let leftID = lhs.uuid, let rightID = rhs.uuid {
            return lhs.column == rhs.column && lhs.row == rhs.row && leftID == rightID
        }
        
        return lhs.column == rhs.column && lhs.row == rhs.row
    }
    
    init(column: Int, row: Int, population: Int, color: Color) {
        self.uuid = UUID()
        self.column = column
        self.row = row
        self.population = population
        self.color = color
    }
    
    var uuid: UUID? = UUID()
    var column: Int
    var row: Int
    var population: Int
    var color: Color?
    var district: District?
    
    enum CodingKeys: String, CodingKey {
        case column, row, population, color
    }
}
