import SwiftUI

struct ReelTuner: View {
    @ObservedObject var conductor: ReelConductor
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("REEL TUNER")
                    .font(.system(size: 36, weight: .black, design: .monospaced))
                    .foregroundColor(.orange)
                
                // Stor viktoriansk mätare
                ZStack {
                    Circle()
                        .fill(Color.black.opacity(0.8))
                        .frame(width: 280, height: 280)
                        .overlay(
                            Circle()
                                .stroke(Color.brass, lineWidth: 12)
                        )
                    
                    // Visare
                    Path { 
                        let angle = Angle(degrees: conductor.tunerPitch * 180) // -50 to +50 cent = -90 to +90 grader
                        Path { path in
                            path.move(to: CGPoint(x: 140, y: 140))
                            path.addLine(to: CGPoint(x: 140 + 100 * cos(angle.radians - .pi/2), y: 140 + 100 * sin(angle.radians - .pi/2)))
                        }
                        .stroke(Color.red, lineWidth: 4)
                        .rotationEffect(Angle(degrees: 180))
                    }()
                    
                    Text(conductor.tunerNote)
                        .font(.system(size: 48, weight: .black))
                        .foregroundColor(conductor.tunerInTune ? .green : .red)
                    
                    Text(conductor.tunerCents > 0 ? "+\(Int(conductor.tunerCents)) cent" : "\(Int(conductor.tunerCents)) cent")
                        .foregroundColor(.orange)
                }
                
                // 432 / 440 Hz spak
                Toggle("432 Hz", isOn: $conductor.tuner432)
                    .toggleStyle(SwitchToggleStyle(tint: .purple))
                    .foregroundColor(.purple)
                    .padding(.horizontal, 80)
                
                Spacer()
                
                Button("STÄNG") {
                    dismiss()
                }
                .foregroundColor(.gray)
                .padding()
            }
            .padding()
        }
    }
}

extension Color {
    static let brass = Color(red: 0.8, green: 0.6, blue: 0.3)
}
