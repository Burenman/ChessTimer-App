//
//  ContentView.swift
//  ChessTimer
//
//  Created by Viktor on 2023-11-23.
//

import SwiftUI

    struct ChessClockView: View {
        @State private var whiteTimeRemaining = 300 // 5 minutes in seconds
        @State private var blackTimeRemaining = 300
        @State private var isWhiteTurn = true
        @State private var isTimerRunning = false
        @State private var selectedTime = 5
        @State private var timer: Timer?

        let darkGreen = Color(red: 0, green: 0.5, blue: 0)
        let darkGray = Color(red: 0.1, green: 0.2, blue: 0.2)
        let navyBlue = Color(red: 0.1, green: 0.2, blue: 0.6)
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
         
         var body: some View {
             ZStack {
                 darkGray.edgesIgnoringSafeArea(.all)
                 
                 VStack {
                     VStack {
                         TimerView(timeRemaining: whiteTimeRemaining, color: darkGreen, isCurrentTurn: isWhiteTurn)
                             .onTapGesture {
                                 if isTimerRunning {
                                     isWhiteTurn = false
                                     resumeTimer()
                                     impactFeedback.impactOccurred() // Add haptic feedback
                                 } else {
                                     resumeTimer()
                                     impactFeedback.impactOccurred() // Add haptic feedback
                                 }
                             }
                             .frame(maxHeight: .infinity)
                         
                         TimerView(timeRemaining: blackTimeRemaining, color: navyBlue, isCurrentTurn: !isWhiteTurn)
                             .onTapGesture {
                                 if isTimerRunning {
                                     isWhiteTurn = true
                                     resumeTimer()
                                     impactFeedback.impactOccurred() // Add haptic feedback
                                 } else {
                                     resumeTimer()
                                     impactFeedback.impactOccurred() // Add haptic feedback
                                 }
                             }
                             .frame(maxHeight: .infinity)
                     }
                     .frame(maxWidth: .infinity)
                     
                     Spacer()
                     
                     HStack(alignment: .center) {
                         HStack {
                             Button("Start") {
                                 startGame()
                                 impactFeedback.impactOccurred() // Add haptic feedback
                             }
                             .padding(10)
                             .background(Color.white)
                             .foregroundColor(.black)
                             .cornerRadius(10)
                             
                             Button("Stop") {
                                 stopTimer()
                                 impactFeedback.impactOccurred() // Add haptic feedback
                             }
                             .padding(10)
                             .background(Color.white)
                             .foregroundColor(.black)
                             .cornerRadius(10)
                             
                             Button("Reset") {
                                 resetTimers()
                                 impactFeedback.impactOccurred() // Add haptic feedback
                             }
                             .padding(10)
                             .background(Color.white)
                             .foregroundColor(.black)
                             .cornerRadius(10)
                             
                            
                            Picker("Time", selection: $selectedTime) {
                                Text("3 minutes").tag(3)
                                Text("5 minutes").tag(5)
                                Text("10 minutes").tag(10)
                                Text("15 minutes").tag(15)
                            }
                            .pickerStyle(.automatic)
                            .padding(4)
                            .background(.white)
                            .foregroundColor(.gray)

                            .cornerRadius(10)
                            
                        }
                    }
                }
                .padding()
                .edgesIgnoringSafeArea(.bottom)
            }
        }

        func startGame() {
            whiteTimeRemaining = selectedTime * 60
            blackTimeRemaining = selectedTime * 60
            isTimerRunning = true
            isWhiteTurn = true
            startTimer()
        }

        func startTimer() {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if isWhiteTurn {
                    if whiteTimeRemaining > 0 {
                        whiteTimeRemaining -= 1
                    } else {
                        endGame(winner: "Black")
                    }
                } else {
                    if blackTimeRemaining > 0 {
                        blackTimeRemaining -= 1
                    } else {
                        endGame(winner: "White")
                    }
                }
            }
        }

        func resumeTimer() {
            isTimerRunning = true
            startTimer()
        }

        func stopTimer() {
            isTimerRunning = false
            timer?.invalidate()
        }

        func resetTimers() {
            whiteTimeRemaining = selectedTime * 60
            blackTimeRemaining = selectedTime * 60
            isWhiteTurn = true
            stopTimer()
        }

        func endGame(winner: String) {
            stopTimer()
            print("\(winner) wins!")
            // You can display an alert or update UI to show the winner
        }
    }

    struct TimerView: View {
        let timeRemaining: Int
        let color: Color
        let isCurrentTurn: Bool

        var body: some View {
            ZStack {
                color
                    .opacity(isCurrentTurn ? 1.0 : 0.3)
                    .frame(maxHeight: .infinity)
                   
                Text(timeString(time: timeRemaining))
                                
                                .font(.system(size: 45, weight: .semibold))
                                .foregroundColor(.white)
                                .opacity(isCurrentTurn ? 1.0 : 0.3)
                                .padding()
                        }
                        .cornerRadius(10)
                    }

        func timeString(time: Int) -> String {
            let minutes = time / 60
            let seconds = time % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }

    struct ChessClockView_Previews: PreviewProvider {
        static var previews: some View {
            ChessClockView()
        }
    }
