//
//  DeepVectorApp.swift
//  DeepVector
//
//  Created by Ken Baer on 4/23/24.
//

import SwiftUI

@main
struct DeepVectorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
            .windowStyle(.volumetric)
            .defaultSize(width: 3, height: 3, depth: 6, in: .meters)
    }
}
