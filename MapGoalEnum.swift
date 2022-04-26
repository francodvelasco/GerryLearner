//
//  File.swift
//  WWDC2022
//
//  Created by Franco Velasco on 4/13/22.
//

import Foundation
import SwiftUI

enum MapGoal: String, CaseIterable {
    case Fair = "Fair Representation", GovSuperMajority = "Majority Landslide", OppMajority = "Minority Win"
    
    func subtitle(mapInfo: MapInfo) -> String {
        let parties: (winner: String, loser: String) = mapInfo.blues > mapInfo.reds ?
                                                        ("Blue", "Red") : ("Red", "Blue")
        
        switch self {
            case .Fair:
                return "3 \(parties.winner), 2 \(parties.loser)"
            case .GovSuperMajority:
                return "4 \(parties.winner), 1 \(parties.loser)"
            case .OppMajority:
                return "3 \(parties.loser), 2 \(parties.winner)"
        }
    }
    
    func metCriteria(mapInfo: MapInfo, blueDistricts: Int, redDistricts: Int) -> Bool {
        guard blueDistricts + redDistricts == 5 else { return false }
        
        let isBlueMajority = mapInfo.blues > mapInfo.reds
        
        switch self {
            case .Fair:
                return isBlueMajority ? blueDistricts == 3 : redDistricts == 3
            case .GovSuperMajority:
                return isBlueMajority ? blueDistricts >= 4 : redDistricts >= 4
            case .OppMajority:
                return isBlueMajority ? redDistricts >= 3 : blueDistricts >= 3
        }
    }
    
    func color(mapInfo: MapInfo) -> Color {
        (self == .OppMajority ? mapInfo.blues < mapInfo.reds : mapInfo.blues > mapInfo.reds)
        ? Color("BlueParty") : Color("RedParty")
    }
}

extension MapGoal: Decodable {
    
}

struct MapGoalView: View {
    internal enum Configuration {
        case Horizontal, Vertical
    }
    
    var goalsMet: Set<MapGoal>
    var mapInfo: MapInfo
    var configuration: Configuration
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Map Goals")
                .fontWeight(.medium)
                .font(.title3)
            
            FlexibleStack(configuration) {
                ForEach(MapGoal.allCases, id: \.self) { goal in
                    Group {
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Image(systemName: goalsMet.contains(goal) ? "checkmark.circle.fill" : "circle")
                                .opacity(goalsMet.contains(goal) ? 1 : 0)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(goal.rawValue)
                                    .font(.headline)
                                Text(goal.subtitle(mapInfo: mapInfo))
                            }
                            Spacer()
                        }
                    }
                    .padding(4)
                    .foregroundColor(goalsMet.contains(goal) ? .white : .black)
                    .background(goalsMet.contains(goal) ? goal.color(mapInfo: mapInfo) : Color.clear)
                }
            }
        }
    }
}

struct FlexibleStack<Content: View>: View {
    var configuration: MapGoalView.Configuration
    @ViewBuilder var view: () -> Content
    
    init(_ configuration: MapGoalView.Configuration, @ViewBuilder view: @escaping () -> Content) {
        self.configuration = configuration
        self.view = view
    }
    
    var body: some View {
        if configuration == .Horizontal {
            HStack {
                view()
            }
        } else if configuration == .Vertical {
            VStack {
                view()
            }
            .padding(4)
            .background(Color.white.opacity(0.5).background(.ultraThinMaterial))
            .cornerRadius(8)
        }
    }
}
