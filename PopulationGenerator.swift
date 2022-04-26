//
//  PopulationGenerator.swift
//  WWDC2022
//
//  Created by Franco Velasco on 4/10/22.
//

import Foundation
import GameplayKit

/// This is to primarily generate population for the grids within maps themselves. It is designed to be skewed more towards smaller population grids (which allows for easier district creation).
class PopulationGenerator {
    let randomSource: GKRandomSource
    var normalGenerator: GKGaussianDistribution
    var mean: Float
    var deviation: Float
    
    init() {
        self.mean = 1
        self.deviation = 1.5
        
        self.randomSource = GKRandomSource()
        
        self.normalGenerator = GKGaussianDistribution(randomSource: randomSource, mean: mean, deviation: deviation)
    }
    
    func createNewGenerator() {
        self.normalGenerator = GKGaussianDistribution(randomSource: randomSource, mean: mean, deviation: deviation)
    }
    
    func generatePopulationForGrid(current: Int, total: Int) -> Int {
        var generated = normalGenerator.nextInt(upperBound: 3)
        
        if generated <= 0 { generated = 0 }
        
        guard generated <= 3, generated <= current else {
            return generatePopulationForGrid(current: current, total: total)
        }
        
        if generated >= 2 {
            self.mean -= Float.random(in: 0.1...0.4)
            self.deviation -= Float.random(in: 0.01...0.04)
            
            createNewGenerator()
        } else {
            self.mean += Float.random(in: 0.2...0.5)
            self.deviation -= Float.random(in: 0.001...0.009)
            
            createNewGenerator()
        }
        
        return generated
    }
}
