import Foundation
import SwiftUI

struct Track: Identifiable {
    let id = UUID()
    var name = ""
    var audioURL: URL?
    var isRecording = false
    var isMuted = false
    var isSoloed = false
    var volume: Float = 1.0
    var pan: Float = 0.0
    var waveform: [Float] = []
    var color = Color.blue
}

extension Track {
    mutating func toggleMute() {
        isMuted.toggle()
    }
    
    mutating func toggleSolo() {
        isSoloed.toggle()
    }
}
