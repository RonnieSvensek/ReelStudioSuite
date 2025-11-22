import SwiftUI

struct TrackRow: View {
    let trackIndex: Int
    @ObservedObject var conductor: ReelConductor
    
    private var track: Binding<Track> {
        $conductor.tracks[trackIndex]
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // REC-knapp
            Button {
                conductor.selectTrack(trackIndex)
                conductor.toggleRecord()
            } label: {
                Circle()
                    .fill(track.wrappedValue.isRecording ? Color.red : Color.gray.opacity(0.6))
                    .frame(width: 60, height: 60)
                    .overlay(Text("REC").foregroundColor(.white).font(.caption.bold()))
            }
            
            // Waveform
            WaveformView(waveform: track.wrappedValue.waveform)
                .frame(height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Pan-ratt (ny!)
            VStack {
                Text("PAN")
                    .foregroundColor(.orange)
                    .font(.caption2.bold())
                Knob(value: track.pan, range: -1...1) {
                    Circle()
                        .fill(Color.black.opacity(0.8))
                        .overlay(
                            Circle()
                                .stroke(Color.brass, lineWidth: 6)
                                .overlay(
                                    LineIndicator(angle: Angle(degrees: Double(track.wrappedValue.pan.wrappedValue * 90))))
                                .rotationEffect(Angle(degrees: -135))
                        )
                }
                .frame(width: 60, height: 60)
                Text(track.wrappedValue.pan.wrappedValue == 0 ? "C" : track.wrappedValue.pan.wrappedValue > 0 ? "R" : "L")
                    .foregroundColor(.orange)
            }
            
            // Mute/Solo
            HStack(spacing: 12) {
                Button {
                    track.wrappedValue.toggleMute()
                } label: {
                    Text("M")
                        .foregroundColor(track.wrappedValue.isMuted ? .gray : .white)
                        .frame(width: 40, height: 40)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(8)
                }
                
                Button {
                    track.wrappedValue.toggleSolo()
                } label: {
                    Text("S")
                        .foregroundColor(track.wrappedValue.isSoloed ? .yellow : .white)
                        .frame(width: 40, height: 40)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.brass.opacity(0.6), lineWidth: 2)
        )
    }
}

// Liten helper för linjen i ratten
struct LineIndicator: View {
    let angle: Angle
    
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 30, y: 30))
            path.addLine(to: CGPoint(x: 30 + 20 * cos(angle.radians - .pi/2), y: 30 + 20 * sin(angle.radians - .pi/2)))
        }
        .stroke(Color.yellow, lineWidth: 3)
    }
}

// Extension för brass-färg
extension Color {
    static let brass = Color(red: 0.8, green: 0.6, blue: 0.3)
}

// Knob-view (enkel, vacker ratt)
struct Knob: View {
    @Binding var value: Float
    let range: ClosedRange<Float>
    var onChanged: () -> Void = {}
    
    var body: some View {
        KnobShape(value: value, range: range)
            .fill(Color.black.opacity(0.8))
            .background(Circle().stroke(Color.brass, lineWidth: 6))
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        let delta = Float(gesture.translation.height) * -0.01
                        value = max(range.lowerBound, min(range.upperBound, value + delta))
                        onChanged()
                    }
            )
    }
}

struct KnobShape: Shape {
    var value: Float
    let range: ClosedRange<Float>
    
    var animatableData: Float {
        get { value }
        set { value = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let startAngle = Angle(degrees: 135)
        let endAngle = Angle(degrees: 405)
        let currentAngle = Angle(degrees: 135 + Double((value - range.lowerBound) / (range.upperBound - range.lowerBound) * 270))
        
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: currentAngle, clockwise: false)
        path.addLine(to: center)
        path.closeSubpath()
        
        return path
    }
}
