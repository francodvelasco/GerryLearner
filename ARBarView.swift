//
//  File.swift
//  WWDC2022
//
//  Created by Franco Velasco on 4/17/22.
//

import Foundation
import RealityKit
import SwiftUI

class ARBarView {
    var model: MapViewModel
    
    var winLabel: MeshResource
    
    var blueGraph: MeshResource
    var redGraph: MeshResource
    
    init?(model: MapViewModel) {
        guard let modelWinners = model.districts.districtCounts else {
            return nil
        }
        
        self.model = model
        
        self.winLabel = MeshResource.generateText(
            "Win",
            extrusionDepth: 0.1,
            font: .systemFont(ofSize: 0.75),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byTruncatingTail)
        
        let heights: (blue: Float, red: Float) = (Float(modelWinners.blue) / 5.0 * 0.1, Float(modelWinners.red) / 5.0 * 0.1)
        
        self.blueGraph = MeshResource.generateBox(width: 0.05, height: heights.blue, depth: 0.05)
        self.redGraph = MeshResource.generateBox(width: 0.05, height: heights.red, depth: 0.05)
    }
    
    func addToView(view: ARView, originPosition: SIMD3<Float>) {
        let redHeight = redGraph.bounds.extents.y
        let redPosition: SIMD3<Float> = [
            originPosition.x - 0.1,
            redHeight / 2,
            originPosition.z - 0.3
        ]
        let redBarMaterial: SimpleMaterial = SimpleMaterial(color: UIColor(Color("RedParty")), isMetallic: false)
        
        let redEntity: ModelEntity = ModelEntity(mesh: redGraph, materials: [redBarMaterial])
        redEntity.position = redPosition
        
        let redAnchor: AnchorEntity = AnchorEntity(world: originPosition)
        redAnchor.name = "RedBar"
        
        redAnchor.addChild(redEntity)
        view.scene.addAnchor(redAnchor)
        
        let blueHeight = blueGraph.bounds.extents.y
        let bluePosition: SIMD3<Float> = [
            originPosition.x + 0.1,
            blueHeight / 2,
            originPosition.z - 0.3
        ]
        let blueBarMaterial: SimpleMaterial = SimpleMaterial(color: UIColor(Color("BlueParty")), isMetallic: false)
        
        let blueEntity: ModelEntity = ModelEntity(mesh: blueGraph, materials: [blueBarMaterial])
        blueEntity.position = bluePosition
        
        let blueAnchor: AnchorEntity = AnchorEntity(world: originPosition)
        blueAnchor.name = "BlueBar"
        
        blueAnchor.addChild(blueEntity)
        view.scene.addAnchor(blueAnchor)
        
        addWinLabel(view: view, originPosition: originPosition)
    }
    
    func addWinLabel(view: ARView, originPosition: SIMD3<Float>) {
        guard let winner = model.districts.determinedCouncilWinner() else {
            print("No Winner - Self Model")
            return
        }
        
        let winnerPosition: SIMD3<Float> = [
            originPosition.x + 0.1 * (winner.name == "Red" ? 1.0 : -1.0),
            0,
            originPosition.z - 0.23
        ]
        let winnerMaterial: SimpleMaterial = SimpleMaterial(color: .white, isMetallic: true)
        let winnerEntity: ModelEntity = ModelEntity(mesh: winLabel, materials: [winnerMaterial])
        winnerEntity.position = winnerPosition
        winnerEntity.scale = SIMD3<Float>(0.03, 0.03, 0.1)
        
        let winnerAnchor: AnchorEntity = AnchorEntity(world: originPosition)
        winnerAnchor.name = "WinnerLabel"
        
        winnerAnchor.addChild(winnerEntity)
        view.scene.addAnchor(winnerAnchor)
        print("Did Put Win Label")
    }
    
    func addWinLabel(newModel: MapViewModel, view: ARView, originPosition: SIMD3<Float>) {
        guard let winner = newModel.districts.determinedCouncilWinner() else {
            print("No Winner - Inherited Model")
            return
        }
        
        let winnerPosition: SIMD3<Float> = [
            originPosition.x + 0.1 * (winner.name == "Red" ? -1.0 : 1.0),
            0,
            originPosition.z - 0.23
        ]
        let winnerMaterial: SimpleMaterial = SimpleMaterial(color: .white, isMetallic: true)
        let winnerEntity: ModelEntity = ModelEntity(mesh: winLabel, materials: [winnerMaterial])
        winnerEntity.position = winnerPosition
        winnerEntity.scale = SIMD3<Float>(0.03, 0.03, 0.1)
        
        let winnerAnchor: AnchorEntity = AnchorEntity(world: originPosition)
        winnerAnchor.name = "WinnerLabel"
        
        winnerAnchor.addChild(winnerEntity)
        view.scene.addAnchor(winnerAnchor)
        print("Did Put Win Label")
    }
    
    func updateView(view: ARView, originPosition: SIMD3<Float>) {
        guard let modelWinners = model.districts.districtCounts else {
            return
        }
        
        if let redAnchor = view.scene.findEntity(named: "RedBar") as? AnchorEntity, let blueAnchor = view.scene.findEntity(named: "BlueBar") as? AnchorEntity {
            view.scene.removeAnchor(redAnchor)
            view.scene.removeAnchor(blueAnchor)
            
            let heights: (blue: Float, red: Float) = (Float(modelWinners.blue) / 5.0 * 0.1, Float(modelWinners.red) / 5.0 * 0.1)
            
            self.redGraph = MeshResource.generateBox(width: 0.05, height: heights.red, depth: 0.05)
            self.blueGraph = MeshResource.generateBox(width: 0.05, height: heights.blue, depth: 0.05)
            
            addToView(view: view, originPosition: originPosition)
        }
        
        if let winAnchor = view.scene.findEntity(named: "WinnerLabel") as? AnchorEntity {
            view.scene.removeAnchor(winAnchor)
            addWinLabel(view: view, originPosition: originPosition)
        }
    }
    
    func updateView(newModel: MapViewModel, view: ARView, originPosition: SIMD3<Float>) {
        guard let modelWinners = newModel.districts.districtCounts else {
            return
        }
        
        if let redAnchor = view.scene.findEntity(named: "RedBar") as? AnchorEntity, let blueAnchor = view.scene.findEntity(named: "BlueBar") as? AnchorEntity {
            view.scene.removeAnchor(redAnchor)
            view.scene.removeAnchor(blueAnchor)
            
            let heights: (blue: Float, red: Float) = (Float(modelWinners.blue) / 5.0 * 0.1, Float(modelWinners.red) / 5.0 * 0.1)
            
            self.redGraph = MeshResource.generateBox(width: 0.05, height: heights.red, depth: 0.05)
            self.blueGraph = MeshResource.generateBox(width: 0.05, height: heights.blue, depth: 0.05)
            
            addToView(view: view, originPosition: originPosition)
        }
        
        if let winAnchor = view.scene.findEntity(named: "WinnerLabel") as? AnchorEntity {
            view.scene.removeAnchor(winAnchor)
            addWinLabel(view: view, originPosition: originPosition)
            return
        }
        
        addWinLabel(newModel: newModel, view: view, originPosition: originPosition)
    }
}

fileprivate extension Dictionary where Value == Set<GridModel> {
    func determinedCouncilWinner() -> (name: String, color: Color)? {
        let tallies = districtCounts ?? (0, 0)
        
        if tallies.blue >= 3 {
            return ("Blue", Color("BlueParty"))
        } else if tallies.red >= 3 {
            return ("Red", Color("RedParty"))
        }
        
        return nil
    }
}
