//
//  LockAnimationView.swift
//  WiseMoney
//
//  Created by Prathmesh Parteki on 19/02/26.
//

import SwiftUI

// MARK: - 3D Padlock Body Shape

struct PadlockBodyShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        var path = Path()
        
        // Rounded rectangle with slight bulge for 3D effect
        let cornerRadius = w * 0.15
        
        // Top left corner
        path.move(to: CGPoint(x: cornerRadius, y: 0))
        
        // Top edge with slight curve outward
        path.addQuadCurve(
            to: CGPoint(x: w - cornerRadius, y: 0),
            control: CGPoint(x: w * 0.5, y: -h * 0.02)
        )
        
        // Top right corner
        path.addQuadCurve(
            to: CGPoint(x: w, y: cornerRadius),
            control: CGPoint(x: w, y: 0)
        )
        
        // Right edge with bulge
        path.addCurve(
            to: CGPoint(x: w, y: h - cornerRadius),
            control1: CGPoint(x: w * 1.03, y: h * 0.35),
            control2: CGPoint(x: w * 1.03, y: h * 0.65)
        )
        
        // Bottom right corner
        path.addQuadCurve(
            to: CGPoint(x: w - cornerRadius, y: h),
            control: CGPoint(x: w, y: h)
        )
        
        // Bottom edge
        path.addQuadCurve(
            to: CGPoint(x: cornerRadius, y: h),
            control: CGPoint(x: w * 0.5, y: h * 1.02)
        )
        
        // Bottom left corner
        path.addQuadCurve(
            to: CGPoint(x: 0, y: h - cornerRadius),
            control: CGPoint(x: 0, y: h)
        )
        
        // Left edge with bulge
        path.addCurve(
            to: CGPoint(x: 0, y: cornerRadius),
            control1: CGPoint(x: -w * 0.03, y: h * 0.65),
            control2: CGPoint(x: -w * 0.03, y: h * 0.35)
        )
        
        // Top left corner
        path.addQuadCurve(
            to: CGPoint(x: cornerRadius, y: 0),
            control: CGPoint(x: 0, y: 0)
        )
        
        path.closeSubpath()
        return path
    }
}

// MARK: - 3D Shackle Shape

struct ShackleShape3D: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        var path = Path()
        
        let thickness = w * 0.22
        
        // Outer arc
        path.move(to: CGPoint(x: 0, y: h))
        path.addLine(to: CGPoint(x: 0, y: h * 0.4))
        path.addCurve(
            to: CGPoint(x: w, y: h * 0.4),
            control1: CGPoint(x: 0, y: -h * 0.15),
            control2: CGPoint(x: w, y: -h * 0.15)
        )
        path.addLine(to: CGPoint(x: w, y: h))
        
        // Inner arc (creates thickness)
        path.addLine(to: CGPoint(x: w - thickness, y: h))
        path.addLine(to: CGPoint(x: w - thickness, y: h * 0.45))
        path.addCurve(
            to: CGPoint(x: thickness, y: h * 0.45),
            control1: CGPoint(x: w - thickness, y: h * 0.05),
            control2: CGPoint(x: thickness, y: h * 0.05)
        )
        path.addLine(to: CGPoint(x: thickness, y: h))
        path.closeSubpath()
        
        return path
    }
}

// MARK: - 3D Padlock View

struct Padlock3DView: View {
    var shackleOpen: CGFloat // 0 = closed, 1 = open
    
    // Gold/Brass colors
    private let goldHighlight = Color(red: 1.0, green: 0.92, blue: 0.65)
    private let goldBase = Color(red: 0.92, green: 0.78, blue: 0.45)
    private let goldMid = Color(red: 0.82, green: 0.65, blue: 0.32)
    private let goldDark = Color(red: 0.65, green: 0.48, blue: 0.20)
    private let goldShadow = Color(red: 0.45, green: 0.32, blue: 0.12)
    
