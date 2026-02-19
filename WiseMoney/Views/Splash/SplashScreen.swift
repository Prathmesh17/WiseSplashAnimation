//  SplashScreen.swift
//  WiseMoney
//
//  Created by Prathmesh Parteki on 17/02/26.
//
import SwiftUI

// MARK: - Configuration

struct LaunchScreenConfig {
    var initialDelay: Double = 0.5
    var backgroundColor: Color = .green
    var logoBackgroundColor: Color = Color(red: 159/255, green: 232/255, blue: 112/255)
    var scaling: CGFloat = 4
    var animation: Animation = .smooth(duration: 1.2, extraBounce: 0)
}

// MARK: - Scene Wrapper

struct SplashScreen<RootView: View, Logo: View>: Scene {
    var config: LaunchScreenConfig = .init()
    @ViewBuilder var logo: () -> Logo
    @ViewBuilder var rootContent: RootView

    var body: some Scene {
        WindowGroup {
            rootContent
                .modifier(LaunchScreenModifier(config: config, logo: logo))
        }
    }
}

// MARK: - View Modifier (UIWindow overlay)

fileprivate struct LaunchScreenModifier<Logo: View>: ViewModifier {
    var config: LaunchScreenConfig
    @ViewBuilder var logo: Logo
    @Environment(\.scenePhase) private var scenePhase
    @State private var splashWindow: UIWindow?

    func body(content: Content) -> some View {
        content
            .onAppear {
                let scenes = UIApplication.shared.connectedScenes
                for scene in scenes {
                    guard let windowScene = scene as? UIWindowScene,
                          checkStates(windowScene.activationState),
                          !windowScene.windows.contains(where: { $0.tag == 1009 })
                    else {
                        continue
                    }

                    let window = UIWindow(windowScene: windowScene)
                    window.backgroundColor = .clear
                    window.isHidden = false
                    window.isUserInteractionEnabled = true
                    window.tag = 1009

                    let rootViewController = UIHostingController(
                        rootView: WiseSplashAnimationView(config: config) {
                            logo
                        } isCompleted: {
                            window.isHidden = true
                            window.isUserInteractionEnabled = false
                        }
                    )
                    rootViewController.view.backgroundColor = .clear
                    window.rootViewController = rootViewController
                    self.splashWindow = window
                }
            }
    }

    private func checkStates(_ state: UIWindowScene.ActivationState) -> Bool {
        switch scenePhase {
        case .active: return state == .foregroundActive
        case .inactive: return state == .foregroundInactive
        case .background: return state == .background
        default: return state.hashValue == scenePhase.hashValue
        }
    }
}

// MARK: - Wise-Style Splash Animation View

