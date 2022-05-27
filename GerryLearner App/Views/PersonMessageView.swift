//
//  SwiftUIView.swift
//  
//
//  Created by Franco Velasco on 4/10/22.
//

import SwiftUI

struct PersonMessageView: View {
    @State var nextArrow: Bool = true
    var model: StorylineModel
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "person.fill")
                .font(.system(size: 48))
            VStack(alignment: .leading) {
                Text(model.title)
                    .font(.caption)
                Text(model.text)
                    .lineLimit(nil)
            }
            Spacer()
            if nextArrow {
                Image(systemName: "arrow.right")
                    .foregroundColor(.blue)
            }
        }
        .foregroundColor(model.color)
    }
    
    func showNextArrow(_ show: Bool) -> Self {
        self.nextArrow = show
        return self
    }
}
