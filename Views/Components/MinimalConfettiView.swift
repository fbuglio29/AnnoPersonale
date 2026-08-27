import SwiftUI

struct Particle: Identifiable {
    let id = UUID()
    var x: Double
    var y: Double
    var size: Double
    var color: Color
    var opacity: Double
}

struct MinimalConfettiView: View {
    @State private var particles: [Particle] = []
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(particle.color)
                        .frame(width: particle.size, height: particle.size)
                        .position(x: particle.x, y: particle.y)
                        .opacity(particle.opacity)
                }
            }
            .onAppear {
                spawnParticles(in: geo.size)
            }
        }
        .allowsHitTesting(false)
    }
    
    private func spawnParticles(in size: CGSize) {
        let colors: [Color] = [.pastelSage, .pastelPowderBlue, .pastelLavender, .pastelBlushPink, .pastelYellow]
        particles = (0..<25).map { _ in
            Particle(
                x: size.width / 2 + Double.random(in: -40...40),
                y: size.height / 2 + Double.random(in: -40...40),
                size: Double.random(in: 6...12),
                color: colors.randomElement()!,
                opacity: 1.0
            )
        }
        
        withAnimation(.easeOut(duration: 1.2)) {
            particles = particles.map { p in
                var p2 = p
                p2.x += Double.random(in: -120...120)
                p2.y += Double.random(in: -160...40)
                p2.opacity = 0
                return p2
            }
        }
    }
}