fileprivate struct WiseSplashAnimationView<Logo: View>: View {
    var config: LaunchScreenConfig
    @ViewBuilder var logo: Logo
    var isCompleted: () -> ()

    // Animation states
    @State private var logoVisible: Bool = false
    @State private var logoFadeOut: Bool = false
    @State private var finalFadeOut: Bool = false

    // 0.0 = strip+button hidden below, 1.0 = reached top
    @State private var riseProgress: CGFloat = 0.0

    // For final width expansion (centered)
    @State private var stripWidthExpand: CGFloat = 1.0


    // Subtle background pulse
    @State private var bgPulse: Bool = false

    // Colors
    private let wiseGreen = Color(red: 159/255, green: 232/255, blue: 112/255)
    private let wiseGreenDark = Color(red: 130/255, green: 210/255, blue: 85/255)
    private let wiseGreenLight = Color(red: 175/255, green: 240/255, blue: 140/255)

    // Button size
    private let buttonSize: CGFloat = 70

    var body: some View {
        GeometryReader { geo in
            let screenHeight = geo.size.height
            let screenWidth = geo.size.width

            // Button travels from bottom (screenHeight + 40) to top (-40)
            let buttonStartY = screenHeight + 40
            let buttonEndY: CGFloat = -80
            let buttonY = buttonStartY + riseProgress * (buttonEndY - buttonStartY)

            // Strip width: starts narrow (button width) and widens as button rises
            let minStripWidth: CGFloat = buttonSize + 10
            let maxStripWidth: CGFloat = screenWidth * 0.35
            let baseStripWidth = minStripWidth + riseProgress * (maxStripWidth - minStripWidth)
            let currentStripWidth = baseStripWidth * stripWidthExpand

            // Strip goes from bottom of screen up to the button center
            let stripHeight = max(screenHeight - buttonY + 20, 0)

            ZStack {
                // Layer 1: Rich green background with subtle radial gradient
                ZStack {
                    Rectangle()
                        .fill(wiseGreen)
                        .ignoresSafeArea()

                    // Subtle radial glow for depth
                    RadialGradient(
                        colors: [
                            wiseGreenLight.opacity(bgPulse ? 0.6 : 0.4),
                            wiseGreen.opacity(0.0)
                        ],
                        center: .center,
                        startRadius: 20,
                        endRadius: screenWidth * 0.8
                    )
                    .ignoresSafeArea()
                    .blendMode(.screen)

                    // Subtle edge vignette for polish
                    RadialGradient(
                        colors: [
                            Color.clear,
                            wiseGreenDark.opacity(0.15)
                        ],
                        center: .center,
                        startRadius: screenWidth * 0.4,
                        endRadius: screenWidth * 1.0
                    )
                    .ignoresSafeArea()
                }

                // Layer 2: Logo centered with shadow for crispness
                logo
                    .scaleEffect(logoVisible ? 1.0 : 0.5)
                    .opacity(logoVisible && !logoFadeOut ? 1.0 : 0)
                    .offset(y: -screenHeight * 0.06)
                    .shadow(color: Color.black.opacity(0.08), radius: 2, x: 0, y: 1)

                // Layer 3: Watercolor strip — anchored at bottom, centered horizontally
                if riseProgress > 0 {
                    WatercolorStrip()
                        .frame(width: currentStripWidth, height: stripHeight)
                        .drawingGroup()
                        .position(
                            x: screenWidth / 2,
                            y: screenHeight - (stripHeight / 2) + 10
                        )

                    // Layer 4: Arrow button at top of strip
                    WiseArrowButton(size: buttonSize)
                        .position(x: screenWidth / 2 , y: buttonY + 25)
                }
            }
            .opacity(finalFadeOut ? 0 : 1)
            .task {
                await runAnimation()
            }
        }
        .ignoresSafeArea()
    }

    private func runAnimation() async {
        // Kick off subtle bg pulse
        withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
            bgPulse = true
        }

        // Phase 0: Show logo
        try? await Task.sleep(for: .seconds(0.2))
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            logoVisible = true
        }

        // Phase 1: Brief pause
        try? await Task.sleep(for: .seconds(config.initialDelay))

        // Phase 2: Strip + button quickly enters from bottom
        withAnimation(.easeOut(duration: 0.4)) {
            riseProgress = 0.12
        }

        try? await Task.sleep(for: .seconds(0.3))

        // Phase 3: Steady rise — button+strip climb, strip widens
        withAnimation(.easeInOut(duration: 1)) {
            riseProgress = 0.50
        }

        try? await Task.sleep(for: .seconds(0.8))

        // Fade logo
        withAnimation(.easeOut(duration: 0.3)) {
            logoFadeOut = true
        }

        // Phase 4: Accelerate to top — noticeably faster than the climb
        withAnimation(.easeIn(duration: 0.5)) {
            riseProgress = 1.0
        }

        try? await Task.sleep(for: .seconds(0.35))

        // Phase 5: Strip expands from center to fill screen
        withAnimation(.easeInOut(duration: 0.4)) {
            stripWidthExpand = 3.5
        }

        try? await Task.sleep(for: .seconds(0.5))

        // Phase 6: Fade out
        withAnimation(.easeOut(duration: 0.4)) {
            finalFadeOut = true
        }

        try? await Task.sleep(for: .seconds(0.45))
        isCompleted()
    }
}

// MARK: - Watercolor Strip Component

fileprivate struct WatercolorStrip: View {
    // Crisp, saturated palette
    private let deepViolet   = Color(red: 0.42, green: 0.22, blue: 0.92)
    private let electricBlue = Color(red: 0.30, green: 0.50, blue: 0.98)
    private let cyanWash     = Color(red: 0.15, green: 0.75, blue: 0.96)
    private let magenta      = Color(red: 0.85, green: 0.18, blue: 0.58)
    private let hotPink      = Color(red: 0.96, green: 0.22, blue: 0.42)
    private let roseGold     = Color(red: 0.94, green: 0.40, blue: 0.52)

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                // Base gradient
                CapsuleTopShape()
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: deepViolet, location: 0.0),
                                .init(color: electricBlue, location: 0.2),
                                .init(color: cyanWash.opacity(0.7), location: 0.35),
                                .init(color: deepViolet.opacity(0.9), location: 0.50),
                                .init(color: magenta, location: 0.7),
                                .init(color: hotPink, location: 0.85),
                                .init(color: roseGold, location: 1.0),
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                // Diagonal cyan highlight
                CapsuleTopShape()
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: .clear, location: 0.0),
                                .init(color: cyanWash.opacity(0.55), location: 0.20),
                                .init(color: electricBlue.opacity(0.35), location: 0.40),
                                .init(color: .clear, location: 0.55),
                                .init(color: cyanWash.opacity(0.25), location: 0.75),
                                .init(color: .clear, location: 1.0),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                // Pink diagonal accent
                CapsuleTopShape()
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: .clear, location: 0.0),
                                .init(color: magenta.opacity(0.45), location: 0.25),
                                .init(color: .clear, location: 0.45),
                                .init(color: hotPink.opacity(0.50), location: 0.70),
                                .init(color: roseGold.opacity(0.55), location: 0.90),
                                .init(color: .clear, location: 1.0),
                            ],
                            startPoint: .topTrailing,
                            endPoint: .bottomLeading
                        )
                    )

                // Shimmer highlights
                CapsuleTopShape()
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: .white.opacity(0.0), location: 0.0),
                                .init(color: .white.opacity(0.14), location: 0.15),
                                .init(color: .white.opacity(0.0), location: 0.25),
                                .init(color: .white.opacity(0.08), location: 0.50),
                                .init(color: .white.opacity(0.0), location: 0.60),
                                .init(color: .white.opacity(0.16), location: 0.80),
                                .init(color: .white.opacity(0.0), location: 1.0),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                // Inner edge highlight
                CapsuleTopShape()
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.25),
                                .white.opacity(0.05),
                                .white.opacity(0.15),
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 0.8
                    )
            }
        }
