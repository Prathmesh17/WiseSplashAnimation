//
//  WiseMoneyApp.swift
//  WiseMoney
//
//  Created by Prathmesh Parteki on 17/02/26.
//

import SwiftUI

@main
struct WiseMoneyApp: App {
    var body: some Scene {
        SplashScreen(
            config: LaunchScreenConfig(
                initialDelay: 0.5,
                backgroundColor: Color(red: 159/255, green: 232/255, blue: 112/255),
                logoBackgroundColor: Color(red: 159/255, green: 232/255, blue: 112/255),
                scaling: 4,
                animation: .smooth(duration: 1, extraBounce: 0)
            )
        ) {
            // Logo — the Wise-style icon (dark on green)
            Image(systemName: "arrow.triangle.swap")
                .font(.system(size: 60, weight: .bold))
                .foregroundColor(Color(red: 30/255, green: 60/255, blue: 20/255))
        } rootContent: {
            ContentView()
        }
    }
}
