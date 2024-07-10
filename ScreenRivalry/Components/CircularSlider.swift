//
//  CircularSlider.swift
//  ScreenRivalry
//
//  Created by Brian Wu on 7/9/24.
//

import SwiftUI

struct CircularSlider: View {
    @Binding var value: Double
    let maxValue: Double
    let lineWidth: CGFloat
    let color: Color

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: lineWidth)

                Circle()
                    .trim(from: 0.0, to: CGFloat(value / maxValue))
                    .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: value)

                Circle()
                    .frame(width: lineWidth, height: lineWidth)
                    .foregroundColor(color)
                    .offset(x: getOffsetX(for: geometry.size.width / 2), y: getOffsetY(for: geometry.size.width / 2))
                    .gesture(
                        DragGesture(minimumDistance: 0.0)
                            .onChanged { drag in
                                updateValue(with: drag.location, in: geometry.size)
                            }
                    )
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func getOffsetX(for radius: CGFloat) -> CGFloat {
        let angle = Angle(degrees: (value / maxValue) * 360.0)
        return radius * cos(CGFloat(angle.radians))
    }

    private func getOffsetY(for radius: CGFloat) -> CGFloat {
        let angle = Angle(degrees: (value / maxValue) * 360.0)
        return radius * sin(CGFloat(angle.radians))
    }

    private func updateValue(with location: CGPoint, in size: CGSize) {
        let radius = size.width / 2
        let dx = location.x - radius
        let dy = location.y - radius
        let angle = atan2(dy, dx) + .pi / 2
        let normalizedAngle = angle < 0 ? angle + 2 * .pi : angle
        let newValue = maxValue * Double(normalizedAngle / (2 * .pi))

        // Ensure the value does not exceed the max value
        if newValue <= maxValue {
            value = newValue
        }
    }
}
#Preview {
    CircularSlider(value: .constant(30), maxValue: 60, lineWidth: 20, color: .blue)
        .frame(width: 300, height: 300)
        .padding()
}
