//
//  File.swift
//  WWDC2022
//
//  Created by Franco Velasco on 4/12/22.
//

import Foundation
import SwiftUI

enum Storyline: Int, CaseIterable {
    case Beginning = 0, Introduction, Rules, HowTo, Population, RedIntro, RedTechniques, RedFavor, BlueIntro, BlueMore, BlueFavor, BlackReturn, BlackLesson, BlackSegue, PostStory
    
    func nextPart() -> Storyline {
        let nextStoryNum = min(self.rawValue + 1, Storyline.allCases.count - 1)
        
        return Storyline(rawValue: nextStoryNum)!
    }
    
    static let showHighlightView: Set<Storyline> = [.Introduction, .Rules, .RedIntro, .RedTechniques, .BlueIntro, .BlueMore, .BlackReturn, .BlackLesson, .BlackSegue]
    
    static let holdStorySet: Set<Storyline> = [.Population, .RedFavor, .BlueFavor]
    
    func asMapGoal() -> MapGoal {
        switch self {
            case .Introduction, .Rules, .HowTo, .Population:
                return .Fair
            case .RedIntro, .RedTechniques, .RedFavor:
                return .OppMajority
            case .BlueIntro, .BlueMore, .BlueFavor:
                return .GovSuperMajority
            default:
                return .Fair
        }
    }
}

struct StorylineModel: Decodable {
    var color: Color
    var title: String
    var text: AttributedString
    
    init(color: Color, title: String, plainText: String) {
        self.color = color
        self.title = title
        
        do {
            self.text = try AttributedString(markdown: plainText, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace))
        } catch {
            self.text = AttributedString(plainText)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case color, title, text
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let color = try container.decode(Color.self, forKey: .color)
        let title = try container.decode(String.self, forKey: .title)
        let plainText = try container.decode(String.self, forKey: .text)
        
        self.init(color: color, title: title, plainText: plainText)
    }
}
