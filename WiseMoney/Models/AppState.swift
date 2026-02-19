//
//  AppState.swift
//  WiseMoney
//
//  Created by Prathmesh Parteki on 17/02/26.
//

import SwiftUI

enum AppScreen: Equatable {
    case onboarding
    case home
}

@Observable
class AppState {
    var currentScreen: AppScreen = .onboarding
    var isLoggedIn: Bool {
        get { UserDefaults.standard.bool(forKey: "isLoggedIn") }
        set { UserDefaults.standard.set(newValue, forKey: "isLoggedIn") }
    }
    
    init() {
        if isLoggedIn {
            currentScreen = .home
        }
    }
    
    func login() {
        isLoggedIn = true
        withAnimation(.easeInOut(duration: 0.5)) {
            currentScreen = .home
        }
    }
    
    func logout() {
        isLoggedIn = false
        withAnimation(.easeInOut(duration: 0.5)) {
            currentScreen = .onboarding
        }
    }
}
