//
//  File.swift
//  WWDC2022
//
//  Created by Franco Velasco on 4/7/22.
//

import Foundation
import SwiftUI

@objc
enum District: Int, Codable, CaseIterable {
    case First = 1, Second, Third, Fourth, Fifth
    
    var ordinal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        
        return formatter.string(from: self.rawValue as NSNumber)!
    }
    
    var color: Color {
        switch self {
            case .First:
                return .yellow
            case .Second:
                return .green
            case .Third:
                return .mint
            case .Fourth:
                return .purple
            case .Fifth:
                return .teal
        }
    }
    
    var arViewHeight: Float {
        Float(self.rawValue) * 0.01
    }
}
