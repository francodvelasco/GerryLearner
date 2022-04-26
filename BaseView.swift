//
//  BaseView.swift
//  WWDC2022
//
//  Created by Franco Velasco on 4/6/22.
//

import Foundation
import SwiftUI

struct BaseView: View {
    @ObservedObject var viewModel: BaseViewModel
    @StateObject var hubViewModel: HubViewModel = HubViewModel()
    
    @Namespace var animationSpace
    
    var body: some View {
        GeometryReader { deviceGeom in
            ZStack {
                Color.white
                    .background(.ultraThickMaterial)
                    .edgesIgnoringSafeArea(.all)
                
                HubView(viewModel: hubViewModel, baseViewModel: viewModel, animationSpace: animationSpace)
                
                if viewModel.currentStoryPart == .Beginning {
                    ConversationHighlightView(baseViewModel: viewModel) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Let's Explore")
                                .font(.system(size: 56))
                            Group {
                                ZStack {
                                    Text("Gerrymandering")
                                        .fontWeight(.bold)
                                        .foregroundStyle(LinearGradient(colors: [Color("BlueParty"), Color("RedParty"), Color("BlueParty")], startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .offset(x: 4, y: 4)
                                    
                                    Text("Gerrymandering")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                            }
                                .font(.system(size: 72))
                        }
                        Spacer()
                        Button(action: {
                            withAnimation {
                                self.viewModel.currentStoryPart = viewModel.currentStoryPart.nextPart()
                            }
                        }) {
                            HStack {
                                Text("Explore!")
                                    .fontWeight(.medium)
                                Image(systemName: "arrow.right")
                            }
                            .font(.title)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                }
                
                if Storyline.showHighlightView.contains(viewModel.currentStoryPart) {
                    GeometryReader { g in
                        ConversationHighlightView(baseViewModel: viewModel) {
                            PersonMessageView(model: viewModel.storylineParts[viewModel.currentStoryPart])
                                .frame(width: g.size.width / 2)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .matchedGeometryEffect(id: "Conversation", in: animationSpace)
                        }
                        .animation(.easeInOut, value: 1)
                        .transition(.opacity)
                    }
                }
                
                if hubViewModel.showMapPicker {
                    Group {
                        Color.clear
                            .background(.ultraThickMaterial)
                    
                        MapPickerView(viewModel: hubViewModel, geom: deviceGeom)
                    }
                    .animation(.easeInOut, value: 1)
                    .transition(.opacity)
                }
            }
        }
    }
}
