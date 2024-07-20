//
//  IndividualSessionView.swift
//  ScreenRivalry
//
//  Created by Brian Wu on 7/1/24.
//

import SwiftUI
import Combine
import Firebase
import CircularSlider

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
    @State private var timerDuration: Double = 0
    @State private var timeRemaining: Double = 0
    @State private var timer: Timer?
    @State private var isTimerRunning = false
    @State private var appEnteredBackground = false
    @State private var showAlert = false
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject private var timerViewModel = TimerViewModel()
    @State private var selectedDurationIndex = 0
    let countdownDurations = [5, 10, 15, 20, 25]
    
    private var timerPublisher: Publishers.Autoconnect<Timer.TimerPublisher> {
            Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        }
    
    var body: some View {
            VStack {
                Text("Set Timer Length")
                    .font(.headline)
                
                CircularSlider(currentValue: $timerDuration,
                               minValue: 1,
                               maxValue: 60,
                               knobColor: .init(red: 0.5, green: 0.5, blue: 0.5),
                               progressLineColor: .init(red: 0.84, green: 0.93, blue: 0.09),
                               font: .custom("HelveticaNeue-Light", size: 35),
                               backgroundColor: .yellow.opacity(0.09),
                               currentValueSuffix: " min")
                
                Text("\(Int(timerDuration)) minutes")
                    .font(.largeTitle)
                
                Button(action: startTimer) {
                    Text(isTimerRunning ? "Restart Timer" : "Start Timer")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                if isTimerRunning {
                    Text("Time Remaining: \(Int(timeRemaining)) seconds")
                        .font(.largeTitle)
                }
            }
            .onChange(of: scenePhase) {
                if scenePhase == .background {
                    appEnteredBackground = true
                    isTimerRunning = false // Stop the timer if the app goes to the background
                } else if scenePhase == .active && !isTimerRunning {
                    // Optional: Handle returning to the foreground if needed
                }
            }
            .onReceive(timerPublisher) { _ in
                guard isTimerRunning else { return }
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    timerDidFinish()
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Congratulations!"), message: Text("You have successfully completed your session."), dismissButton: .default(Text("OK")))
            }
        }
    
    private func startTimer() {
        timeRemaining = timerDuration * 60
        isTimerRunning = true
        appEnteredBackground = false
    }
        
    private func timerDidFinish() {
        isTimerRunning = false
        if !appEnteredBackground {
            rewardUserWithCoins()
            showAlert = true
        } else {
            print("Timer failed because the app entered the background.")
        }
    }
    
    private func rewardUserWithCoins() {
        guard let currentUser = viewModel.currentUser else { return }
        let userRef = Firestore.firestore().collection("users").document(currentUser.id)
        
        userRef.updateData(["coins": FieldValue.increment(Int64(10))]) { error in
            if let error = error {
                print("Error updating coins: \(error.localizedDescription)")
            } else {
                print("User rewarded with 10 coins!")
            }
        }
    }
}

#Preview {
    IndividualSessionView()
        .environmentObject(AuthViewModel())
}
