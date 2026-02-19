//
//  GlobeCoinsAnimationView.swift
//  WiseMoney
//
//  Created by Prathmesh Parteki on 18/02/26.
//

import SwiftUI

struct GlobeCoinsAnimationView: View {
    private let globeSize: CGFloat = 950
    private let coins: [String] = Array(repeating: "Coin", count: 15)
    
    var body: some View {
        ZStack {
            // Layer 1: Back coins — rendered BEHIND the globe
            // These get naturally covered by the globe image
            Rotation3DEffect(
                symbols: coins,
                symbolFont: .caption2,
                tint: .clear,
                coinLayer: .back,
                coinSize: 300
            )
            .frame(width: 380, height: 310)
            .offset(y: 30)
            
            // Layer 2: Globe image — sits between back and front coins
            Image("Globe")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: globeSize, height: globeSize)
                .shadow(color: .cyan.opacity(0.12), radius: 25, x: 0, y: 8)
            
            // Layer 3: Front coins — rendered ON TOP of the globe
            Rotation3DEffect(
                symbols: coins,
                symbolFont: .caption2,
                tint: .clear,
                coinLayer: .front,
                coinSize: 300
            )
            .frame(width: 380, height: 310)
            .offset(y: 30)
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        GlobeCoinsAnimationView()
            .frame(maxWidth: 400, maxHeight: 400)
    }
}
