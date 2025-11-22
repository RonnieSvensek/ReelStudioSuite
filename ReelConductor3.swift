import AudioKit
import AVFoundation
import SwiftUI

public class ReelConductor: ObservableObject {
    public static let shared = ReelConductor()
    
    // MARK: - Audio Engine
    private let engine = AudioEngine()
    private let mainMixer = Mixer(name: "MainMixer")
    private let inputMixer = Mixer(name: "InputMixer")
    private let mic = Microphone()
    private var inputBooster: Booster?
    private var monitoringFader: Fader?
    private var recorder: NodeRecorder?
    
    // Tracks
    @Published public var tracks: [Track] = []
    private var trackFaders: [Fader] = []
    private var trackPanners: [StereoPanner] = [] // För pan senare
    
    // State
    @Published public var isMonitoring = true
    @Published public var inputGain: Double = 2.0 {
        didSet { inputBooster?.gain = inputGain }
    }
    
    public struct Track {
        public let player: Player
        public let fader: Fader
        public let panner: StereoPanner
        public let audioFile: AVAudioFile // sparas för export senare
    }
    
    private init() {
        // Input chain: mic → booster (gain) → monitoring fader → mainMixer
        inputBooster = Booster(mic, gain: inputGain)
        monitoringFader = Fader(inputBooster!, gain: isMonitoring ? 1.0 : 0.0)
        
        inputMixer.addInput(monitoringFader!)
        mainMixer.addInput(inputMixer)
        
        engine.output = mainMixer
        
        do {
            try engine.start()
            print("🎧 ReelStudioSuite engine started – latency ≈ \(AVAudioSession.sharedInstance().ioBufferDuration * 1000) ms")
        } catch {
            print("AudioKit startade inte: \(error)")
        }
    }
    
    // MARK: - Monitoring
    public func toggleMonitoring(_ on: Bool) {
        isMonitoring = on
        monitoringFader?.gain = on ? 1.0 : 0.0
    }
    
    // MARK: - Recording
    public func startRecording() throws {
        guard recorder == nil else { return }
        recorder = try NodeRecorder(node: mic) // recordar torr signal (före effekter om du vill)
        try recorder?.record()
    }
    
    public func stopRecording() {
        guard let rec = recorder else { return }
        rec.stop()
        
        let recordedFile = rec.audioFile!
        
        // AudioKit kompenserar latency automatiskt här, men vi trimmar lite säkerhetsmarginal ändå
        try? recordedFile.trim(from: 0.0, to: recordedFile.duration - 0.015)
        
        let player = Player(audioFile: recordedFile)
        player.completionHandler = { [weak player] in
            player?.stop()
        }
        
        let trackFader = Fader(player, gain: 1.0)
        let trackPanner = StereoPanner(trackFader, pan: 0.0)
        
        mainMixer.addInput(trackPanner)
        
        let newTrack = Track(player: player, fader: trackFader, panner: trackPanner, audioFile: recordedFile)
        tracks.append(newTrack)
        
        recorder = nil
        
        print("Ny spår tillagt – totalt \(tracks.count) spår")
    }
    
    // MARK: - Playback
    public func playAll() {
        for track in tracks {
            track.player.play()
        }
    }
    
    public func stopAll() {
        for track in tracks {
            track.player.stop()
        }
    }
    
    // MARK: - Track control (används från UI senare)
    public func setVolume(for trackIndex: Int, volume: Double) {
        guard trackIndex < trackFaders.count else { return }
        trackFaders[trackIndex].gain = volume
    }
    
    public func setPan(for trackIndex: Int, pan: Double) {
        guard trackIndex < trackPanners.count else { return }
        trackPanners[trackIndex].pan = pan
    }
}
