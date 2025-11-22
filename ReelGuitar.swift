import SwiftUI

struct ReelGuitar: View {
    @ObservedObject var conductor: ReelConductor
    @Environment(\.dismiss) var dismiss
    
    let amps = ["JC-120", "Deluxe", "Twin", "Plexi", "JCM800", "Rectifier", "VH4", "Dumble", "AC30", "5150"]
    
    let pedals = ["OD-1", "TS808", "Rat", "Big Muff", "Metal Zone", "Chorus", "Delay", "Reverb"]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("REEL GUITAR")
                    .font(.system(size: 36, weight: .black, design: .monospaced))
                    .foregroundColor(.orange)
                
                // Amp-väljare
                Picker("Amp", selection: $conductor.selectedAmp) {
                    ForEach(amps, id: \.self) { amp in
                        Text(amp).tag(amp)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 120)
                .clipped()
                
                // Pedalboard
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        ForEach(pedals, id: \.self) { pedal in
                            Button {
                                conductor.togglePedal(pedal)
                            } label: {
                                VStack {
                                    Circle()
                                        .fill(conductor.activePedals.contains(pedal) ? Color.green : Color.gray.opacity(0.6)
                                        .frame(width: 60, height: 60)
                                    Text(pedal)
                                        .foregroundColor(.white)
                                        .font(.caption)
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                // Gain / Volume / Tone rattar
                HStack(spacing: 30) {
                    VStack {
                        Text("GAIN")
                        Knob(value: $conductor.guitarGain, range: 0...100)
                    }
                    VStack {
                        Text("VOL")
                        Knob(value: $conductor.guitarVolume, range: 0...100)
                    }
                    VStack {
                        Text("TONE")
                        Knob(value: $conductor.guitarTone, range: 0...100)
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
