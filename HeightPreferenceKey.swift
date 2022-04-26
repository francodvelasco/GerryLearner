//
//  File.swift
//  WWDC2022
//
//  Created by Franco Velasco on 4/10/22.
//

import Foundation
import SwiftUI

/// This is a preference key that provides for the height of the view it is monitoring to be passed into a closure, which can be used for external purposes (such as adjusting the height of other views accordingly).
struct HeightPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    
    static var defaultValue: CGFloat = .zero
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
