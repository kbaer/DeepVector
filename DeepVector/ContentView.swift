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
    
    func animateShape(index: Int, isAnimated: Bool, deltaAngle: Double) -> some View {
        let twoPi: Double = 2.0 * Double.pi
        let deltaFactor = sin(Double(index)/15.0 * twoPi)
        let rotateDelta = isAnimated ? deltaAngle : -deltaAngle * 2
        let scaleDelta = isAnimated ? (0.1 * deltaFactor) : 0.0
        return self
            .stroke(.green, style: StrokeStyle(lineWidth: 8
                                             , lineCap: .round, lineJoin: .round))
            .frame(width: 800, height: 800, alignment: .bottom)
            .offset(z: CGFloat(index * 20))
            .rotationEffect(Angle(degrees: CGFloat(Double(index) * rotateDelta)))
            .scaleEffect(CGSize(width: 0.6 + scaleDelta, height: 0.6 + scaleDelta))
            .animation(.linear(duration: 1.0).delay(Double(index)*0.1).repeatCount(4, autoreverses: true), value: isAnimated)
    }
}

struct TriangleModel: Identifiable {
    var id = UUID()
    var scale: Double
    var rotation: Double
    var color: UIColor
}

struct IterationView: View {
    @Binding var deltaAngle: Double
    @Binding var isAnimated: Bool
    @Binding var throbAmount: Double
    var triangleArray: [TriangleModel] = Array(repeating: TriangleModel(scale: 1.0, rotation: 0.0, color: .blue), count: 40)
    
    @ViewBuilder
    var body: some View {
        
        ZStack {
            ForEach(Array(triangleArray.enumerated()), id: \.offset) { index, triangle in
                Triangle()
                    .animateShape(index: index, isAnimated: isAnimated, deltaAngle: deltaAngle)
            }
        }
    }
}

struct ContentView: View {
    
    @State var deltaAngle : Double = 3.0
    @State var isAnimated: Bool = false
    @State var throbAmount: Double = 0.0

    var body: some View {
        HStack {
            var iterationView = IterationView(deltaAngle: $deltaAngle, isAnimated: $isAnimated, throbAmount: $throbAmount)
            iterationView
            VStack (spacing: 12) {
                Text("Delta Degrees:")
                Text(
                    String(format: "%.1f", deltaAngle)
                )
                Slider(value: $deltaAngle,
                       in: 0...15,
                       onEditingChanged: { (_) in
                    iterationView.deltaAngle = deltaAngle
                },
                       minimumValueLabel: Text("0"),
                       maximumValueLabel: Text("15"),
                       label: {
                    Text("Title")
                })
                .accentColor(.red)
                Spacer()
                Toggle("Animate", isOn: $isAnimated//.animation(.easeInOut.repeatForever(autoreverses: true))
                )
             }
            .frame(width: 400, height: 300)
            .padding(36)
            .glassBackgroundEffect(displayMode: .implicit)
        }
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}
