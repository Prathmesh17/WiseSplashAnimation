//
//  BottlesAnimationView.swift
//  WiseMoney
//
//  Created by Prathmesh Parteki on 19/02/26.
//

import SwiftUI
internal import Combine

// MARK: - Jar/Bottle Shape

/// A jar shape with a wide mouth opening — drawn with bezier curves for a 3D ceramic feel
struct JarShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        var path = Path()

        // Start at top-left of the mouth rim
        // Mouth opening (wide top)
        path.move(to: CGPoint(x: w * 0.15, y: h * 0.08))
        // Left inner rim curve
        path.addQuadCurve(
            to: CGPoint(x: w * 0.10, y: h * 0.15),
            control: CGPoint(x: w * 0.08, y: h * 0.08)
        )

        // Neck narrows slightly
        path.addCurve(
            to: CGPoint(x: w * 0.08, y: h * 0.25),
            control1: CGPoint(x: w * 0.08, y: h * 0.18),
            control2: CGPoint(x: w * 0.06, y: h * 0.22)
        )

        // Body curves out (left side belly)
        path.addCurve(
            to: CGPoint(x: w * 0.05, y: h * 0.55),
            control1: CGPoint(x: w * 0.02, y: h * 0.32),
            control2: CGPoint(x: w * 0.0, y: h * 0.42)
        )

        // Bottom left curve
        path.addCurve(
            to: CGPoint(x: w * 0.15, y: h * 0.95),
            control1: CGPoint(x: w * 0.05, y: h * 0.75),
            control2: CGPoint(x: w * 0.08, y: h * 0.90)
        )

        // Flat bottom
        path.addCurve(
            to: CGPoint(x: w * 0.85, y: h * 0.95),
            control1: CGPoint(x: w * 0.30, y: h * 1.02),
            control2: CGPoint(x: w * 0.70, y: h * 1.02)
        )

        // Bottom right curve
        path.addCurve(
            to: CGPoint(x: w * 0.95, y: h * 0.55),
            control1: CGPoint(x: w * 0.92, y: h * 0.90),
            control2: CGPoint(x: w * 0.95, y: h * 0.75)
        )

        // Body curves in (right side belly)
        path.addCurve(
            to: CGPoint(x: w * 0.92, y: h * 0.25),
            control1: CGPoint(x: w * 1.0, y: h * 0.42),
            control2: CGPoint(x: w * 0.98, y: h * 0.32)
        )

        // Neck narrows (right side)
        path.addCurve(
            to: CGPoint(x: w * 0.90, y: h * 0.15),
            control1: CGPoint(x: w * 0.94, y: h * 0.22),
            control2: CGPoint(x: w * 0.92, y: h * 0.18)
        )

        // Right inner rim curve
        path.addQuadCurve(
            to: CGPoint(x: w * 0.85, y: h * 0.08),
            control: CGPoint(x: w * 0.92, y: h * 0.08)
        )

        // Top rim (mouth opening)
        path.addLine(to: CGPoint(x: w * 0.15, y: h * 0.08))
        path.closeSubpath()

        return path
    }
}

/// Elliptical rim at the top of the jar to give 3D depth
struct JarRimShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        var path = Path()

        // Outer rim ellipse
        path.addEllipse(in: CGRect(
            x: w * 0.12, y: 0,
            width: w * 0.76, height: h
        ))

        return path
    }
}

// MARK: - Individual Bottle View

