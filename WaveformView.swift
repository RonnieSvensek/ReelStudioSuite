import SwiftUI

struct WaveformView: View {
    let waveform: [Float]
    
    var body: some View {
        GeometryReader { geo in
            Path { path in
                let width = geo.size.width
                let height = geo.size.height
                let mid = height / 2
                
                guard !waveform.isEmpty else {
                    path.move(to: CGPoint(x: 0, y: mid))
                    path.addLine(to: CGPoint(x: width, y: mid))
                    return
                }
                
                let step = width / CGFloat(waveform.count)
                
                for (index, value) in waveform.enumerated() {
                    let x = CGFloat(index) * step
                    let normalized = CGFloat(value + 160) / 160 // -160 to 0 dB
                    let y = mid - (normalized * height / 2)
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(Color.cyan, lineWidth: 2)
        }
        .background(Color.black.opacity(0.3))
        .cornerRadius(8)
    }
}
