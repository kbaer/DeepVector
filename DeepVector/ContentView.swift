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
    var triangleShape: Triangle
}

struct IterationView: View {
    @Binding var deltaAngle: Double
    @Binding var animate: Bool
    @Binding var spacing: Double
    @State var rotationAnimationTrigger = false
    var triangleArray: [TriangleModel] = Array(repeating: TriangleModel(scale: 1.0, rotation: 0.0, color: .blue, triangleShape: Triangle()), count: 50)
    
    @ViewBuilder
    var body: some View {
//        let twoPi: Double = 2.0 * Double.pi
        ZStack {
//            let triangle = triangleArray[0]
//            let index = 0
           ForEach(Array(triangleArray.enumerated()), id: \.offset) { index, triangle in
//                let deltaFactor = sin(Double(index)/15.0 * twoPi)
                let rotateDelta = animate ? deltaAngle : -deltaAngle
                triangle.triangleShape
                    .stroke(.green, style: StrokeStyle(lineWidth: 8
                                                     , lineCap: .round, lineJoin: .round))
                    .frame(width: 800, height: 800, alignment: .bottom)
                    .offset(z: CGFloat(Double(index) * spacing))
                    .rotationEffect(Angle(degrees: animate ? (CGFloat(Double(index) * ( rotationAnimationTrigger ? rotateDelta : -rotateDelta))) :  Double(index) * rotateDelta))
                    .scaleEffect(CGSize(width: 0.6, height: 0.6))
                    .id(animate)
                    .animation(.easeInOut(duration: 1.0).delay(Double(index)*0.1).repeatForever(autoreverses: true), value: rotationAnimationTrigger)
            }
        }
        .onChange(of: animate){ oldValue, shouldChange in
            let animation = Animation.linear(duration: 1.0)
            if shouldChange {
                withAnimation(animation) {
                    rotationAnimationTrigger = true
                }
            } else {
                rotationAnimationTrigger = false
            }
        }
        .onAppear() {
        }
    }
}

struct ContentView: View {
    
    @State var deltaAngle : Double = 3.0
    @State var animate: Bool = false
    @State var spacing: Double = 20

    var body: some View {
        HStack {
            let iterationView = IterationView(deltaAngle: $deltaAngle, animate: $animate, spacing: $spacing)
            iterationView
            VStack (spacing: 12) {
                Text(
                    String(format: "Delta Degrees: %.1f", deltaAngle)
                )
                Slider(value: $deltaAngle,
                       in: 0...10,
                       onEditingChanged: { (_) in
                            iterationView.deltaAngle = deltaAngle
                       },
                       minimumValueLabel: Text("0"),
                       maximumValueLabel: Text("10"),
                       label: {
                           Text("Title")
                       })
                Text(
                    String(format: "Spacing: %.1f", spacing)
                )
                Slider(value: $spacing,
                       in: 0...50,
                       onEditingChanged: { (_) in
                    iterationView.spacing = spacing
                },
                       minimumValueLabel: Text("0"),
                       maximumValueLabel: Text("50"),
                       label: {
                    Text("Title")
                })
                Spacer()
                Button("\(iterationView.animate ? "Stop" : "Start") Animation") { // add this button
                    animate.toggle()
                }
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