struct BottleView: View {
    let baseColor: Color
    let highlightColor: Color
    let accentColor: Color
    let darkColor: Color
    let splashColor1: Color
    let splashColor2: Color
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack {
            // ── Shadow beneath the jar ──
            Ellipse()
                .fill(Color.black.opacity(0.3))
                .frame(width: width * 0.7, height: width * 0.12)
                .offset(y: height * 0.48)
                .blur(radius: 6)

            // ── Main jar body ──
            JarShape()
                .fill(
                    LinearGradient(
                        colors: [
                            highlightColor,
                            baseColor,
                            darkColor
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: width, height: height)
                .shadow(color: .black.opacity(0.35), radius: 8, x: 3, y: 6)

            // ── Paint splash overlay 1 (diagonal streak) ──
            JarShape()
                .fill(
                    LinearGradient(
                        colors: [
                            splashColor1.opacity(0.5),
                            splashColor1.opacity(0.2),
                            Color.clear,
                            splashColor2.opacity(0.3),
                        ],
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    )
                )
                .frame(width: width, height: height)

            // ── Paint splash overlay 2 (vertical drip) ──
            JarShape()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.clear,
                            splashColor2.opacity(0.35),
                            accentColor.opacity(0.25),
                            Color.clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: width, height: height)

            // ── 3D highlight (left edge) ──
            JarShape()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.35),
                            Color.white.opacity(0.08),
                            Color.clear,
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: width, height: height)

            // ── 3D highlight (top lighting) ──
            JarShape()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.3),
                            Color.white.opacity(0.05),
                            Color.clear,
                            Color.clear
                        ],
                        startPoint: .top,
                        endPoint: .center
                    )
                )
                .frame(width: width, height: height)

            // ── Rim (3D mouth opening) ──
            ZStack {
                // Rim outer edge
                Ellipse()
                    .fill(
                        LinearGradient(
                            colors: [
                                highlightColor.opacity(0.9),
                                baseColor,
                                darkColor
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: width * 0.76, height: height * 0.10)

                // Rim inner dark hole
                Ellipse()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.black.opacity(0.7),
                                darkColor.opacity(0.6),
                                darkColor.opacity(0.3)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: width * 0.25
                        )
                    )
                    .frame(width: width * 0.58, height: height * 0.06)

                // Rim highlight
                Ellipse()
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.5),
                                Color.clear,
                                Color.clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 1.5
                    )
                    .frame(width: width * 0.74, height: height * 0.09)
            }
            .offset(y: -height * 0.42)

            // ── Edge outline for definition ──
            JarShape()
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.15),
                            darkColor.opacity(0.3),
                            Color.black.opacity(0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
                .frame(width: width, height: height)
        }
    }
}

// MARK: - Realistic 3D Coin View

struct CoinView: View {
    let size: CGFloat
    var rotationX: Double = 0
    var rotationY: Double = 0
    var rotationZ: Double = 0
    
    var body: some View {
        ZStack {
            // Coin edge (visible when flipping)
            RoundedRectangle(cornerRadius: 2)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.85, green: 0.65, blue: 0.10),
                            Color(red: 0.6, green: 0.45, blue: 0.05)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: size, height: size * 0.12)
            
            // Coin face
            ZStack {
                // Base gold
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 1.0, green: 0.88, blue: 0.35),
                                Color(red: 0.95, green: 0.75, blue: 0.18),
                                Color(red: 0.78, green: 0.60, blue: 0.12)
                            ],
                            center: .init(x: 0.3, y: 0.3),
                            startRadius: 0,
                            endRadius: size * 0.55
                        )
                    )
                    .frame(width: size, height: size)

                // Outer ring
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color(red: 1.0, green: 0.95, blue: 0.6),
                                Color(red: 0.65, green: 0.48, blue: 0.06)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: size - 2, height: size - 2)

                // Inner detail ring
                Circle()
                    .stroke(Color(red: 0.75, green: 0.58, blue: 0.12).opacity(0.6), lineWidth: 1)
                    .frame(width: size * 0.65, height: size * 0.65)
                
                // Center emblem
                Circle()
                    .fill(Color(red: 0.88, green: 0.70, blue: 0.15).opacity(0.5))
                    .frame(width: size * 0.35, height: size * 0.35)

                // Specular highlight
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(0.6),
                                Color.white.opacity(0.0)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: size * 0.2
                        )
                    )
                    .frame(width: size * 0.4, height: size * 0.4)
                    .offset(x: -size * 0.18, y: -size * 0.18)
            }
        }
        .rotation3DEffect(.degrees(rotationX), axis: (x: 1, y: 0, z: 0), perspective: 0.5)
        .rotation3DEffect(.degrees(rotationY), axis: (x: 0, y: 1, z: 0), perspective: 0.5)
        .rotationEffect(.degrees(rotationZ))
        .shadow(color: .black.opacity(0.4), radius: 3, x: 2, y: 3)
    }
}

