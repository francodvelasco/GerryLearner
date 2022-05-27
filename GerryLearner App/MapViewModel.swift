//
//  File.swift
//  WWDC2022
//
//  Created by Franco Velasco on 4/10/22.
//

import Foundation
import SwiftUI

class MapViewModel: NSObject, ObservableObject {
    typealias Parties = (blue: Int, red: Int)
    
    var gridAreas: [[GridModel]] = []
    var mapInfo: MapInfo = MapInfo(total: 0, blues: 0, reds: 0)
    
    @Published var currentMap: MapOptions = .Presentation
    
    @Published var districts: [District: Set<GridModel>] = [:]
    var currentDistrictFocused: District = .First
    
    @Published var solutionData: MapSolution? = nil
    @Published var showSolution: MapSolutionKinds = .hide
    
    var arError: Bool = false
    
    override init() {
        super.init()
        createPresentationMap()
        
        for district in District.allCases {
            districts[district] = Set<GridModel>()
        }
    }
    
    /// Load a preloaded map according to its number
    init(presetMap: Int) {
        super.init()
        createPresetMap(presetMap)
        
        for district in District.allCases {
            districts[district] = Set<GridModel>()
        }
    }
    
    /// Create a random map with a defined population size, supporters for the Blue Party and supporters of the Red Party
    init(total: Int, blues: Int, reds: Int) {
        super.init()
        createRandomMap(total: total, blues: blues, reds: reds)
    }
    
    func createPresentationMap() {
        self.currentMap = .Presentation
        self.showSolution = .hide
        
        resetDistricts()
        
        gridAreas = MapParser.fetchMap(name: "PresentationMap")
        mapInfo = MapInfo(total: 25, blues: 16, reds: 9)
        fetchMapSolution(.Presentation)
    }
    
    func createPresetMap(_ number: Int) {
        self.currentMap = MapOptions(rawValue: number)!
        self.showSolution = .hide
        
        resetDistricts()
        
        gridAreas = MapParser.fetchMap(name: "Map\(number)")
        fetchMapSolution(MapOptions(rawValue: number)!)
        
        switch number {
            case 1:
                mapInfo = MapInfo(total: 25, blues: 11, reds: 14)
            case 2:
                mapInfo = MapInfo(total: 25, blues: 16, reds: 9)
            case 3:
                mapInfo = MapInfo(total: 25, blues: 10, reds: 15)
            default:
                return
        }
    }
    
    func createRandomMap(total: Int, blues: Int, reds: Int) {
        guard total == blues + reds else { return }
        
        self.currentMap = .Random
        self.showSolution = .hide
        
        let populationGenerator = PopulationGenerator()
        
        var tallies: Parties = (blues, reds)
        var blueProbability: Double = Double(blues) / Double(total)
        
        mapInfo = MapInfo(total: 25, blues: blues, reds: reds)
        gridAreas = (0...4).map { row in
            return (0...4).map { column in
                if (row, column) == (4, 3) {
                    return GridModel(column: column, row: row, population: tallies.red, color: Color("RedParty"))
                }
                
                if (row, column) == (4, 4) {
                    return GridModel(column: column, row: row, population: tallies.blue, color: Color("BlueParty"))
                }
                
                let isBlue: Bool = Int.random(in: 0...100) < Int(blueProbability * 100)
                
                if (isBlue ? (tallies.blue <= 3) : (tallies.red <= 3)) {
                    let grid = GridModel(column: column, row: row,
                                     population: isBlue ? tallies.blue : tallies.red,
                                     color: isBlue ? Color("BlueParty") : Color("RedParty"))
                    
                    isBlue ? (tallies.blue = 0) : (tallies.red = 0)
                    
                    return grid
                }
                
                let population = populationGenerator.generatePopulationForGrid(
                    current: isBlue ? tallies.blue : tallies.red,
                    total: isBlue ? blues : reds
                )
                
                isBlue ? (tallies.blue -= population) : (tallies.red -= population)
                
                blueProbability = Double(tallies.blue) / Double(total)
                
                return GridModel(column: column, row: row, population: population, color: isBlue ? Color("BlueParty") : Color("RedParty"))
            }
        }
        fetchMapSolution(.Random)
    }
    
    /// This method creates a truly random map, where the population proportion per party is randomzied per method call. There is a base of 9 members for a certain party, so that there's a possible chance that the minority party can win a majority of seats.
    func createTrulyRandomMap() {
        let blues = Int.random(in: 9...16)
        let reds = 25 - blues
        
        createRandomMap(total: 25, blues: blues, reds: reds)
    }
    
    func handleGridTap(row: Int, column: Int) {
        if districts[currentDistrictFocused]!.contains(gridAreas[row][column]) {
            removeGrid(row: row, column: column)
        } else {
            addGridToDistrict(row: row, column: column)
        }
    }
    
