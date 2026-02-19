//
//  OnboardingView.swift
//  WiseMoney
//
//  Created by Prathmesh Parteki on 17/02/26.
//

import SwiftUI
import Lottie

// MARK: - Page Model
struct OnboardingPage: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let subtitle: String?
    let isLastPage: Bool
}

// MARK: - Main Onboarding View
struct OnboardingView: View {
    let onLogin: () -> Void
    let onRegister: () -> Void
    
    @State private var currentPage = 0
    @State private var timer: Timer?
    @State private var progressFraction: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    
    private let wiseGreen = Color(red: 159/255, green: 232/255, blue: 112/255)
    private let totalPages = 5
    private let autoAdvanceInterval: TimeInterval = 3.0
    
    // Fixed height for the bottom button area — matches the tallest variant
    // (Login + Register row + Apple row + spacing = ~160pt)
    private let bottomButtonAreaHeight: CGFloat = 148
    
    let pages: [OnboardingPage] = [
        OnboardingPage(
            imageName: "OnboardingPlane",
            title: "SEND MONEY AND\nGET PAID FROM\nABROAD",
            subtitle: "Check our rates",
            isLastPage: false
        ),
        OnboardingPage(
            imageName: "OnboardingLock",
            title: "KEEP YOUR\nMONEY SAFE",
            subtitle: nil,
            isLastPage: false
        ),
        OnboardingPage(
            imageName: "OnboardingCard",
            title: "PAY YOUR WAY\nWORLDWIDE WITH A\nUNIVERSAL CARD",
            subtitle: nil,
            isLastPage: false
        ),
        OnboardingPage(
            imageName: "OnboardingGrowth",
            title: "GROW YOUR\nSAVINGS\nSMARTER",
            subtitle: nil,
            isLastPage: false
        ),
        OnboardingPage(
            imageName: "OnboardingGlobe",
            title: "ONE ACCOUNT FOR\nALL THE MONEY\nIN THE WORLD",
            subtitle: nil,
            isLastPage: true
        )
    ]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // ── FIXED TOP: Progress Bar ──
                smoothProgressBar
                    .padding(.top, 8)
                    .padding(.horizontal, 40)
                