    var body: some View {
        ZStack {
            // ═══ SHADOW ═══
            Ellipse()
                .fill(Color.black.opacity(0.4))
                .frame(width: 100, height: 25)
                .offset(y: 85)
                .blur(radius: 10)
            
            // ═══ SHACKLE ═══
            ZStack {
                // Shackle shadow
                ShackleShape3D()
                    .fill(Color.black.opacity(0.5))
                    .frame(width: 70, height: 55)
                    .offset(x: 3, y: 3)
                    .blur(radius: 5)
                
                // Shackle back (dark)
                ShackleShape3D()
                    .fill(
                        LinearGradient(
                            colors: [goldDark, goldShadow],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 70, height: 55)
                
                // Shackle main gradient
                ShackleShape3D()
                    .fill(
                        LinearGradient(
                            colors: [goldHighlight, goldBase, goldMid, goldDark],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 66, height: 52)
                
                // Shackle highlight (left side)
                ShackleShape3D()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.5),
                                Color.white.opacity(0.15),
                                Color.clear,
                                Color.clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 66, height: 52)
                
                // Shackle top shine
                ShackleShape3D()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.4),
                                Color.clear
                            ],
                            startPoint: .top,
                            endPoint: .center
                        )
                    )
                    .frame(width: 66, height: 52)
            }
            .offset(y: -50 + (shackleOpen * -25))
            
            // ═══ LOCK BODY ═══
            ZStack {
                // Body shadow
                PadlockBodyShape()
                    .fill(Color.black.opacity(0.5))
                    .frame(width: 110, height: 95)
                    .offset(x: 4, y: 5)
                    .blur(radius: 8)
                
                // Body back layer (depth)
                PadlockBodyShape()
                    .fill(goldShadow)
                    .frame(width: 112, height: 97)
                    .offset(x: 2, y: 2)
                
                // Body main gradient
                PadlockBodyShape()
                    .fill(
                        LinearGradient(
                            colors: [goldHighlight, goldBase, goldMid, goldDark],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 110, height: 95)
                
                // Body highlight overlay (top-left shine)
                PadlockBodyShape()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.55),
                                Color.white.opacity(0.2),
                                Color.clear,
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 110, height: 95)
                
                // Body left edge highlight
                PadlockBodyShape()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.3),
                                Color.clear,
                                Color.clear
                            ],
                            startPoint: .leading,
                            endPoint: .center
                        )
                    )
                    .frame(width: 110, height: 95)
                
                // Body bottom shadow
                PadlockBodyShape()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.clear,
                                Color.clear,
                                Color.black.opacity(0.15)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 110, height: 95)
                
                // Inner face plate
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        LinearGradient(
                            colors: [goldMid.opacity(0.8), goldDark, goldShadow],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 75, height: 60)
                    .shadow(color: Color.black.opacity(0.4), radius: 5, x: 2, y: 3)
                
                // Inner plate highlight
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.25),
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .center
                        )
                    )
                    .frame(width: 75, height: 60)
                
                // Keyhole assembly
                ZStack {
                    // Keyhole plate (raised ring)
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [goldBase, goldMid, goldDark],
                                center: .init(x: 0.3, y: 0.3),
                                startRadius: 0,
                                endRadius: 20
                            )
                        )
                        .frame(width: 38, height: 38)
                        .shadow(color: Color.black.opacity(0.4), radius: 3, x: 1, y: 2)
                    
                    // Keyhole plate highlight
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.5), Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                        .frame(width: 36, height: 36)
                    
                    // Keyhole opening
                    VStack(spacing: -3) {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color.black,
                                        goldShadow.opacity(0.8)
                                    ],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 10
                                )
                            )
                            .frame(width: 16, height: 16)
                            .overlay(
                                Circle()
                                    .fill(Color.white.opacity(0.15))
                                    .frame(width: 5, height: 5)
                                    .offset(x: -3, y: -3)
                            )
                        
                        UnevenRoundedRectangle(
                            cornerRadii: .init(
                                topLeading: 1,
                                bottomLeading: 5,
                                bottomTrailing: 5,
                                topTrailing: 1
                            )
                        )
                        .fill(Color.black.opacity(0.9))
                        .frame(width: 8, height: 16)
                    }
                }
                .offset(y: 2)
                
                // Body edge outline
                PadlockBodyShape()
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.3),
                                goldDark.opacity(0.5),
                                Color.black.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
                    .frame(width: 110, height: 95)
            }
            .offset(y: 20)
        }
    }
}