    func addGridToDistrict(row: Int, column: Int) {
        if districts[currentDistrictFocused]!.isEmpty {
            districts[currentDistrictFocused]!.insert(gridAreas[row][column])
            gridAreas[row][column].district = currentDistrictFocused
            return
        }
        
        guard gridAreas[row][column].district == nil else { return }
        
        guard districts[currentDistrictFocused]!.isConnected(gridAreas[row][column]) else { return }
        
        guard districts[currentDistrictFocused]!.popCount() + gridAreas[row][column].population <= 5 else { return }
        
        districts[currentDistrictFocused]!.insert(gridAreas[row][column])
        gridAreas[row][column].district = currentDistrictFocused
        
        if districts[currentDistrictFocused]!.popCount() == 5 {
            self.currentDistrictFocused = nextAvailableDistrict(currentDistrictFocused)
        }
    }
    
    func nextAvailableDistrict(_ district: District) -> District {
        return nextAvailableDistrictRaw(district.rawValue)
    }
    
    func nextAvailableDistrictRaw(_ raw: Int) -> District {
        let currentDistrict = District(rawValue: min(raw, 5))!
        
        if districts[currentDistrict]!.popCount() == 5 && currentDistrict != .Fifth {
            return nextAvailableDistrictRaw(raw + 1)
        }
        
        return currentDistrict
    }
    
    func removeGrid(row: Int, column: Int) {
        districts[currentDistrictFocused]!.remove(gridAreas[row][column])
        gridAreas[row][column].district = nil
    }
    
    func resetDistricts() {
        for key in districts.keys {
            districts[key] = Set<GridModel>()
        }
        
        for row in gridAreas {
            for block in row {
                block.district = nil
            }
        }
        
        self.currentDistrictFocused = .First
    }
    
    func clearDistrict(_ district: District) {
        for grid in districts[district]! {
            grid.district = nil
        }
        
        districts[district]! = Set<GridModel>()
    }
    
    func changeDistrict(to new: District, winningDetails: (String, Color)? = nil) {
        if winningDetails != nil { return }
        clearDistrict(new)
        
        self.currentDistrictFocused = new
    }
    
    //show solution method
    func fetchMapSolution(_ newMap: MapOptions) {
        guard let solutionMap = newMap.asSolutionMap else {
            self.solutionData = nil
            return
        }
        
        self.solutionData = MapParser.fetchSolutions(solutionMap)
    }
    
    func presentMapSolution(_ kind: MapSolutionKinds) {
        guard let solutionData = solutionData else { return }
        
        guard kind != .hide else { return }
        
        resetDistricts()
        
        let districtSolutions: [District: [MapSolution.Coordinates]]
        
        switch kind {
            case .fair:
                districtSolutions = solutionData.fair
            case .majority:
                districtSolutions = solutionData.majority
            case .minority:
                districtSolutions = solutionData.minority
            case .hide:
                return
        }
        
        for district in districtSolutions.keys {
            let coordinates = districtSolutions[district]!
            
            for coordinate in coordinates {
                districts[district]!.insert(gridAreas[coordinate.row][coordinate.column])
                gridAreas[coordinate.row][coordinate.column].district = district
            }
        }
    }
    
    func presentPresentationMapSolution(_ storyline: Storyline) {
        guard let solutionData = solutionData else { return }
        
        resetDistricts()
        
        let districtSolutions: [District: [MapSolution.Coordinates]]
        
        switch storyline {
            case .Introduction, .Rules, .HowTo, .Population:
                districtSolutions = solutionData.fair
            case .RedIntro, .RedTechniques, .RedFavor:
                districtSolutions = solutionData.minority
            case .BlueIntro, .BlueMore, .BlueFavor:
                districtSolutions = solutionData.majority
            default:
                return
        }
        
        for district in districtSolutions.keys {
            let coordinates = districtSolutions[district]!
            
            for coordinate in coordinates {
                districts[district]!.insert(gridAreas[coordinate.row][coordinate.column])
                gridAreas[coordinate.row][coordinate.column].district = district
            }
        }
    }
    
    func fetchMapFromOptions(_ newMap: MapOptions) {
        switch newMap {
            case .Presentation:
                createPresentationMap()
            case .FirstMap, .SecondMap, .ThirdMap:
                createPresetMap(newMap.rawValue)
            case .Random:
                createTrulyRandomMap()
        }
    }
}

@objc
enum MapOptions: Int, CaseIterable {
    case Presentation = 0, FirstMap, SecondMap, ThirdMap, Random
    
    var name: String {
        switch self {
            case .Presentation:
                return "Gridlandia"
            case .FirstMap:
                return "Square City"
            case .SecondMap:
                return "Block Sur"
            case .ThirdMap:
                return "Plania"
            case .Random:
                return "Mysteria"
        }
    }
    
    var identifiableName: String {
        switch self {
            case .Presentation:
                return "Presentation Map"
            case .FirstMap, .SecondMap, .ThirdMap:
                return "Map \(self.rawValue)"
            case .Random:
                return "Random Map"
        }
    }
    
    var asSolutionMap: MapParser.SolutionMaps? {
        switch self {
            case .Presentation:
                return .Presentation
            case .FirstMap:
                return .First
            case .SecondMap:
                return .Second
            case .ThirdMap:
                return .Third
            case .Random:
                return nil
        }
    }
}
