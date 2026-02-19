//
//  AuthView.swift
//  WiseMoney
//
//  Created by Prathmesh Parteki on 17/02/26.
//

import SwiftUI

struct AuthView: View {
    var isLoginMode: Bool
    var onLoginSuccess: () -> Void
    var onDismiss: () -> Void
    
    @State private var isLogin: Bool = true
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var fullName = ""
    @State private var showPassword = false
    @State private var animateContent = false
    @State private var buttonPressed = false
    
    private let wiseGreen = Color(red: 159/255, green: 232/255, blue: 112/255)
    
    var body: some View {
        ZStack {
            // Black background
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top bar with close button
                HStack {
                    Button(action: { onDismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(0.08))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Header
                        VStack(spacing: 8) {
                            Text(isLogin ? "Welcome back" : "Create account")
                                .font(.system(size: 32, weight: .black, design: .default))
                                .foregroundColor(.white)
                            
                            Text(isLogin ? "Log in to your WiseMoney account" : "Start your financial journey")
                                .font(.system(size: 15, weight: .regular, design: .rounded))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding(.top, 30)
                        .padding(.bottom, 36)
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : 15)
                        
                        // Login / Signup Toggle
                        HStack(spacing: 0) {
                            tabButton(title: "Log in", isSelected: isLogin) {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                    isLogin = true
                                }
                            }
                            tabButton(title: "Sign Up", isSelected: !isLogin) {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                    isLogin = false
                                }
                            }
                        }
                        .padding(3)
                        .background(Color.white.opacity(0.06))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .padding(.horizontal, 24)
                        .padding(.bottom, 28)
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : 15)
                        
                        // Fields
                        VStack(spacing: 14) {
                            if !isLogin {
                                AuthTextField(
                                    icon: "person.fill",
                                    placeholder: "Full Name",
                                    text: $fullName,
                                    accentColor: wiseGreen
                                )
                                .transition(.move(edge: .top).combined(with: .opacity))
                            }
                            
                            AuthTextField(
                                icon: "envelope.fill",
                                placeholder: "Email Address",
                                text: $email,
                                accentColor: wiseGreen
                            )
                            
                            AuthTextField(
                                icon: "lock.fill",
                                placeholder: "Password",
                                text: $password,
                                isSecure: !showPassword,
                                accentColor: wiseGreen,
                                trailingIcon: showPassword ? "eye.slash.fill" : "eye.fill",
                                onTrailingTap: { showPassword.toggle() }
                            )
                            
                            if !isLogin {
                                AuthTextField(
                                    icon: "lock.shield.fill",
                                    placeholder: "Confirm Password",
                                    text: $confirmPassword,
                                    isSecure: !showPassword,
                                    accentColor: wiseGreen
                                )
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                            }
                        }
                        .padding(.horizontal, 24)
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : 15)
                        
                        // Forgot Password
                        if isLogin {
                            HStack {
                                Spacer()
                                Button(action: {}) {
                                    Text("Forgot Password?")
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .foregroundColor(wiseGreen)
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 12)
                        }
                        
                        // Action Button
                        Button(action: {
                            withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                                buttonPressed = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                buttonPressed = false
                            }
                            onLoginSuccess()
                        }) {
                            Text(isLogin ? "Log in" : "Create Account")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(wiseGreen)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .scaleEffect(buttonPressed ? 0.96 : 1)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 28)
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : 15)
                        
                        // Divider
                        HStack(spacing: 14) {
                            Rectangle()
                                .fill(Color.white.opacity(0.1))
                                .frame(height: 1)
                            
                            Text("or")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.3))
                            
                            Rectangle()
                                .fill(Color.white.opacity(0.1))
                                .frame(height: 1)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                        .opacity(animateContent ? 1 : 0)
                        
                        // Sign in with Apple
                        Button(action: { onLoginSuccess() }) {
                            HStack(spacing: 8) {
                                Image(systemName: "apple.logo")
                                    .font(.system(size: 18, weight: .medium))
                                Text("Sign in with Apple")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : 10)
                        
                        // Google Sign In
                        Button(action: { onLoginSuccess() }) {
                            HStack(spacing: 8) {
                                Image(systemName: "g.circle.fill")
                                    .font(.system(size: 18, weight: .medium))
                                Text("Sign in with Google")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white.opacity(0.06))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 10)
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : 10)
                        
                        Spacer().frame(height: 40)
                    }
                }
            }
        }
        .onAppear {
            isLogin = isLoginMode
            withAnimation(.easeOut(duration: 0.6)) {
                animateContent = true
            }
        }
    }
    
    // MARK: - Tab Button
    private func tabButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(isSelected ? .black : .white.opacity(0.4))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isSelected ? wiseGreen : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 11))
        }
    }
}

// MARK: - Auth Text Field
struct AuthTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var accentColor: Color = .green
    var trailingIcon: String? = nil
    var onTrailingTap: (() -> Void)? = nil
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(isFocused ? accentColor : Color.white.opacity(0.35))
                .frame(width: 20)
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .font(.system(size: 16, weight: .regular, design: .rounded))
            .foregroundColor(.white)
            .focused($isFocused)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            
            if let trailingIcon = trailingIcon {
                Button(action: { onTrailingTap?() }) {
                    Image(systemName: trailingIcon)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.white.opacity(0.35))
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(
                            isFocused ? accentColor.opacity(0.5) : Color.white.opacity(0.06),
                            lineWidth: 1
                        )
                )
        )
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

#Preview {
    AuthView(isLoginMode: true, onLoginSuccess: {}, onDismiss: {})
}
