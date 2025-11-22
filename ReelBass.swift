import SwiftUI

struct ReelBass: View {
    @ObservedObject var conductor: ReelConductor
    @Environment(\.dismiss) var dismiss
    
    let amps = ["SVT", "Bassman", "Acoustic 360", "DI Clean", "Flip Top", "B-Man", "Darkglass"]
    
    let effects = ["Comp", "OD/DS", "Octave", "Defretter", "Touch Wah", "Slow Gear", "Delay", "Chorus"]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("REEL BASS")
                    .font(.system(size: 36, weight: .black, design: .monospaced))
                    .foregroundColor(.orange)
                
                // Amp-väljare
                Picker("Amp", selection: $conductor.selectedBassAmp) {
                    ForEach(amps, id: \.self) { amp in
                        Text(amp).tag(amp)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 120)
                .clipped()
                
                // Effects
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        ForEach(effects, id: \.self) { effect in
                            Button {
                                conductor.toggleBassEffect(effect)
                            } label: {
                                VStack {
                                    Circle()
                                        .fill(conductor.activeBassEffects.contains(effect) ? Color.green : Color.gray.opacity(0.6))
                                        .frame(width: 60, height: 60)
                                    Text(effect)
                                        .foregroundColor(.white)
                                        .font(.caption)
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                // Kompressor + Gain + Blend rattar
                HStack(spacing: 30) {
                    VStack {
                        Text("COMP")
                        Knob(value: $conductor.bassComp, range: 0...100)
                    }
                    VStack {
                        Text("GAIN")
                        Knob(value: $conductor.bassGain, range: 0...100)
                    }
                    VStack {
                        Text("BLEND")
                        Knob(value: $conductor.bassBlend, range: 0...100)
                    }
                }
                
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
