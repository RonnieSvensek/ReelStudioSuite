import SwiftUI

struct ReelMaster: View {
    @ObservedObject var conductor: ReelConductor
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("REEL MASTER")
                    .font(.system(size: 36, weight: .black, design: .monospaced))
                    .foregroundColor(.orange)
                
                // Stor ratt i mitten – Output Level + Loudness Target
                VStack {
                    Text("OUTPUT")
                        .foregroundColor(.orange)
                    Knob(value: $conductor.masterLevel, range: -12...6)
                        .frame(width: 200, height: 200)
                    Text("\(conductor.masterLevel, specifier: "%.1f") dB")
                        .foregroundColor(.orange)
                        .font(.title)
                }
                
                // 4 små rattar runt om
                HStack(spacing: 40) {
                    VStack {
                        Text("LIMITER")
                        Knob(value: $conductor.masterLimiter, range: 0...100)
                            .frame(width: 80, height: 80)
                        Text("\(Int(conductor.masterLimiter))%")
                            .foregroundColor(.red)
                    }
                    
                    VStack {
                        Text("WARMTH")
                        Knob(value: $conductor.masterWarmth, range: 0...100)
                            .frame(width: 80, height: 80)
                        Text("\(Int(conductor.masterWarmth))%")
                            .foregroundColor(.yellow)
                    }
                }
                
                HStack(spacing: 40) {
                    VStack {
                        Text("STEREO")
                        Knob(value: $conductor.masterStereo, range: 0...100)
                            .frame(width: 80, height: 80)
                        Text("\(Int(conductor.masterStereo))%")
                            .foregroundColor(.cyan)
                    }
                    
                    VStack {
                        Text("EXCITE")
                        Knob(value: $conductor.masterExcite, range: 0...100)
                            .frame(width: 80, height: 80)
                        Text("\(Int(conductor.masterExcite))%")
                            .foregroundColor(.purple)
                    }
                }
                
                Spacer()
                
                Button("STÄNG MASTER") {
                    dismiss()
                }
                .foregroundColor(.gray)
                .padding()
            }
            .padding()
        }
    }
}