//        .shadow(color: deepViolet.opacity(0.45), radius: 20, x: 0, y: 0)
//        .shadow(color: magenta.opacity(0.20), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Custom Shape: Semicircular Top, Straight Sides, Flat Bottom

fileprivate struct CapsuleTopShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let radius = w / 2 // Perfect semicircle at the top

        if h < radius {
            // If strip is shorter than the radius, just draw an arc
            path.move(to: CGPoint(x: 0, y: h))
            path.addLine(to: CGPoint(x: 0, y: radius))
            path.addArc(
                center: CGPoint(x: w / 2 - 10, y: radius),
                radius: radius,
                startAngle: .degrees(180),
                endAngle: .degrees(0),
                clockwise: false
            )
            path.addLine(to: CGPoint(x: w, y: h))
            path.closeSubpath()
        } else {
            // Full shape: semicircle top + straight sides + flat bottom
            path.move(to: CGPoint(x: 0, y: h))       // bottom-left
            path.addLine(to: CGPoint(x: 0, y: radius)) // left side up
            path.addArc(
                center: CGPoint(x: w / 2 , y: radius),
                radius: radius,
                startAngle: .degrees(180),
                endAngle: .degrees(0),
                clockwise: false
            )                                          // semicircle top
            path.addLine(to: CGPoint(x: w, y: h))     // right side down
            path.closeSubpath()                        // flat bottom
        }

        return path
    }
}

// MARK: - Arrow Button Component

fileprivate struct WiseArrowButton: View {
    var size: CGFloat

    private let wiseGreen = Color(red: 159/255, green: 232/255, blue: 112/255)

    var body: some View {
        ZStack {
            // Outer glow ring
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            wiseGreen.opacity(0.3),
                            wiseGreen.opacity(0.0)
                        ],
                        center: .center,
                        startRadius: size * 0.4,
                        endRadius: size * 0.7
                    )
                )
                .frame(width: size * 1.4, height: size * 1.4)

            // Background fill with subtle gradient
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            wiseGreen.opacity(0.65),
                            wiseGreen.opacity(0.45),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: size, height: size)

            // Inner light rim (top highlight)
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.5),
                            .white.opacity(0.0),
                            .black.opacity(0.05),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1.2
                )
                .frame(width: size, height: size)

            // Crisp arrow icon
            Image(systemName: "arrow.up")
                .font(.system(size: size * 0.80, weight: .thin, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color(red: 0.12, green: 0.14, blue: 0.10),
                            Color(red: 0.22, green: 0.25, blue: 0.18),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
        // Button drop shadow
        .shadow(color: Color.black.opacity(0.12), radius: 4, x: 0, y: 2)
        .shadow(color: wiseGreen.opacity(0.25), radius: 8, x: 0, y: 0)
    }
}

// MARK: - Preview

#Preview {
    WiseSplashPreview()
}

fileprivate struct WiseSplashPreview: View {
    @State private var showSplash = true

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            Text("Main App")
                .foregroundColor(.white)

            if showSplash {
                WiseSplashAnimationView(
                    config: LaunchScreenConfig(initialDelay: 0.3)
                ) {
                    Image(systemName: "arrow.triangle.swap")
                        .font(.system(size: 60))
                        .foregroundColor(Color(red: 30/255, green: 60/255, blue: 20/255))
                } isCompleted: {
                    withAnimation {
                        showSplash = false
                    }
                }
                .transition(.opacity)
            }
        }
    }
}
