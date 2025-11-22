import SwiftUI

struct ReelMixer: View {
    @ObservedObject var conductor: ReelConductor
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("REEL MIXER")
                    .font(.system(size: 36, weight: .black, design: .monospaced))
                    .foregroundColor(.orange)
                
                ScrollView {
                    ForEach(conductor.tracks.indices, id: \.self) { index in
                        let binding = $conductor.tracks[index]
                        
                        HStack(spacing: 20) {
                            Text("Spår \(index + 1)")
                                .foregroundColor(.white)
                                .frame(width: 80)
                            
                            // Volymratt
                            VStack {
                                Text("VOL")
                                Knob(value: binding.volume, range: 0...1.5)
                                    .frame(width: 60, height: 60)
                                Text("\(Int(binding.volume.wrappedValue * 100))%")
                                    .foregroundColor(.orange)
                                    .font(.caption)
                            }
                            
                            // Pan-ratt
                            VStack {
                                Text("PAN")
                                Knob(value: binding.pan, range: -1...1)
                                    .frame(width: 60, height: 60)
                                Text(binding.pan.wrappedValue == 0 ? "C" : binding.pan.wrappedValue > 0 ? "R" : "L")
                                    .foregroundColor(.orange)
                                    .font(.caption)
                            }
                            
                            // EQ (3-band)
                            HStack(spacing: 12) {
                                VStack {
                                    Text("LOW")
                                    Knob(value: binding.lowEQ, range: -12...12)
                                        .frame(width: 40, height: 40)
                                    Text("\(Int(binding.lowEQ.wrappedValue)) dB")
                                        .font(.caption2)
                                }
                                VStack {
                                    Text("MID")
                                    Knob(value: binding.midEQ, range: -12...12)
                                        .frame(width: 40, height: 40)
                                    Text("\(Int(binding.midEQ.wrappedValue)) dB")
                                        .font(.caption2)
                                }
                                VStack {
                                    Text("HIGH")
                                    Knob(value: binding.highEQ, range: -12...12)
                                        .frame(width: 40, height: 40)
                                    Text("\(Int(binding.highEQ.wrappedValue)) dB")
                                        .font(.caption2)
                                }
                            }
                            
                            // Mute/Solo
                            HStack(spacing: 12) {
                                Button {
                                    binding.wrappedValue.toggleMute()
                                } label: {
                                    Text("M")
                                        .foregroundColor(binding.wrappedValue.isMuted ? .gray : .white)
                                        .frame(width: 40, height: 40)
                                        .background(Color.black.opacity(0.5))
                                        .cornerRadius(8)
                                }
                                
                                Button {
                                    binding.wrappedValue.toggleSolo()
                                } label: {
                                    Text("S")
                                        .foregroundColor(binding.wrappedValue.isSoloed ? .yellow : .white)
                                        .frame(width: 40, height: 40)
                                        .background(Color.black.opacity(0.5))
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.brass.opacity(0.6), lineWidth: 2)
                        )
                    }
                }
                
                Spacer()
                
                Button("STÄNG MIXER") {
                    dismiss()
                }
                .foregroundColor(.gray)
                .padding()
            }
            .padding()
        }
    }
}

