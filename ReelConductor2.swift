import Foundation
import AVFoundation
import SwiftUI

class ReelConductor: ObservableObject {
    @Published var isPlaying = false
    @Published var isRecording = false
    @Published var loopActive = false
    @Published var showDrums = false
    @Published var bpm: Double = 120
    @Published var tracks: [Track] = Array(repeating: Track(), count: 8)
    
    @Published var drumPattern: [[Bool]] = Array(repeating: Array(repeating: false, count: 16), count: 8)
    @Published var currentStep = 0
    @Published var isDrumsPlaying = false
    @Published var selectedKit = "808"
    
    private var audioEngine = AVAudioEngine()
    private var sequencerTimer: Timer?
    
    private let kits = ["808", "909", "Linn", "Acoustic"]
    
    init() {
        setupAudioSession()
    }
    
    func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetoothA2DP])
        try? session.setActive(true)
    }
    
    func toggleDrumsPlay() {
        isDrumsPlaying.toggle()
        if isDrumsPlaying {
            startSequencer()
        } else {
            sequencerTimer?.invalidate()
        }
    }
    
    func startSequencer() {
        let stepTime = 60.0 / (bpm * 4) // 16th notes
        sequencerTimer = Timer.scheduledTimer(withTimeInterval: stepTime, repeats: true) { _ in
            self.currentStep = (self.currentStep + 1) % 16
            self.triggerDrums(at: self.currentStep)
        }
    }
    
    func triggerDrums(at step: Int) {
        for row in 0..<drumPattern.count {
            if drumPattern[row][step] {
                playDrumSound(row: row)
            }
        }
    }
    
    func playDrumSound(row: Int) {
        // Här lägger vi in riktiga samples senare – nu bara tone
        let player = AVAudioPlayerNode()
        audioEngine.attach(player)
        audioEngine.connect(player, to: audioEngine.mainMixerNode, format: nil)
        player.play()
    }
    
    func toggleStep(row: Int, step: Int) {
        drumPattern[row][step].toggle()
    }
    
    func selectTrack(_ index: Int) {
        currentTrackIndex = index
    }
}
