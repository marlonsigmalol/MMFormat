//
//  MMSkeleton.swift
//  MMFormat
//
//  Created by Marlon Mawby on 19/8/2025.
//


import SwiftUI

public struct MMSkeleton: View {
    var cornerRadius: CGFloat = 8
    var height: CGFloat = 20
    var width: CGFloat? = nil
    var shimmerDuration: Double = 1.2
    
    @State private var gradientStart = UnitPoint(x: -1.5, y: 0)
    @State private var gradientEnd = UnitPoint(x: 0, y: 0)
    
    public var body: some View {
        RoundedRectangle(cornerRadius: height / 2)
            .fill(Color.gray.opacity(0.3))
            .frame(width: width, height: height)
            .overlay(
                RoundedRectangle(cornerRadius: height / 2, style: .continuous)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.white.opacity(0.2), Color.gray.opacity(0.3)]),
                            startPoint: gradientStart,
                            endPoint: gradientEnd
                        )
                    )
            )
            .onAppear {
                withAnimation(
                    Animation.linear(duration: shimmerDuration)
                        .repeatForever(autoreverses: false)
                ) {
                    gradientStart = UnitPoint(x: 1.5, y: 0)
                    gradientEnd = UnitPoint(x: 3, y: 0)
                }
            }
    }
}
