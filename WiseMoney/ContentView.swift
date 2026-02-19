//
//  ContentView.swift
//  WiseMoney
//
//  Created by Prathmesh Parteki on 17/02/26.
//

import SwiftUI

struct ContentView: View {
    @State private var appState = AppState()
    @State private var showAuth = false
    @State private var isLoginMode = true
    
    var body: some View {
        ZStack {
            switch appState.currentScreen {
            case .onboarding:
                OnboardingView(
                    onLogin: {
                        isLoginMode = true
                        showAuth = true
                    },
                    onRegister: {
                        isLoginMode = false
                        showAuth = true
                    }
                )
                .transition(.opacity)
                
            case .home:
                HomeView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .opacity
                    ))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appState.currentScreen)
        .fullScreenCover(isPresented: $showAuth) {
            AuthView(
                isLoginMode: isLoginMode,
                onLoginSuccess: {
                    showAuth = false
                    appState.login()
                },
                onDismiss: {
                    showAuth = false
                }
            )
        }
    }
}

#Preview {
    ContentView()
}
