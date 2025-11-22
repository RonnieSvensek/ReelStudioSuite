import SwiftUI

struct ReelVocal: View {
    @ObservedObject var conductor: ReelConductor
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("REEL VOCAL")
                    .font(.system(size: 36, weight: .black, design: .monospaced))
                    .foregroundColor(.orange)
                
                // Harmony-väljare
                Picker("Harmony", selection: $conductor.vocalHarmony) {
                    Text("Off").tag(0)
                    Text("Low").tag(1)
                    Text("+3rd").tag(2)
                    Text("+5th").tag(3)
                    Text("High").tag(4)
                    Text("Octave").tag(5)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Reverb
                HStack {
                    Text("Reverb")
                    Slider(value: $conductor.vocalReverb, in: 0...100)
                    Text("\(Int(conductor.vocalReverb))%")
                }
                .padding(.horizontal)
                
                // Delay
                HStack {
                    Text("Delay")
                    Slider(value: $conductor.vocalDelay, in: 0...100)
                    Text("\(Int(conductor.vocalDelay))%")
                }
                .padding(.horizontal)
                
                // Doubling
                Toggle("Doubling", isOn: $conductor.vocalDoubling)
                    .foregroundColor(.purple)
                    .padding(.horizontal)
                
                // Vocoder
                Toggle("Vocoder", isOn: $conductor.vocalVocoder)
                    .foregroundColor(.purple)
                    .padding(.horizontal)
                
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