// MARK: - Physics-Based Coin Animator

class CoinPhysics: ObservableObject {
    @Published var x: CGFloat = 0
    @Published var y: CGFloat = 0
    @Published var rotationX: Double = 0
    @Published var rotationY: Double = 0
    @Published var rotationZ: Double = 0
    @Published var opacity: Double = 0
    @Published var scale: CGFloat = 0.3
    @Published var isActive: Bool = false
    
    private var time: CGFloat = 0
    private var duration: CGFloat = 0
    private var startX: CGFloat = 0
    private var startY: CGFloat = 0
    private var endX: CGFloat = 0
    private var endY: CGFloat = 0
    private var bottleTopY: CGFloat = 0  // Y position at bottle opening
    private var initialVelocityY: CGFloat = 0
    private var gravity: CGFloat = 0
    private var spinSpeedX: Double = 0
    private var spinSpeedY: Double = 0
    private var spinSpeedZ: Double = 0
    private var displayLink: CADisplayLink?
    private var onComplete: (() -> Void)?
    
    // Emergence phase duration (coin rising from inside bottle)
    private let emergeDuration: CGFloat = 0.15
    private let emergeDistance: CGFloat = 35  // How far inside bottle coin starts
    
    func toss(
        from start: CGPoint,
        to end: CGPoint,
        duration: CGFloat,
        peakHeight: CGFloat,
        flips: Double,
        onComplete: (() -> Void)? = nil
    ) {
        self.startX = start.x
        self.startY = start.y
        self.bottleTopY = start.y  // Store the bottle opening position
        self.endX = end.x
        self.endY = end.y
        self.duration = duration
        self.onComplete = onComplete
        self.time = 0
        
        // Calculate initial velocity for parabolic motion
        self.gravity = 8 * peakHeight / (duration * duration)
        self.initialVelocityY = gravity * duration / 2
        
        // Spin speeds
        self.spinSpeedX = flips * 360 / Double(duration)
        self.spinSpeedY = flips * 120 / Double(duration)
        self.spinSpeedZ = flips * 45 / Double(duration)
        
        // Start inside the bottle (below the opening)
        x = startX
        y = startY + emergeDistance
        rotationX = 0
        rotationY = 0
        rotationZ = 0
        opacity = 0
        scale = 0.5
        isActive = true
        
        // Start animation
        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    @objc private func update(displayLink: CADisplayLink) {
        let dt = CGFloat(displayLink.targetTimestamp - displayLink.timestamp)
        time += dt
        
        // Phase 1: Emergence from bottle
        if time < emergeDuration {
            let emergeT = time / emergeDuration
            let easeOut = 1 - pow(1 - emergeT, 2)  // Ease out curve
            
            // Rise from inside bottle to opening
            y = (startY + emergeDistance) - (emergeDistance * easeOut)
            x = startX
            
            // Fade in and scale up as coin emerges
            opacity = Double(easeOut)
            scale = 0.5 + 0.5 * easeOut
            
            // Start spinning slowly during emergence
            rotationX = Double(emergeT) * 90
            rotationZ = Double(emergeT) * 15
            return
        }
        
        // Phase 2: Main toss (parabolic flight)
        let flightTime = time - emergeDuration
        let t = min(flightTime / duration, 1.0)
        
        // Ensure full opacity and scale during flight
        opacity = 1.0
        scale = 1.0
        
        // Horizontal: linear interpolation
        x = startX + (endX - startX) * t
        
        // Vertical: parabolic motion
        let normalizedTime = t * duration
        let verticalDisplacement = initialVelocityY * normalizedTime - 0.5 * gravity * normalizedTime * normalizedTime
        let endYOffset = endY - startY
        y = startY - verticalDisplacement + endYOffset * t
        
        // Rotation with deceleration
        let spinDecay = 1.0 - pow(Double(t), 1.5) * 0.3
        let currentTime = Double(flightTime)
        
        // Continue rotation from emergence phase
        rotationX = 90 + spinSpeedX * currentTime * spinDecay
        rotationY = sin(currentTime * 8) * 25 * spinDecay
        rotationZ = 15 + spinSpeedZ * currentTime * spinDecay
        
        // Complete
        if t >= 1.0 {
            displayLink.invalidate()
            self.displayLink = nil
            
            // Quick fade out when entering destination bottle
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                withAnimation(.easeOut(duration: 0.1)) {
                    self.opacity = 0
                    self.scale = 0.6
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.isActive = false
                self.onComplete?()
            }
        }
    }
    
    func stop() {
        displayLink?.invalidate()
        displayLink = nil
        isActive = false
        opacity = 0
    }
}

// MARK: - Main Bottles Animation View

struct BottlesAnimationView: View {
    // Bobbing offsets for each bottle
    @State private var bob1: CGFloat = 0
    @State private var bob2: CGFloat = 0
    @State private var bob3: CGFloat = 0
    
