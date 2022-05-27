//
//  File.swift
//  WWDC2022
//
//  Created by Franco Velasco on 4/6/22.
//

import Foundation
import SwiftUI

class BaseViewModel: ObservableObject {
    @Published var orientation: UIDeviceOrientation = UIDevice.current.orientation
    
    @Published var currentStoryPart: Storyline = .Beginning
    
    @Published var storylineParts: [StorylineModel] = []
    
    init() {
        self.storylineParts = StoryParser.fetchStories()
    }
    
    func nextStoryPart() {
        if Storyline.holdStorySet.contains(currentStoryPart) { return }
        self.currentStoryPart = self.currentStoryPart.nextPart()
    }
}
