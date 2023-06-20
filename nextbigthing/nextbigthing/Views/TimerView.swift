//
//  TimerView.swift
//  nextbigthing
//
//  Created by Daniel Heffron and Sash Sujith on 4/6/23.
//

import SwiftUI

final class ViewModel: ObservableObject {
        @Published var isActive = false
        @Published var showingAlert = false
        @Published var time: String = "5:00"
        @Published var minutes: Float = 5.0 {
            didSet {
                if seconds < 10 {
                    self.time = "\(Int(minutes)):0\(Int(seconds))"
                }
                else {
                    self.time = "\(Int(minutes)):\(Int(seconds))"
                }
            }
        }
        @Published var seconds: Float = 0.0 {
            didSet {
                if seconds < 10 {
                    self.time = "\(Int(minutes)):0\(Int(seconds))"
                }
                else {
                    self.time = "\(Int(minutes)):\(Int(seconds))"
                }
            }
        }
        
        private var initialTime = 0
        private var endDate = Date()
        
        // Start the timer with the given amount of minutes
        func start(minutes: Float, seconds: Float) {
            self.initialTime = (60 * Int(minutes)) + Int(seconds)
            self.endDate = Date()
            self.isActive = true
            self.endDate = Calendar.current.date(byAdding: .second, value: initialTime, to: endDate)!
        }
        
        // Reset the timer
        func reset() {
            self.minutes = Float(initialTime / 60)
            self.seconds = Float(initialTime).truncatingRemainder(dividingBy: 60)
            self.isActive = false
            if seconds < 10 {
                self.time = "\(Int(minutes)):0\(Int(seconds))"
            }
            else {
                self.time = "\(Int(minutes)):\(Int(seconds))"
            }
        }
        
        // Show updates of the timer
        func updateCountdown(){
            guard isActive else { return }
            
            // Gets the current date and makes the time difference calculation
            let now = Date()
            let diff = endDate.timeIntervalSince1970 - now.timeIntervalSince1970
            
            // Checks that the countdown is not <= 0
            if diff <= 0 {
                self.isActive = false
                self.time = "0:00"
                self.showingAlert = true
                return
            }
            
            // Turns the time difference calculation into sensible data and formats it
            let date = Date(timeIntervalSince1970: diff)
            let calendar = Calendar.current
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)

            // Updates the time string with the formatted time
            self.time = String(format:"%d:%02d", minutes, seconds)
        }
    }

struct TimerView: View {
    @StateObject private var vm = ViewModel()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let width: Double = 250
    
    var body: some View {
        VStack {
            Text("\(vm.time)")
                .font(.system(size: 70, weight: .medium, design: .rounded))
                .foregroundColor(.white)
                .alert("Timer done!", isPresented: $vm.showingAlert) {
                    Button("Continue", role: .cancel) {
                        // Code
                    }
                }
                .padding()
                .frame(width: width)
                .background(.thinMaterial)
                .cornerRadius(20)
                .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.red, lineWidth: 4)
                ).background(RoundedRectangle(cornerRadius: 40).fill(Color.black))
            
            HStack {
                Text("Min")
                Slider(value: $vm.minutes, in: 0...10, step: 1)
                    .disabled(vm.isActive)
                    .animation(.easeInOut, value: vm.minutes)
                    .frame(width: width)
            }
            
            HStack {
                Text("Sec")
                Slider(value: $vm.seconds, in: 0...59, step: 1)
                    .disabled(vm.isActive)
                    .animation(.easeInOut, value: vm.seconds)
                    .frame(width: width)
            }

            HStack(spacing:50) {
                Button("Start") {
                    vm.start(minutes: vm.minutes, seconds: vm.seconds)
                }
                .disabled(vm.isActive)
                
                Button("Reset", action: vm.reset)
                    .tint(.red)
            }
            .frame(width: width)
        }
        .onReceive(timer) { _ in
            vm.updateCountdown()
        }
        
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
