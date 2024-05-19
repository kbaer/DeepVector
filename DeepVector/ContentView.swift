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
    var deltaAngle: Double = 3
    
    var body: some View {
        ZStack {
            ForEach(Array(triangleArray.enumerated()), id: \.offset) { index, triangle in
                Triangle()
                    .stroke(.red, style: StrokeStyle(lineWidth: 8
                                                     , lineCap: .round, lineJoin: .round))
                    .frame(width: 1500, height: 1500, alignment: .center)
                    .offset(z: CGFloat( index * 20))
                    .rotationEffect(Angle(degrees: CGFloat(Double(index) * deltaAngle)))
                    .scaleEffect(CGSize(width: 0.6, height: 0.6))
            }
        }
    }
    
    
}

struct ContentView: View {

    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    @State var deltaAngle : Double = 3.0
    @State var iterationView = IterationView()

    var body: some View {
        ZStack {
            iterationView
            VStack (spacing: 12) {
                Text("Delta Degrees:")
                Text(
                    String(format: "%.1f", deltaAngle)
                )
                Slider(value: $deltaAngle,
                       in: -30...30,
                       onEditingChanged: { (_) in
                            iterationView.deltaAngle = deltaAngle
                       },
                       minimumValueLabel: Text("-30"),
                       maximumValueLabel: Text("30"),
                       label: {
                            Text("Title")
                       }
                )
                .accentColor(.red)
            }
                    }
        .frame(width: 800, height: 400)
        .padding(36)
        .glassBackgroundEffect(displayMode: .implicit)

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
