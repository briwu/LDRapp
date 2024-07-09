//
//  IndividualSessionView.swift
//  ScreenRivalry
//
//  Created by Brian Wu on 7/1/24.
//

import SwiftUI
import Combine

class AppStateViewModel: ObservableObject {
    @Published var isInForeground: Bool = true
}

class TimerViewModel: ObservableObject {
    @Published var timerValue: Int = 0
    var countdownDuration: Int = 0
    var timer: Timer?
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppEnteringBackground), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppEnteringForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func startTimer() {
        guard timer == nil else { return } // Prevent starting multiple timers
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.timerValue > 0 {
                self.timerValue -= 1
            } else {
                self.stopTimer()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func toggleTimer() {
        if timer == nil {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    func setCountdown(duration: Int) {
        countdownDuration = duration
        timerValue = duration
    }
    
    @objc func handleAppEnteringBackground() {
        stopTimer()
    }
    
    @objc func handleAppEnteringForeground() {
        startTimer()
    }
}


struct IndividualSessionView: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject private var timerViewModel = TimerViewModel()
    @State private var selectedDurationIndex = 0
    let countdownDurations = [5, 10, 15, 20, 25]
    
    var body: some View {
        VStack {
            Picker(selection: $selectedDurationIndex, label: Text("Select Duration")) {
                ForEach(0..<countdownDurations.count, id: \.self) { index in
                    Text("\(countdownDurations[index]) seconds")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Text("Individual Session Timer: \(timerViewModel.timerValue)")
                .font(.largeTitle)
                .padding()

            Button(action: {
                let selectedDuration = countdownDurations[selectedDurationIndex]
                timerViewModel.setCountdown(duration: selectedDuration)
                timerViewModel.toggleTimer()
            }) {
                Text(timerViewModel.timer == nil ? "Start Timer" : "Stop Timer")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .onChange(of: selectedDurationIndex) {
            let selectedDuration = countdownDurations[selectedDurationIndex]
            timerViewModel.setCountdown(duration: selectedDuration)
        }
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .active:
                break
            case .background, .inactive:
                timerViewModel.stopTimer()
            @unknown default:
                break
            }
        }
        .onAppear {
        }
    }
}

#Preview {
    IndividualSessionView()
}
