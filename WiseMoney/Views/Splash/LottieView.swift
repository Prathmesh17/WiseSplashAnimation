//
//  LottieView.swift
//  WiseMoney
//
//  Created by Prathmesh Parteki on 17/02/26.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let animationName: String
    var loopMode: LottieLoopMode = .playOnce
    var animationSpeed: CGFloat = 1.0
    var onAnimationComplete: (() -> Void)? = nil
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView(frame: .zero)
        let animationView = LottieAnimationView(name: animationName)
        animationView.loopMode = loopMode
        animationView.animationSpeed = animationSpeed
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            animationView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        animationView.play { finished in
            if finished {
                onAnimationComplete?()
            }
        }
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
