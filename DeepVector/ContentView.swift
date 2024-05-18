//
//  ContentView.swift
//  DeepVector
//
//  Created by Ken Baer on 4/23/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}

struct TriangleModel: Identifiable {
    var id = UUID()
    var scale: Double
    var rotation: Double
    var color: UIColor
}

struct IterationView: View {
    
    var triangleArray: [TriangleModel] = Array(repeating: TriangleModel(scale: 1.0, rotation: 0.0, color: .red), count: 40)
    
    var body: some View {
        ZStack {
            ForEach(Array(triangleArray.enumerated()), id: \.offset) { index, triangle in
                
//                    PhaseAnimator([true, false]) { triangle, rotate3D in
                        Triangle()
                        .stroke(.red, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                        .frame(width: 1000, height: 1000, alignment: .center)
                        .offset(z: CGFloat( index * 20))
                            .scaleEffect(CGSize(width: 0.6, height: 0.6))
                            .rotation3DEffect(.degrees(/*rotate3D ? Double(index) * -3.0 : */Double(index) * 3.0), axis: (x: 0, y: 0, z: 1))
//                    } animation: { rotate3D in
//                            .easeInOut
//                    }
x            }
        }
    }
    
    
}

struct ContentView: View {

    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    

    var body: some View {
        VStack {
            VStack (spacing: 12) {
                Toggle("Show ImmersiveSpace", isOn: $showImmersiveSpace)
                    .font(.title)
                IterationView()
            }
            .frame(width: 360)
            .padding(36)
            .glassBackgroundEffect(displayMode: .always)

        }
        .onChange(of: showImmersiveSpace) { _, newValue in
            Task {
                if newValue {
                    switch await openImmersiveSpace(id: "ImmersiveSpace") {
                    case .opened:
                        immersiveSpaceIsShown = true
                    case .error, .userCancelled:
                        fallthrough
                    @unknown default:
                        immersiveSpaceIsShown = false
                        showImmersiveSpace = false
                    }
                } else if immersiveSpaceIsShown {
                    await dismissImmersiveSpace()
                    immersiveSpaceIsShown = false
                }
            }
        }
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
    ImmersiveView()
}
