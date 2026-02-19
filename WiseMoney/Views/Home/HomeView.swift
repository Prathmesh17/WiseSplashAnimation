//
//  HomeView.swift
//  WiseMoney
//
//  Created by Prathmesh Parteki on 17/02/26.
//

import SwiftUI

struct HomeView: View {
    private let wiseGreen = Color(red: 159/255, green: 232/255, blue: 112/255)
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 24) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(wiseGreen)
                
                Text("Welcome to WiseMoney!")
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Your dashboard will appear here")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(.white.opacity(0.5))
            }
        }
    }
}

#Preview {
    HomeView()
}
