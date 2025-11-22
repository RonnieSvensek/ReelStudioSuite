import SwiftUI

struct ContentView: View {
    @StateObject private var conductor = ReelConductor()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("REEL RECORDER")
                    .font(.system(size: 42, weight: .black, design: .monospaced))
                    .foregroundColor(.orange)
                
                // Transport – stora knappar
                HStack(spacing: 40) {
                    Button("◄◄") { conductor.rewind() }
                    Button(conductor.isPlaying ? "⏸" : "▶") { conductor.playPause() }
                    Button("⏹") { conductor.stop() }
                    Button {
                        conductor.toggleRecord()
                    } label: {
                        Circle()
                            .fill(conductor.isRecording ? Color.red : Color.gray)
                            .frame(width: 90, height: 90)
                            .overlay(Text("●").font(.system(size: 50)).foregroundColor(.white))
                            .scaleEffect(conductor.isRecording ? 1.15 : 1.0)
                    }
                }
                .font(.system(size: 70))
                .foregroundColor(.white)
                
                // Spåren
                ScrollView {
                    ForEach(conductor.tracks.indices, id: \.self) { index in
                        TrackRow(trackIndex: index, conductor: conductor)
                    }
                }
                
                Spacer()
                
                // MÄSSINGSRACKET MED SPAKAR LÄNGST NER
                HStack(spacing: 30) {
                    LeverButton("TUNER", isActive: conductor.showTuner) { conductor.showTuner.toggle() }
                    .sheet(isPresented: $conductor.showTuner) { ReelTuner(conductor: conductor) }
                    
                    LeverButton("VOCAL", isActive: conductor.showVocal) { conductor.showVocal.toggle() }
                    .sheet(isPresented: $conductor.showVocal) { ReelVocal(conductor: conductor) }
                    
                    LeverButton("GUITAR", isActive: conductor.showGuitar) { conductor.showGuitar.toggle() }
                    .sheet(isPresented: $conductor.showGuitar) { ReelGuitar(conductor: conductor) }
                    
                    LeverButton("BASS", isActive: conductor.showBass) { conductor.showBass.toggle() }
                    .sheet(isPresented: $conductor.showBass) { ReelBass(conductor: conductor) }
                    
                    LeverButton("DRUMS", isActive: conductor.showDrums) { conductor.showDrums.toggle() }
                    .sheet(isPresented: $conductor.showDrums) { DrumsView(conductor: conductor) }
                    
                    LeverButton("MASTER", isActive: conductor.showMaster) { conductor.showMaster.toggle() }
                    .sheet(isPresented: $conductor.showMaster) { ReelMaster(conductor: conductor) }
                }
                .padding()
                .background(Color.black.opacity(0.8)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.brass, lineWidth: 8)
                )
            }
            .padding()
            
            // Reel AI-klocka uppe till höger
            VStack {
                HStack {
                    Spacer()
                    Button {
                        ReelAIButton()
                    }
                    .padding()
                }
                Spacer()
            }
        }
        .onAppear {
            conductor.setup()
        }
    }
}

// Liten mässingsspak-knapp
struct LeverButton: View {
    let label: String
    var isActive: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Circle()
                    .fill(isActive ? Color.green : Color.gray.opacity(0.6))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Text(label.prefix(1))
                            .foregroundColor(.white)
                            .font(.title2.bold())
                    )
                Text(label)
                    .foregroundColor(isActive ? .green : .white)
                    .font(.caption)
            }
        }
    }
}

// Reel AI-klocka
struct ReelAIButton: View {
    var body: some View {
        Button {
            // Öppnar Reel AI (vi lägger till full AI senare – nu bara placeholder)
            print("Reel AI aktiverad – säg något!")
        } label: {
            Image(systemName: "bell.fill")
                .font(.system(size: 30))
                .foregroundColor(.orange)
                .padding()
                .background(Color.black.opacity(0.8)
                .clipShape(Circle())
        }
    }
}
