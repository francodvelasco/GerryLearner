//
//  SwiftUIView.swift
//  
//
//  Created by Franco Velasco on 4/10/22.
//

import SwiftUI

struct ConversationHighlightView<Conversation: View>: View {
    @ObservedObject var baseViewModel: BaseViewModel
    @ViewBuilder var conversation: Conversation
    
    var body: some View {
        GeometryReader { g in
            ZStack {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        conversation
                        Spacer()
                    }
                    Spacer()
                }
                .background(.ultraThinMaterial)
            }
            .onTapGesture {
                withAnimation(.default) {
                    baseViewModel.nextStoryPart()
                }
            }
        }
    }
}

/*
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
*/