    // Animation phase trackers for bobbing
    @State private var bobPhase1: Double = 0
    @State private var bobPhase2: Double = 0.3
    @State private var bobPhase3: Double = 0.6
    
    // Track if animation is running
    @State private var isAnimating = false
    
    // Timer for bobbing animation
    @State private var bobTimer: Timer?

    // Physics-based coin animators
    @StateObject private var coin1 = CoinPhysics()
    @StateObject private var coin2 = CoinPhysics()

    // Bottle positions (relative to center)
    private let bottle1Pos = CGPoint(x: -95, y: 55)   // left-front (red)
    private let bottle2Pos = CGPoint(x: 15, y: -30)   // center-back (yellow)
    private let bottle3Pos = CGPoint(x: 100, y: 40)   // right-front (green)

    var body: some View {
        ZStack {
            // ── Coins behind all bottles (zIndex -1) ──
            
            // Coin 1: bottle 3 → bottle 2
            if coin1.isActive {
                CoinView(
                    size: 28,
                    rotationX: coin1.rotationX,
                    rotationY: coin1.rotationY,
                    rotationZ: coin1.rotationZ
                )
                .scaleEffect(coin1.scale)
                .opacity(coin1.opacity)
                .offset(x: coin1.x, y: coin1.y)
                .zIndex(-1)
            }

            // Coin 2: bottle 2 → bottle 1
            if coin2.isActive {
                CoinView(
                    size: 26,
                    rotationX: coin2.rotationX,
                    rotationY: coin2.rotationY,
                    rotationZ: coin2.rotationZ
                )
                .scaleEffect(coin2.scale)
                .opacity(coin2.opacity)
                .offset(x: coin2.x, y: coin2.y)
                .zIndex(-1)
            }
            
            // ── Bottle 2 (center-back, yellow/orange) ──
            BottleView(
                baseColor: Color(red: 0.95, green: 0.75, blue: 0.15),
                highlightColor: Color(red: 1.0, green: 0.90, blue: 0.40),
                accentColor: Color(red: 1.0, green: 0.55, blue: 0.10),
                darkColor: Color(red: 0.72, green: 0.50, blue: 0.08),
                splashColor1: Color(red: 1.0, green: 0.45, blue: 0.0),
                splashColor2: Color(red: 0.85, green: 0.25, blue: 0.50),
                width: 90,
                height: 120
            )
            .offset(x: bottle2Pos.x, y: bottle2Pos.y + bob2)
            .zIndex(0)

            // ── Bottle 1 (left-front, red/coral) ──
            BottleView(
                baseColor: Color(red: 0.92, green: 0.25, blue: 0.18),
                highlightColor: Color(red: 1.0, green: 0.50, blue: 0.35),
                accentColor: Color(red: 1.0, green: 0.65, blue: 0.20),
                darkColor: Color(red: 0.60, green: 0.12, blue: 0.08),
                splashColor1: Color(red: 1.0, green: 0.75, blue: 0.20),
                splashColor2: Color(red: 0.95, green: 0.40, blue: 0.25),
                width: 105,
                height: 145
            )
            .offset(x: bottle1Pos.x, y: bottle1Pos.y + bob1)
            .zIndex(1)

            // ── Bottle 3 (right-front, green/blue) ──
            BottleView(
                baseColor: Color(red: 0.20, green: 0.75, blue: 0.40),
                highlightColor: Color(red: 0.45, green: 0.92, blue: 0.55),
                accentColor: Color(red: 0.15, green: 0.55, blue: 0.85),
                darkColor: Color(red: 0.10, green: 0.45, blue: 0.22),
                splashColor1: Color(red: 0.20, green: 0.50, blue: 0.90),
                splashColor2: Color(red: 0.80, green: 0.90, blue: 0.20),
                width: 95,
                height: 130
            )
            .offset(x: bottle3Pos.x, y: bottle3Pos.y + bob3)
            .zIndex(2)
        }
        .frame(width: 320, height: 300)
        .onAppear {
            startAllAnimations()
        }
        .onDisappear {
            stopAllAnimations()
        }
    }
    
