import SwiftUI

struct CircularProgressView: View {
    var progress: Double // 0.0 to 1.0
    var lineWidth: CGFloat = 16
    var size: CGFloat = 160
    var accentColor: Color = .pastelSage
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(accentColor.opacity(0.15), lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [accentColor, accentColor.opacity(0.8), accentColor]),
                        center: .center,
                        startAngle: .degrees(-90),
                        endAngle: .degrees(270)
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round)
                )
                .rotationEffect(Angle(degrees: -90))
                .animation(.spring(response: 0.8, dampingFraction: 0.8), value: progress)
            
            VStack(spacing: 4) {
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .foregroundColor(.pastelTextDark)
                
                Text("Anno completato")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.pastelTextMuted)
            }
        }
        .frame(width: size, height: size)
    }
}
