//
//  File.swift
//  WWDC2022
//
//  Created by Franco Velasco on 4/15/22.
//

import Foundation

extension Array where Element == StorylineModel {
    subscript(_ storyline: Storyline) -> StorylineModel {
        self[Swift.max(storyline.rawValue - 1, 0)]
    }
}
