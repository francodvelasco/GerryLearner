//
//  File.swift
//  WWDC2022
//
//  Created by Franco Velasco on 4/6/22.
//

import Foundation
import SwiftUI

struct RotationModifier: ViewModifier {
    let handler: (UIDeviceOrientation) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                handler(UIDevice.current.orientation)
            }
    }
}

extension View {
    func onRotate(handler: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(RotationModifier(handler: handler))
    }
}