// MARK: - Main Lock Animation View

struct LockAnimationView: View {
    @State private var tiltX: Double = 12
    @State private var tiltZ: Double = -5
    @State private var shackleOpen: CGFloat = 1.0
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var bobOffset: CGFloat = 0
    @State private var glowOpacity: Double = 0
    @State private var isAnimating = false
    
    private let wiseGreen = Color(red: 159/255, green: 232/255, blue: 112/255)
    
    var body: some View {
        ZStack {
            // Glow ring
            Circle()
                .stroke(wiseGreen.opacity(glowOpacity * 0.5), lineWidth: 3)
                .frame(width: 286, height: 286)
                .scaleEffect(glowOpacity > 0 ? 1.0 : 0.8)
            
            // Background glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            wiseGreen.opacity(glowOpacity * 0.3),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 26,
                        endRadius: 156
                    )
                )
                .frame(width: 325, height: 325)
            
            // 3D Padlock
            Padlock3DView(shackleOpen: shackleOpen)
                .scaleEffect(1.3)
                .rotation3DEffect(.degrees(tiltX), axis: (x: 1, y: 0, z: 0), perspective: 0.5)
                .rotation3DEffect(.degrees(tiltZ), axis: (x: 0, y: 0, z: 1), perspective: 0.5)
                .scaleEffect(scale)
                .opacity(opacity)
                .offset(y: bobOffset)
        }
        .onAppear {
            startAnimation()
        }
        .onDisappear {
            isAnimating = false
        }
    }
    
    private func startAnimation() {
        guard !isAnimating else { return }
        isAnimating = true
        runLoop()
    }
    
    private func runLoop() {
        guard isAnimating else { return }
        
        // Reset
        tiltX = 12
        tiltZ = -5
        shackleOpen = 1.0
        scale = 0.5
        opacity = 0
        bobOffset = 0
        glowOpacity = 0
        
        // PHASE 1: Appear with spring (0.4s)
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            scale = 1.0
            opacity = 1.0
        }
        
        // Gentle floating bob
        withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
            bobOffset = -6
        }
        
        // PHASE 2: Gentle wobble/tilt animation (1.0s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            guard isAnimating else { return }
            
            // Tilt left
            withAnimation(.easeInOut(duration: 0.35)) {
                tiltZ = 8
                tiltX = 8
            }
            
            // Tilt right
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                withAnimation(.easeInOut(duration: 0.35)) {
                    tiltZ = -10
                    tiltX = 15
                }
            }
            
            // Settle back
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    tiltZ = 0
                    tiltX = 10
                }
            }
        }
        
        // PHASE 3: Lock shackle (0.3s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            guard isAnimating else { return }
            
            withAnimation(.spring(response: 0.18, dampingFraction: 0.45)) {
                shackleOpen = 0
            }
            
            // Impact shake
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.06, dampingFraction: 0.25)) {
                    scale = 1.08
                    tiltZ = 5
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.16) {
                withAnimation(.spring(response: 0.06, dampingFraction: 0.25)) {
                    tiltZ = -3
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                withAnimation(.spring(response: 0.1, dampingFraction: 0.5)) {
                    scale = 1.0
                    tiltZ = 0
                }
                
                withAnimation(.easeOut(duration: 0.2)) {
                    glowOpacity = 1.0
                }
            }
        }
        
        // PHASE 4: Hold & Fade (0.8s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            guard isAnimating else { return }
            
            withAnimation(.easeOut(duration: 0.3)) {
                opacity = 0
                scale = 0.9
                glowOpacity = 0
            }
        }
        
        // Loop
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
            guard isAnimating else { return }
            runLoop()
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        LockAnimationView()
    }
}
