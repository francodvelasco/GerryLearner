//
//  File.swift
//  WWDC2022
//
//  Created by Franco Velasco on 4/7/22.
//

import Foundation
import RealityKit
import ARKit
import SwiftUI

struct ARMapView: UIViewRepresentable {
    @ObservedObject var viewModel: HubViewModel
    
    typealias UIViewType = ARView
    typealias Coordinator = ARMapCoordinator
    
    let arView = ARView(frame: .init(x: 1, y: 1, width: 1, height: 1), cameraMode: .ar, automaticallyConfigureSession: true)
    
    var barView: ARBarView?
    
    var originPosition: SIMD3<Float> = [0, -0.2, -0.2]
    
    init(viewModel: HubViewModel) {
        self.viewModel = viewModel
        
        self.barView = ARBarView(model: viewModel)
    }
    
    func makeUIView(context: Context) -> ARView {
        arView.session.delegate = context.coordinator
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        arView.session.run(configuration)
        
        arView.addGestureRecognizer(
            UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        )
        
        for row in viewModel.gridAreas {
            for grid in row {
                grid.addToView(view: arView, originPosition: originPosition)
            }
        }
        
        if let barView = barView {
            barView.addToView(view: arView, originPosition: originPosition)
        }
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        //handle changes from mapviewmodel to coord, and vice versa
        guard context.coordinator.needsUpdate else { return }
        
        viewModel.updateFromAR(context.coordinator)
        context.coordinator.needsUpdate.toggle()
    }
    
    func makeCoordinator() -> ARMapCoordinator {
        ARMapCoordinator(parent: self)
    }
}

//rewrite to essentially be the new mapviewmodel
class ARMapCoordinator: HubViewModel, ARSessionDelegate {
    var parent: ARMapView
    var needsUpdate: Bool = false
    
    init(parent: ARMapView) {
        self.parent = parent
        super.init()
    }
    
    @objc func handleTap(_ gesture: UIGestureRecognizer) {
        self.needsUpdate.toggle()
        let tappedLocation = gesture.location(in: parent.arView)
        
        guard let ray = parent.arView.ray(through: tappedLocation) else {
            return
        }
        
        let rayResults = parent.arView.scene.raycast(origin: ray.origin, direction: ray.direction)
        
        guard let rayResult = rayResults.first else {
            return
        }
        
        let splitTappedEntityName = rayResult.entity.name.split(separator: "-")
        guard splitTappedEntityName[0] == "Base", let tappedRow = Int(splitTappedEntityName[1]), let tappedColumn = Int(splitTappedEntityName[2]) else { return }
        
        if let anchor = rayResult.entity.anchor {
            parent.arView.scene.removeAnchor(anchor)
        }
        
        // Weirdly enough, the commented out line causes the AR Entities to freeze, while calling a variable directly found in the Coordinator
        // doesn't cause it to crash. Weird, huh?
        // Well I think I somewhat narrowed it down -- updating any @Published property causes
        // the AR View to freeze its entities on screen, and I don't know why. I'll file a FB
        // soon if this is a system-level bug, but if any ARKit / SwiftUI engineers are looking
        // at this, that seems like something to check out!
        
        //parent.viewModel.districts[parent.viewModel.currentDistrictFocused, default: Set<GridModel>()].insert(parent.viewModel.gridAreas[tappedRow][tappedColumn])
        //parent.viewModel.handleGridTap(row: tappedRow, column: tappedColumn)
        handleGridTap(row: tappedRow, column: tappedColumn)
        gridAreas[tappedRow][tappedColumn].updateView(view: parent.arView, originPosition: parent.originPosition)
        
        parent.viewModel.updateFromAR(self)
        
        //handle the changes in the updateView method
        
        if let barView = parent.barView {
            barView.updateView(newModel: self, view: parent.arView, originPosition: parent.originPosition)
        }
    }
    
    func updateFromHub(_ coordinator: HubViewModel) {
        self.gridAreas = coordinator.gridAreas
        
        self.currentMap = coordinator.currentMap
        self.districts = coordinator.districts
        
        self.currentDistrictFocused = coordinator.currentDistrictFocused
        
        self.solutionData = coordinator.solutionData
        self.showSolution = coordinator.showSolution
        
        self.arError = coordinator.arError
        
        self.goalsAchieved = coordinator.goalsAchieved
        
        self.pauseBeforeGoal = coordinator.pauseBeforeGoal
        self.pausedGoal = coordinator.pausedGoal
    }
}

