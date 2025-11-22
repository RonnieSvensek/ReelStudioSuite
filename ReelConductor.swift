import Foundation
import AVFoundation
import SwiftUI
import Combine

class ReelConductor: ObservableObject {
    @Published var isPlaying = false
    @Published var isRecording = false
    @Published var loopActive = false
    @Published var showDrums = false
    @Published var bpm: Double = 120
    @Published var tracks: [Track] = Array(repeating: Track(), count: 8)
    
    private var audioEngine = AVAudioEngine()
    private var mixer = AVAudioMixerNode()
    private var playerNodes: [AVAudioPlayerNode] = []
    private var recorder: AVAudioRecorder?
    private var currentTrackIndex = 0
    
    init() {
        setupAudioEngine()
    }
    
    func setupAudioEngine() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetoothA2DP, .allowAirPlay])
        try? session.setActive(true)
        
        audioEngine.attach(mixer)
        audioEngine.connect(mixer, to: audioEngine.mainMixerNode, format: nil)
        
        for _ in 0..<tracks.count {
            let player = AVAudioPlayerNode()
            audioEngine.attach(player)
            audioEngine.connect(player, to: mixer, format: nil)
            playerNodes.append(player)
        }
        
        try? audioEngine.start()
    }
    
    func playPause() {
        isPlaying.toggle()
        if isPlaying {
            playerNodes.forEach { $0.play() }
        } else {
            playerNodes.forEach { $0.pause() }
        }
    }
    
    func stop() {
        isPlaying = false
        playerNodes.forEach { $0.stop() }
    }
    
    func rewind() {
        stop()
        // TODO: gå till början
    }
    
    func toggleRecord() {
        isRecording.toggle()
        if isRecording {
            startRecording(on: currentTrackIndex)
        } else {
            stopRecording()
        }
    }
    
    private func startRecording(on index: Int) {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("track_\(index)_\(Date().timeIntervalSince1970).m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 48000,
            AVNumberOfChannelsKey: 2,
            AVEncoderBitRateKey: 192000
        ] as [String : Any]
        
        recorder = try? AVAudioRecorder(url: url, settings: settings)
        recorder?.record()
        tracks[index].isRecording = true
        tracks[index].audioURL = url
    }
    
    private func stopRecording() {
        recorder?.stop()
        isRecording = false
        loadTracks()
    }
    
    private func loadTracks() {
        for (index, track) in tracks.enumerated() {
            if let url = track.audioURL, FileManager.default.fileExists(atPath: url.path) {
                let file = try? AVAudioFile(forReading: url)
                playerNodes[index].scheduleFile(file!, at: nil)
            }
        }
    }
    }
    
    func selectTrack(_ index: Int) {
        currentTrackIndex = index
    }
}
