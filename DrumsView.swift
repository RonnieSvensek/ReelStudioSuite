import SwiftUI

struct DrumsView: View {
    @ObservedObject var conductor: ReelConductor
    @Environment(\.dismiss) var dismiss
    
    let kits = ["808", "909", "Linn", "Acoustic"]
    let sounds = ["Kick", "Snare", "Clap", "HiHat", "OpenHat", "Perc", "Crash", "Tom"]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("REEL DRUMS")
                    .font(.system(size: 36, weight: .black, design: .monospaced))
                    .foregroundColor(.orange)
                
                // Kit-väljare
                Picker("Kit", selection: $conductor.selectedKit) {
                    ForEach(kits, id: \.self) { kit in
                        Text(kit).tag(kit)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // BPM
                HStack {
                    Text("BPM")
                    Slider(value: $conductor.bpm, in: 60...200, step: 1)
                        .tint(.purple)
                    Text("\(Int(conductor.bpm))")
                        .frame(width: 60)
                }
                .padding(.horizontal)
                
                // Step sequencer
                ForEach(0..<sounds.count, id: \.self) { row in
                    HStack {
                        Text(sounds[row])
                            .foregroundColor(.orange)
                            .frame(width: 80)
                        
                        ForEach(0..<16) { step in
                            Button {
                                conductor.toggleStep(row: row, step: step)
                            } label: {
                                Circle()
                                    .fill(conductor.drumPattern[row][step] ? Color.red : Color.gray.opacity(0.4))
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                        conductor.currentStep == step && conductor.isDrumsPlaying ?
                                        Circle().stroke(Color.white, lineWidth: 3) : nil
                                    )
                            }
                        }
                    }
                }
                
                // Play/Stop för trummor
                Button(conductor.isDrumsPlaying ? "STOP DRUMS" : "PLAY DRUMS") {
                    conductor.toggleDrumsPlay()
                }
                .font(.title2)
                .padding()
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(16)
                
                Button("STÄNG") {
                    dismiss()
                }
                .foregroundColor(.gray)
            }
            .padding()
        }
    }
}