    // MARK: - Start All Animations
    
    private func startAllAnimations() {
        // Reset phases for fresh start
        bobPhase1 = 0
        bobPhase2 = 0.3
        bobPhase3 = 0.6
        bob1 = 0
        bob2 = 0
        bob3 = 0
        
        // Start bobbing timer
        bobTimer?.invalidate()
        bobTimer = Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { _ in
            updateBobbing()
        }
        
        // Start coin animations
        if !isAnimating {
            isAnimating = true
            startCoinAnimation()
        }
    }
    
    private func stopAllAnimations() {
        bobTimer?.invalidate()
        bobTimer = nil
        isAnimating = false
        coin1.stop()
        coin2.stop()
    }

    // MARK: - Bobbing Animation (Timer-based)
    
    private func updateBobbing() {
        let dt = 1.0 / 60.0
        
        // Update phases (different speeds for organic feel)
        bobPhase1 += dt * 0.55  // ~1.8s period
        bobPhase2 += dt * 0.48  // ~2.1s period
        bobPhase3 += dt * 0.52  // ~1.9s period
        
        // Calculate bob offsets using sine wave
        bob1 = CGFloat(sin(bobPhase1 * .pi * 2)) * -5
        bob2 = CGFloat(sin(bobPhase2 * .pi * 2)) * -4
        bob3 = CGFloat(sin(bobPhase3 * .pi * 2)) * -4.5
    }

    // MARK: - Coin Toss Animation

    private func startCoinAnimation() {
        guard isAnimating else { return }
        animateCoinSequence()
    }

    private func animateCoinSequence() {
        guard isAnimating else { return }
        
        // Coin 1: Bottle 3 → Bottle 2 (1.1s)
        coin1.toss(
            from: CGPoint(x: bottle3Pos.x, y: bottle3Pos.y - 65),
            to: CGPoint(x: bottle2Pos.x, y: bottle2Pos.y - 65),
            duration: 1.1,
            peakHeight: 100,
            flips: 2.5
        )
        
        // Coin 2: Bottle 2 → Bottle 1 (1.15s, starts at 0.5s overlap)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            guard isAnimating else { return }
            coin2.toss(
                from: CGPoint(x: bottle2Pos.x, y: bottle2Pos.y - 65),
                to: CGPoint(x: bottle1Pos.x, y: bottle1Pos.y - 65),
                duration: 1.15,
                peakHeight: 95,
                flips: 2.8
            )
        }
        
        // Loop after both complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) { [self] in
            guard isAnimating else { return }
            animateCoinSequence()
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        BottlesAnimationView()
    }
}
