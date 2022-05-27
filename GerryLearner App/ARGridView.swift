//
//  File.swift
//  WWDC2022
//
//  Created by Franco Velasco on 4/7/22.
//

import Foundation
import RealityKit
import SwiftUI

class ARGridView {
    var grid: GridModel
    
    var gridBase: MeshResource
    var persons: [MeshResource]
    
    init(grid: GridModel) {
        self.grid = grid
        self.gridBase = MeshResource.generateBox(width: 0.05, height: 0.02, depth: 0.05)
        self.persons = (0..<grid.population).map { _ in
            let height = Float.random(in: 0.03...0.045)
            
            return MeshResource.generateBox(width: 0.01, height: height, depth: 0.01, cornerRadius: 0.001, splitFaces: false)
        }
    }
    
    func changeBaseHeight() {
        self.gridBase = MeshResource.generateBox(width: 0.075, height: self.grid.district?.arViewHeight ?? 0.0, depth: 0.075)
    }
    
    func changeBaseHeight(_ newHeight: Float) {
        self.gridBase = MeshResource.generateBox(width: 0.075, height: newHeight, depth: 0.075)
    }
    
    func addToView(view: ARView, originPosition: SIMD3<Float>) {
        let basePosition: SIMD3<Float> = [
            originPosition.x + 0.06 * Float(grid.column - 2),
            0,
            originPosition.z + 0.06 * Float(grid.row - 2)
        ]
        
        let baseEntity = ModelEntity(mesh: gridBase, materials: [SimpleMaterial(color: grid.district?.arColor ?? .white, isMetallic: false)])
        baseEntity.name = "Base-\(grid.row)-\(grid.column)"
        baseEntity.position = basePosition
        baseEntity.generateCollisionShapes(recursive: true)
        
        let baseAnchor = AnchorEntity(world: originPosition)
        baseAnchor.name = "Base-\(grid.row)-\(grid.column)"
        
        baseAnchor.addChild(baseEntity)
        // view.scene.addAnchor(baseAnchor)
        
        for (count, person) in persons.enumerated() {
            let personHeight = person.bounds.extents.y
            let personEntity = ModelEntity(mesh: person, materials: [SimpleMaterial(color: UIColor(grid.color ?? .clear), isMetallic: false)])
            
            let personPosition: SIMD3<Float> = [
                basePosition.x + 0.01 * Float(count % 2 == 1 ? -1.0 : 1.0),
                basePosition.y + (grid.district?.arViewHeight ?? 0.0) + personHeight / 2,
                basePosition.z + 0.01 * Float(count <= 1 ? -1.0 : 1.0)
            ]
            personEntity.position = personPosition
            
            //let personAnchor = AnchorEntity(world: originPosition)
            //personAnchor.name = "Person\(count)-\(grid.row)-\(grid.column)"
            
            //personAnchor.addChild(personEntity)
            //view.scene.addAnchor(personAnchor)
            
            baseAnchor.addChild(personEntity)
        }
        
        view.scene.addAnchor(baseAnchor)
    }
    
    func updateView(view: ARView, originPosition: SIMD3<Float>) {
        if let baseAnchor = view.scene.findEntity(named: "Base-\(grid.row)-\(grid.column)") as? AnchorEntity {
            view.scene.removeAnchor(baseAnchor)
        }
        
        changeBaseHeight()
        addToView(view: view, originPosition: originPosition)
    }
}

extension District {
    var arColor: UIColor {
        return UIColor(self.color)
    }
}

extension GridModel {
    func addToView(view: ARView, originPosition: SIMD3<Float>) {
        let baseMesh = MeshResource.generateBox(width: 0.05, height: 0.02 + (self.district?.arViewHeight ?? 0.0), depth: 0.05)
        let basePosition: SIMD3<Float> = [
            originPosition.x + 0.06 * Float(self.column - 2),
            ((self.district?.arViewHeight ?? 0.0)),
            originPosition.z + 0.06 * Float(self.row - 2)
        ]
        
        let baseEntity = ModelEntity(mesh: baseMesh, materials: [SimpleMaterial(color: self.district?.arColor ?? .white, isMetallic: false)])
        baseEntity.name = "Base-\(self.row)-\(self.column)"
        baseEntity.position = basePosition
        baseEntity.generateCollisionShapes(recursive: true)
        
        let baseAnchor = AnchorEntity(world: originPosition)
        baseAnchor.name = "Base-\(self.row)-\(self.column)"
        
        baseAnchor.addChild(baseEntity)
        
        baseAnchor.generateCollisionShapes(recursive: true)
        // view.scene.addAnchor(baseAnchor)
        
        for count in 0..<population {
            let personHeight = Float.random(in: 0.02...0.035)
            let personMesh = MeshResource.generateBox(width: 0.01, height: personHeight, depth: 0.01, cornerRadius: 0.001, splitFaces: false)
            
            let personEntity = ModelEntity(mesh: personMesh, materials: [SimpleMaterial(color: UIColor(self.color ?? .clear), isMetallic: false)])
            
            let personPosition: SIMD3<Float> = [
                basePosition.x + 0.01 * Float(count % 2 == 1 ? -1.0 : 1.0),
                basePosition.y + (self.district?.arViewHeight ?? 0.0) + personHeight / 2,
                basePosition.z + 0.01 * Float(count <= 1 ? -1.0 : 1.0)
            ]
            personEntity.position = personPosition
            
            //let personAnchor = AnchorEntity(world: originPosition)
            //personAnchor.name = "Person\(count)-\(grid.row)-\(grid.column)"
            
            //personAnchor.addChild(personEntity)
            //view.scene.addAnchor(personAnchor)
            
            baseAnchor.addChild(personEntity)
        }
        
        view.scene.addAnchor(baseAnchor)
    }
    
    func updateView(view: ARView, originPosition: SIMD3<Float>) {
        if let baseAnchor = view.scene.findEntity(named: "Base-\(self.row)-\(self.column)") as? AnchorEntity {
            for entity in baseAnchor.children {
                baseAnchor.removeChild(entity)
            }
            view.scene.removeAnchor(baseAnchor)
        }
        addToView(view: view, originPosition: originPosition)
    }
}
