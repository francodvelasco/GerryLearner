//
//  File.swift
//  WWDC2022
//
//  Created by Franco Velasco on 4/13/22.
//

import Foundation

@objc
class HubViewModel: MapViewModel {
    @Published var mapMode: MapViewMode = .SwiftUI
    
    @Published var goalsAchieved: Set<MapGoal> = []
    
    @Published var showMapPicker = false
    
    @Published var pauseBeforeGoal = false
    @Published var pausedGoal: MapGoal = .Fair
    
    func toggleMap() {
        self.mapMode = mapMode == .AR ? .SwiftUI : .AR
    }
    
    func checkDistrictGoals() {
        let districtWinners = districts.districtCounts ?? (0, 0)
        for goal in MapGoal.allCases {
            if goal.metCriteria(mapInfo: mapInfo, blueDistricts: districtWinners.blue, redDistricts: districtWinners.red) {
                goalsAchieved.insert(goal)
            }
        }
    }
    
    internal enum MapViewMode {
        case AR, SwiftUI
        
        func text() -> String {
            switch self {
                case .AR:
                    return "View Standard"
                case .SwiftUI:
                    return "View AR"
            }
        }
        
        func image() -> String {
            switch self {
                case .AR:
                    return "move.3d"
                case .SwiftUI:
                    return "map"
            }
        }
    }
    
    func updateFromAR(_ coordinator: ARMapCoordinator) {
        self.gridAreas = coordinator.gridAreas
        
        self.currentDistrictFocused = coordinator.currentDistrictFocused
    }
    
    func updateFromARClose() {
        for row in gridAreas {
            for grid in row where grid.district != nil {
                districts[grid.district!, default: Set<GridModel>()].insert(grid)
            }
        }
        
        checkDistrictGoals()
    }
}
