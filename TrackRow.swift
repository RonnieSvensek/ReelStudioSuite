import SwiftUI

struct TrackRow: View {
    let trackIndex: Int
    @ObservedObject var conductor: ReelConductor
    
    private var track: Track {
        conductor.tracks[trackIndex]
    }
    
    var body: some View {
        HStack(spacing: 20) {
            Button(track.isRecording ? "● REC" : "REC") {
                conductor.selectTrack(trackIndex)
                conductor.toggleRecord()
            }
            .foregroundColor(track.isRecording ? .red : .white)
            .font(.title2.bold())
            .frame(width: 80, height: 50)
            .background(Color.black.opacity(0.5))
            .cornerRadius(12)
            
            VStack(alignment: .leading) {
                Text("Spår \(trackIndex + 1)")
                    .foregroundColor(.white)
                    .font(.headline)
                
                WaveformView(waveform: track.waveform)
                    .frame(height: 60)
            }
            
            Spacer()
            
            Button(track.isMuted ? "M" : "M") {
                conductor.tracks[trackIndex].toggleMute()
            }
            .foregroundColor(track.isMuted ? .gray : .white)
            
            Button(track.isSoloed ? "S" : "S") {
                conductor.tracks[trackIndex].toggleSolo()
            }
            .foregroundColor(track.isSoloed ? .yellow : .white)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(16)
    }
}
