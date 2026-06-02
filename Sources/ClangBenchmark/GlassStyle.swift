import SwiftUI

// MARK: - Color Extensions

extension Color {
    static let liquidBlue = Color(red: 0.74, green: 0.89, blue: 0.99)
    static let deepBlue = Color(red: 0.20, green: 0.45, blue: 0.80)
    static let accentBlue = Color(red: 0.29, green: 0.56, blue: 0.89)
    static let softWhite = Color(red: 0.98, green: 0.98, blue: 1.0)
}

// MARK: - Glass Card Modifier

struct GlassCard: ViewModifier {
    var padding: CGFloat = 20
    var cornerRadius: CGFloat = 20

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                ZStack {
                    // Frosted glass base
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(.white.opacity(0.25))

                    // Ultra thin material for depth
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(.ultraThinMaterial)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                // Glass edge highlight
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.7), .white.opacity(0.2), .white.opacity(0.5)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Glass Button Modifier

struct GlassButton: ViewModifier {
    var pressed: Bool = false

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 28)
            .padding(.vertical, 12)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white.opacity(0.35))

                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white.opacity(0.6), lineWidth: 1)
            )
            .shadow(color: .blue.opacity(0.12), radius: 8, y: 3)
            .scaleEffect(pressed ? 0.97 : 1.0)
    }
}

// MARK: - Small Glass Card

struct SmallGlassCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(14)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(.white.opacity(0.2))
                    RoundedRectangle(cornerRadius: 14)
                        .fill(.ultraThinMaterial)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(.white.opacity(0.5), lineWidth: 0.8)
            )
            .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
    }
}

// MARK: - Convenience View Extensions

extension View {
    func glassCard(padding: CGFloat = 20, cornerRadius: CGFloat = 20) -> some View {
        modifier(GlassCard(padding: padding, cornerRadius: cornerRadius))
    }

    func glassButton(pressed: Bool = false) -> some View {
        modifier(GlassButton(pressed: pressed))
    }

    func smallGlassCard() -> some View {
        modifier(SmallGlassCard())
    }
}
