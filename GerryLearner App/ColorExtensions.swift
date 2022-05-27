//
//  Extensions that allow for the SwiftUI Color object to conform to Codable,
//
//  ColorExtensions.swift
//  WWDC2022
//
//  Created by Franco Velasco on 4/8/22.
//

import Foundation
import SwiftUI

fileprivate extension Color {
    typealias RGBRep = (red: CGFloat, green: CGFloat, blue: CGFloat)
    
    var components: RGBRep {
        var color: RGBRep = (0, 0, 0)
        
        guard UIColor(self).getRed(&color.red, green: &color.green, blue: &color.blue, alpha: nil) else {
            return (0, 0, 0)
        }
        
        return color
    }
}

extension Color: Decodable {
    enum CodingKeys: String, CodingKey {
        case title
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let title = try container.decode(String.self, forKey: .title)
        
        self.init(decodedString: title)
    }
    
    public init(decodedString name: String) {
        if name == "red" {
            self.init("RedParty")
        } else if name == "blue" {
            self.init("BlueParty")
        } else if name == "black" {
            self.init(UIColor.black)
        } else {
            self.init(white: 1.0)
        }
    }
}
