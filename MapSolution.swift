//
//  File.swift
//  WWDC2022
//
//  Created by Franco Velasco on 4/14/22.
//

import Foundation

struct MapSolution: Decodable {
    typealias Coordinates = (row: Int, column: Int)
    
    var fair: [District: [Coordinates]] = [:]
    var majority: [District: [Coordinates]] = [:]
    var minority: [District: [Coordinates]] = [:]
    
    enum CodingKeys: String, CodingKey {
        case fair = "Fair Representation", majority = "Majority Landslide", minority = "Minority Win"
    }
    
    internal init(fairBase: [String: [[Int]]], majorityBase: [String: [[Int]]], minorityBase: [String: [[Int]]]) {
        for districtNumStr in fairBase.keys {
            let districtNum = Int(districtNumStr)!
            fair[District(rawValue: districtNum)!] = fairBase[districtNumStr]!.map { coord in
                return (coord[0], coord[1])
            }
            
            majority[District(rawValue: districtNum)!] = majorityBase[districtNumStr]!.map { coord in
                return (coord[0], coord[1])
            }
            
            minority[District(rawValue: districtNum)!] = minorityBase[districtNumStr]!.map { coord in
                return (coord[0], coord[1])
            }
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let fairDistricts = try container.decode([String: [[Int]]].self, forKey: .fair)
        let majorityDistricts = try container.decode([String: [[Int]]].self, forKey: .majority)
        let minorityDistricts = try container.decode([String: [[Int]]].self, forKey: .minority)
        
        self.init(fairBase: fairDistricts, majorityBase: majorityDistricts, minorityBase: minorityDistricts)
    }
}

enum MapSolutionKinds: String, CaseIterable {
    case fair = "Fair Representation", majority = "Majority Landslide", minority = "Minority Win", hide = "Hide Solution"
    
    var asMapGoal: MapGoal? {
        switch self {
            case .fair:
                return .Fair
            case .majority:
                return .GovSuperMajority
            case .minority:
                return .OppMajority
            case .hide:
                return nil
        }
    }
}