                // ── SLIDING MIDDLE: Image + Title carousel ──
                GeometryReader { geo in
                    let pageWidth = geo.size.width
                    
                    HStack(spacing: 0) {
                        ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                            VStack(spacing: 0) {
                                Spacer()
                                
                                // Image / Animation area — fixed size
                                if index == 0 {
                                    // Bottles page: 3 colorful jars with coin toss animation
                                    BottlesAnimationView()
                                        .frame(maxWidth: 350, maxHeight: 320)
                                }else if index == 1 {
                                     // Paper plane page: Lottie animation
                                    LottieView(
                                        animationName: "paperplane",
                                        loopMode: .loop
                                    )
                                    .frame(maxWidth: 600, maxHeight: 350)
                                } else if index == 2 {
                                    // Card page: Lottie globe + card overlay
                                    ZStack {
                                        LottieView(
                                            animationName: "globe_animation",
                                            loopMode: .loop
                                        )
                                        .frame(width:400, height: 400)
                                        
                                        WiseCardView()
                                            .frame(width: 180, height: 120)
                                            .offset(x: 40, y: 15)
                                            .shadow(color: .black.opacity(0.3), radius: 10, x: 2, y: 4)
                                    }
                                    .frame(maxWidth: 300, maxHeight: 280)
                                } else if index == 3 {
                                    // Lock page: animated lock with rotation
                                    LockAnimationView()
                                        .frame(maxWidth: 300, maxHeight: 300)
                                } else if index == 4 {
                                    // Globe page: animated coins orbiting the globe
                                    GlobeCoinsAnimationView()
                                        .frame(maxWidth: 350, maxHeight: 320)
                                } 
                                Spacer()
                                    .frame(height: 32)
                                
                                // Title — fixed position from bottom of this area
                                Text(page.title)
                                    .font(.system(size: 34, weight: .black, design: .default))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(2)
                                    .frame(height: 130, alignment: .top)
                                    .padding(.horizontal, 24)
                                
                                // Subtitle
                                if let subtitle = page.subtitle {
                                    Button(action: {}) {
                                        Text(subtitle)
                                            .font(.system(size: 16, weight: .medium, design: .rounded))
                                            .foregroundColor(wiseGreen)
                                            .underline()
                                    }
                                    .frame(height: 24)
                                } else {
                                    // Spacer to keep consistent height even without subtitle
                                    Spacer()
                                        .frame(height: 24)
                                }
                                
                                Spacer()
                                    .frame(height: 8)
                            }
                            .frame(width: pageWidth)
                        }
                    }
                    .offset(x: -CGFloat(currentPage) * pageWidth + dragOffset)
                    .animation(.easeInOut(duration: 0.35), value: currentPage)
                    .gesture(
                        DragGesture(minimumDistance: 20)
                            .onChanged { value in
                                dragOffset = value.translation.width
                            }
                            .onEnded { value in
                                let threshold = pageWidth * 0.25
                                var newPage = currentPage
                                
                                if value.translation.width < -threshold && currentPage < totalPages - 1 {
                                    newPage = currentPage + 1
                                } else if value.translation.width > threshold && currentPage > 0 {
                                    newPage = currentPage - 1
                                }
                                
                                withAnimation(.easeInOut(duration: 0.35)) {
                                    dragOffset = 0
                                    currentPage = newPage
                                }
                                
                                if newPage < totalPages - 1 {
                                    startAutoAdvance()
                                } else {
                                    timer?.invalidate()
                                }
                            }
                    )
                }
                
                // ── FIXED BOTTOM: Button area with constant height ──
                ZStack {
                    if pages[currentPage].isLastPage {
                        lastPageButtons
                            .transition(.opacity)
                    } else {
                        // "Get started" centered vertically in the same fixed-height area
                        VStack {
                            Spacer()
                            getStartedButton
                            Spacer()
                        }
                        .transition(.opacity)
                    }
                }
                .frame(height: bottomButtonAreaHeight)
                .animation(.easeInOut(duration: 0.25), value: pages[currentPage].isLastPage)
                
                Spacer()
                    .frame(height: 24)
            }
        }
        .onAppear {
            updateProgress(for: currentPage)
            // Delay auto-advance to account for splash screen duration
            // so the first page gets its full 3 seconds of visibility
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                startAutoAdvance()
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
        .onChange(of: currentPage) { _, newValue in
            updateProgress(for: newValue)
        }
    }
    
    // MARK: - Smooth Continuous Progress Bar
    private var smoothProgressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.white.opacity(0.15))
                    .frame(height: 4)
                
                RoundedRectangle(cornerRadius: 3)
                    .fill(wiseGreen)
                    .frame(
                        width: geo.size.width * progressFraction,
                        height: 4
                    )
                    .animation(.easeInOut(duration: 0.4), value: progressFraction)
            }
        }
        .frame(height: 4)
    }
    
    private func updateProgress(for page: Int) {
        progressFraction = CGFloat(page + 1) / CGFloat(totalPages)
    }
    
    // MARK: - Get Started Button
    private var getStartedButton: some View {
        Button(action: {
            timer?.invalidate()
            withAnimation(.easeInOut(duration: 0.35)) {
                dragOffset = 0
                currentPage = totalPages - 1
            }
        }) {
            Text("Get started")
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
                .background(wiseGreen)
                .clipShape(Capsule())
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Last Page Buttons
    private var lastPageButtons: some View {
        VStack(spacing: 14) {
            HStack(spacing: 12) {
                Button(action: { onLogin() }) {
                    Text("Log in")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(wiseGreen)
                        .clipShape(Capsule())
                }
                
                Button(action: { onRegister() }) {
                    Text("Register")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(wiseGreen)
                        .clipShape(Capsule())
                }
            }
            
            Button(action: { onLogin() }) {
                HStack(spacing: 8) {
                    Image(systemName: "apple.logo")
                        .font(.system(size: 17, weight: .medium))
                    Text("Sign in with Apple")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.white)
                .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Auto Advance
    private func startAutoAdvance() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: autoAdvanceInterval, repeats: true) { _ in
            if currentPage < totalPages - 1 {
                withAnimation(.easeInOut(duration: 0.35)) {
                    currentPage += 1
                }
            } else {
                timer?.invalidate()
            }
        }
    }
}

// MARK: - Wise Card View

struct WiseCardView: View {
    private let cardGreen = Color(red: 145/255, green: 210/255, blue: 95/255)
    private let cardGreenDark = Color(red: 125/255, green: 195/255, blue: 75/255)
    
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            
            ZStack(alignment: .topLeading) {
                // Card background
                RoundedRectangle(cornerRadius: w * 0.06)
                    .fill(
                        LinearGradient(
                            colors: [cardGreen, cardGreenDark],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // Subtle card notch (right side)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Circle()
                            .fill(Color.black.opacity(0.00001)) // invisible but shapes the silhouette
                            .frame(width: w * 0.06, height: w * 0.06)
                    }
                    Spacer().frame(height: h * 0.35)
                }
                
                // Chip
                RoundedRectangle(cornerRadius: 3)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.85, green: 0.82, blue: 0.75),
                                Color(red: 0.92, green: 0.90, blue: 0.85),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        // Chip lines
                        VStack(spacing: 2) {
                            Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 0.5)
                            Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 0.5)
                        }
                        .padding(.horizontal, 2)
                    )
                    .frame(width: w * 0.12, height: h * 0.16)
                    .offset(x: w * 0.10, y: h * 0.55)
                
                // Wise logo text
                HStack(spacing: 1) {
                    // "=7" symbol
                    Text("\u{2261}7")
                        .font(.system(size: h * 0.22, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.18, green: 0.32, blue: 0.10))
                    
                    Text("wise")
                        .font(.system(size: h * 0.18, weight: .bold, design: .default))
                        .foregroundColor(Color(red: 0.18, green: 0.32, blue: 0.10))
                }
                .offset(x: w * 0.52, y: h * 0.18)
            }
        }
    }
}

#Preview {
    OnboardingView(onLogin: {}, onRegister: {})
}
