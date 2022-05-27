//
//  File.swift
//  WWDC2022
//
//  Created by Franco Velasco on 4/8/22.
//

import Foundation

class MapParser {
    static func fetchMap(name: String) -> [[GridModel]] {
        do {
            guard let path = Bundle.main.path(forResource: name, ofType: "json"),
                  let data = try String(contentsOfFile: path).data(using: .utf8) else {
                print("can't find file")
                return []
                
            }
            
            let items: [GridModel] = try JSONDecoder().decode([GridModel].self, from: data)
            
            var doubleArray: [[GridModel]] = []
            
            for i in 0...4 {
                var row: [GridModel] = []
                for j in 0...4 {
                    row.append(items[i * 5 + j])
                }
                doubleArray.append(row)
            }
            
            return doubleArray
        } catch {
            print(error)
            return []
        }
    }
    
    internal enum SolutionMaps: String {
        case Presentation = "PresentationMapSolution",
             First = "Map1Solution",
             Second = "Map2Solution",
             Third = "Map3Solution"
    }
    
    static func fetchSolutions(_ map: SolutionMaps) -> MapSolution? {
        do {
            guard let path = Bundle.main.path(forResource: map.rawValue, ofType: "json"),
                  let data = try String(contentsOfFile: path).data(using: .utf8) else {
                print("can't find file")
                return nil
                
            }
            
            let solution: MapSolution = try JSONDecoder().decode(MapSolution.self, from: data)
            
            return solution
        } catch {
            print(error)
            return nil
        }
    }
}

class StoryParser {
    static func fetchStories() -> [StorylineModel] {
        
        do {
            guard let path = Bundle.main.path(forResource: "Storyline", ofType: "json"),
                  let data = try String(contentsOfFile: path).data(using: .utf8) else {
                print("file not found")
                return []
                
            }
            
            let storyItems: [StorylineModel] = try JSONDecoder().decode([StorylineModel].self, from: data)
            
            return storyItems
        } catch {
            print(error)
            return []
        }
    }
}
