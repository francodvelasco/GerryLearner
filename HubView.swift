//
//  File.swift
//  WWDC2022
//
//  Created by Franco Velasco on 4/13/22.
//

import Foundation
import SwiftUI

struct HubView: View {
    @ObservedObject var viewModel: HubViewModel
    @ObservedObject var baseViewModel: BaseViewModel
    
    var animationSpace: Namespace.ID
    
    var body: some View {
        ZStack {
            GeometryReader { g in
                VStack {
                    ZStack {
                        ForEach(0...30, id: \.self) { i in
                            let diameter = CGFloat.random(in: 0...g.size.width / 4)
                            Circle()
                                .fill(i % 2 == 0 ? Color("RedParty") : Color("BlueParty"))
                                .frame(width: diameter, height: diameter, alignment: .center)
                                .position(x: CGFloat.random(in: 0...g.size.width), y: CGFloat.random(in: 0...g.size.height))
                        }
                    }
                }
            
                Color.white
                    .opacity(0.8)
                    .edgesIgnoringSafeArea(.all)
                    .background(.ultraThinMaterial)
            
                VStack(alignment: .leading, spacing: 32) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("\(viewModel.currentMap.name)")
                                .font(.system(size: 48))
                                .fontWeight(.bold)
                                .foregroundStyle(LinearGradient(colors: [Color("BlueParty"), Color("RedParty")],
                                                                startPoint: .leading, endPoint: .trailing))
                            if viewModel.mapMode == .SwiftUI {
                                Group {
                                    Text("Creating ")
                                        .fontWeight(.semibold)
                                    + Text(viewModel.currentDistrictFocused.ordinal)
                                        .foregroundColor(viewModel.currentDistrictFocused.color)
                                        .fontWeight(.semibold)
                                    + Text(" District")
                                        .fontWeight(.semibold)
                                }
                                .font(.system(size: 32))
                            }
                        }
                        .foregroundColor(.black)
                        .padding(.trailing, 32)
                        
                        Spacer()
                        VStack {
                            if viewModel.mapMode == .SwiftUI {
                                HStack {
                                    if viewModel.currentMap == .Presentation {
                                        Button(action: {
                                            withAnimation {
                                                viewModel.pauseBeforeGoal.toggle()
                                                viewModel.pausedGoal = baseViewModel.currentStoryPart.asMapGoal()
                                                viewModel.presentPresentationMapSolution(baseViewModel.currentStoryPart)
                                            }
                                        }) {
                                            HStack {
                                                Spacer()
                                                Label("Solve Map", systemImage: "square.and.pencil")
                                                Spacer()
                                            }
                                            .foregroundColor(.white)
                                            .padding(8)
                                            .background(Color.blue)
                                            .frame(width: 192)
                                            .cornerRadius(8)
                                        }
                                    } else if viewModel.currentMap != .Random { //show if preloaded map is selected
                                        Picker(selection: $viewModel.showSolution, content: {
                                            ForEach(MapSolutionKinds.allCases, id: \.self) { kind in
                                                Text(kind.rawValue).tag(kind)
                                            }
                                        }, label: {
                                            HStack {
                                                Spacer()
                                                Label("Solve Map", systemImage: "square.and.pencil")
                                                Spacer()
                                            }
                                        })
                                        .pickerStyle(MenuPickerStyle())
                                        .frame(width: 192)
                                        .cornerRadius(8)
                                        .onReceive(viewModel.$showSolution) { kind in
                                            withAnimation {
                                                viewModel.presentMapSolution(kind)
                                                viewModel.pausedGoal = kind.asMapGoal ?? .Fair
                                                viewModel.pauseBeforeGoal.toggle()
                                            }
                                        }
                                    }
                                    
                                    if baseViewModel.currentStoryPart == .PostStory || viewModel.currentMap != .Presentation {
                                        Button(action: {
                                            withAnimation {
                                                self.viewModel.showMapPicker.toggle()
                                            }
                                        }) {
                                            HStack {
                                                Spacer()
                                                Label("Change Map", systemImage: "arrow.up.arrow.down")
                                                Spacer()
                                            }
                                            .foregroundColor(.white)
                                            .padding(8)
                                            .background(Color.blue)
                                            .cornerRadius(8)
                                        }
                                        .frame(width: 192)
                                        .onReceive(viewModel.$currentMap) { newMap in
                                            if newMap != viewModel.currentMap { //prevents a publisher loop
                                                withAnimation {
                                                    viewModel.goalsAchieved = Set<MapGoal>()
                                                    viewModel.fetchMapFromOptions(newMap)
                                                    viewModel.fetchMapSolution(newMap)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            HStack {
                                if viewModel.mapMode == .SwiftUI {
                                    Button(action: {
                                        withAnimation {
                                            viewModel.resetDistricts()
                                        }
                                    }) {
                                        HStack {
                                            Spacer()
                                            Label("Clear Map", systemImage: "clear")
                                            Spacer()
                                        }
                                            .foregroundColor(.white)
                                            .padding(8)
                                            .background(Color.blue)
                                            .cornerRadius(8)
                                    }
                                    .frame(width: 192)
                                }
                                
                                Button(action: {
                                    withAnimation {
                                        viewModel.toggleMap()
                                    }
                                }) {
                                    HStack {
                                        Spacer()
                                        Label(viewModel.mapMode.text(), systemImage: viewModel.mapMode.image())
                                        Spacer()
                                    }
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(Color.blue)
                                        .cornerRadius(8)
                                }
                                .frame(width: 192)
                                .onReceive(viewModel.$mapMode) { newMode in
                                    if newMode == .SwiftUI {
                                        viewModel.updateFromARClose()
                                    }
                                }
                            }
                        }
                    }
                    
                    if viewModel.mapMode == .SwiftUI {
                        HStack(alignment: .top, spacing: 8) {
                            VStack {
                                Text("Tap the blocks below!")
                                    .font(.caption)
                                MapView(viewModel: viewModel) //map
                            }
                            .padding(.horizontal)
                            
                            VStack(alignment:. leading, spacing: 16) {
                                Group {
                                    Text("Map Details")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                    GenericBarGraph(description: "Population", mapInfo: viewModel.mapInfo) //Population
                                    DistrictDetailsView(model: viewModel)
                                }
                                
                                MapGoalView(goalsMet: viewModel.goalsAchieved, mapInfo: viewModel.mapInfo, configuration: .Horizontal)
                                    .matchedGeometryEffect(id: "GoalView", in: animationSpace)
                                    .onReceive(viewModel.$districts) { newDistricts in
                                        guard !viewModel.pauseBeforeGoal else { return }
                                        
                                        goalsPrerequisiteForStoryCheck(districts: newDistricts)
                                    }
                                    .onReceive(baseViewModel.$currentStoryPart) { newPart in
                                        if Set<Storyline>(arrayLiteral: .BlueIntro, .RedIntro).contains(newPart) {
                                            viewModel.resetDistricts()
                                        }
                                    }
                            }
                        }
                    } else {
                        ZStack {
                            ARMapView(viewModel: viewModel)
                                .cornerRadius(8)
                            
                            VStack {
                                Spacer()
                                HStack(alignment: .bottom) {
                                    /*MapGoalView(goalsMet: viewModel.goalsAchieved, mapInfo: viewModel.mapInfo, configuration: .Horizontal)
                                        .matchedGeometryEffect(id: "GoalView", in: animationSpace)
                                        .onReceive(viewModel.$districts) { newDistricts in
                                            guard !viewModel.pauseBeforeGoal else { return }
                                            
                                            goalsPrerequisiteForStoryCheck(districts: newDistricts)
                                        }
                                        .onReceive(baseViewModel.$currentStoryPart) { newPart in
                                            if Set<Storyline>(arrayLiteral: .BlueIntro, .RedIntro).contains(newPart) {
                                                viewModel.resetDistricts()
                                            }
                                        }*/
                                    
                                    VStack(alignment: .leading) {
                                        Text("Current Goal")
                                        Text(baseViewModel.currentStoryPart.rawValue < Storyline.PostStory.rawValue ? baseViewModel.currentStoryPart.asMapGoal().rawValue : "Up to You!")
                                            .font(.system(.title3, design: .rounded))
                                            .fontWeight(.medium)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    
                                    if baseViewModel.currentStoryPart.rawValue < Storyline.PostStory.rawValue {
                                        PersonMessageView(model: baseViewModel.storylineParts[baseViewModel.currentStoryPart])
                                            .showNextArrow(false)
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(8)
                                            .matchedGeometryEffect(id: "Conversation", in: animationSpace)
                                    }
                                }
                                .padding(8)
                                .background(.ultraThinMaterial)
                                .cornerRadius(8)
                                .padding([.horizontal, .bottom], 8)
                            }
                            
                        }
                    }
                    
                    if viewModel.mapMode == .SwiftUI && baseViewModel.currentStoryPart.rawValue < Storyline.PostStory.rawValue {
                        PersonMessageView(model: baseViewModel.storylineParts[baseViewModel.currentStoryPart])
                            .padding()
                            .background(Color.white.background(.ultraThinMaterial))
                            .cornerRadius(8)
                            .matchedGeometryEffect(id: "Conversation", in: animationSpace)
                            .onTapGesture {
                                withAnimation {
                                    baseViewModel.nextStoryPart()
                                }
                            }
                        
                        HStack {
                            Spacer()
                            if viewModel.pauseBeforeGoal {
                                Button(action: {
                                    withAnimation {
                                        goalsPrerequisiteForStoryCheck()
                                        
                                        viewModel.pauseBeforeGoal.toggle()
                                    }
                                }) {
                                    Text("Proceed with Story")
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(Color.blue)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        
                        Spacer()
                    }
                }
                .padding()
                .onReceive(baseViewModel.$currentStoryPart) { nextPart in
                    if nextPart == .PostStory {
                        withAnimation {
                            viewModel.showMapPicker.toggle()
                        }
                    }
                }
            }
        }
        .foregroundColor(.black)
    }
    
    func goalsPrerequisiteForStoryCheck(districts: [District: Set<GridModel>]? = nil) {
        let districtCounts = districts?.districtCounts ?? viewModel.districts.districtCounts ?? (0, 0)
        var newGoal: MapGoal? = nil
        //check if goals are met
        for goal in MapGoal.allCases where goal.metCriteria(mapInfo: viewModel.mapInfo,
                                                            blueDistricts: districtCounts.blue,
                                                            redDistricts: districtCounts.red) {
            viewModel.goalsAchieved.insert(goal)
            newGoal = goal
        }
        //handle storyline
        
        guard let newGoal = newGoal else { return }

        switch baseViewModel.currentStoryPart.rawValue {
            case 0...4 where newGoal == .Fair:
                baseViewModel.currentStoryPart = .RedIntro
            case 5...7 where newGoal == .OppMajority:
                baseViewModel.currentStoryPart = .BlueIntro
            case 8...10 where newGoal == .GovSuperMajority:
                baseViewModel.currentStoryPart = .BlackReturn
            default:
                break
        }
    }
}

