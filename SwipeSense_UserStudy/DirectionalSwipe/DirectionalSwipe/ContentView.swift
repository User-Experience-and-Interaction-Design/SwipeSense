//
////
////  ContentView.swift
////  DirectionalSwipe
////
////  Created by Neel Shah on 2024-11-12.
////
//
//import SwiftUI
//import UIKit
//import CoreMotion
//import Network
//
//// MARK: - SwipeData Structure
//
//struct SwipeData: Identifiable {
//    let id = UUID()
//    let accelX: Double
//    let accelY: Double
//    let accelZ: Double
//    let gyroX: Double
//    let gyroY: Double
//    let gyroZ: Double
//    let iteration: Int
//    let label: String
//    let timestamp: Date
//    let relativeTime: Double // New field for relative time
//}
//
//// MARK: - SensorDataManager Class
//
//class SensorDataManager: ObservableObject {
//    private let motionManager = CMMotionManager()
//    var sensorTimer: Timer?
//    
//    @Published var accelerometerData: CMAcceleration?
//    @Published var gyroscopeData: CMRotationRate?
//    @Published var swipeLabel: String? = "0" // Default to "0" when no swipe is active
//    @Published var currentIteration: Int = 0 // Default to 0 when no swipe is active
//    @Published var isRunning: Bool = false
//    
//    func startSensors() {
//        if motionManager.isAccelerometerAvailable && motionManager.isGyroAvailable {
//            motionManager.startAccelerometerUpdates()
//            motionManager.startGyroUpdates()
//            
//            sensorTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
//                guard let self = self else { return }
//                
//                if let accelData = self.motionManager.accelerometerData, let gyroData = self.motionManager.gyroData {
//                    self.accelerometerData = accelData.acceleration
//                    self.gyroscopeData = gyroData.rotationRate
//                    
//                    // Check if a swipe is active; if not, set iteration and label to "0"
//                    let label = self.swipeLabel ?? "0"
//                    let iteration = label == "0" ? 0 : self.currentIteration
//                    
//                    // Log data with updated values
//                    let timestamp = Date().timeIntervalSince1970
//                    let formattedData = String(format: "AccelX: %.4f, AccelY: %.4f, AccelZ: %.4f, GyroX: %.4f, GyroY: %.4f, GyroZ: %.4f, Iteration: %d, Label: %@, TimeStamp: %.4f",
//                                               accelData.acceleration.x, accelData.acceleration.y, accelData.acceleration.z,
//                                               gyroData.rotationRate.x, gyroData.rotationRate.y, gyroData.rotationRate.z,
//                                               iteration,
//                                               label,
//                                               timestamp)
//                    print(formattedData)
//                }
//            }
//        }
//    }
//    
//    func stopSensors() {
//        motionManager.stopAccelerometerUpdates()
//        motionManager.stopGyroUpdates()
//        sensorTimer?.invalidate()
//        sensorTimer = nil
//    }
//    
//    func startSwipe(with label: String, iteration: Int) {
//        swipeLabel = label
//        currentIteration = iteration
//    }
//    
//    func stopSwipe() {
//        swipeLabel = "0" // Set to "0" or nil if you prefer to indicate no active swipe
//        currentIteration = 0
//    }
//}
//
//// MARK: - SwipeDirection Enumeration
//
///// Includes directions for both Condition 1 and Condition 2.
//enum SwipeDirection: String, CaseIterable {
//    // Condition 1 directions
//    case leftToRight = "Arrow_LR"
//    case rightToLeft = "Arrow_RL"
//    case bottomToTop = "Arrow_BT"
//    case topToBottom = "Arrow_TB"
//    
//    // Condition 2 directions
//    case bottomLeftToTopRight = "Arrow_BLTR"
//    case bottomRightToTopLeft = "Arrow_BRTL"
//    case topLeftToBottomRight = "Arrow_TLBR"
//    case topRightToBottomLeft = "Arrow_TRBL"
//    
//    var imageName: String {
//        return self.rawValue
//    }
//    
//    var label: String {
//        switch self {
//        // Condition 1
//        case .leftToRight: return "Left to Right"
//        case .rightToLeft: return "Right to Left"
//        case .bottomToTop: return "Bottom to Top"
//        case .topToBottom: return "Top to Bottom"
//            
//        // Condition 2
//        case .bottomLeftToTopRight: return "Bottom Left to Top Right"
//        case .bottomRightToTopLeft: return "Bottom Right to Top Left"
//        case .topLeftToBottomRight: return "Top Left to Bottom Right"
//        case .topRightToBottomLeft: return "Top Right to Bottom Left"
//        }
//    }
//}
//
//// MARK: - ContentView
//
//struct ContentView: View {
//    @StateObject private var sensorDataManager = SensorDataManager()
//    @State private var condition = 1 // Set to 1 or 2 to determine swipe condition
//    @State private var maxTrials = 200 // Set to the desired trial limit
//    @State private var currentTrial = 0
//    @State private var showSwipeArrow = false
//    @State private var swipeDirection: SwipeDirection = .bottomLeftToTopRight // Initialize with a default
//    @State private var swipeDataArray: [SwipeData] = [] // Store each sensor data entry
//    @State private var startTime: Date? = nil // Track the start time for relative time calculation
//    @State private var startTimestamp: TimeInterval? = nil // Track the timestamp of the first data point in seconds since the epoch
//    private let webSocketServer = WebSocketServer() // Reference your actual WebSocketServer class
//    
//    var body: some View {
//        ZStack {
//            // Set the background color to white and ignore safe areas
//            Color.white
//                .ignoresSafeArea()
//            
//            VStack {
//                if !sensorDataManager.isRunning {
//                    Button(action: startBlock) {
//                        Text("Start the Block")
//                            .font(.largeTitle)
//                            .padding()
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                } else {
//                    // ------------------------------------------------
//                    // CONDITION 1 (Use Arrow Images just like Condition 2)
//                    // ------------------------------------------------
//                    if condition == 1 {
//                        if showSwipeArrow {
//                            Image(swipeDirection.imageName)
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 200, height: 200) // Adjust size as needed
//                                .onTapGesture {
//                                    if showSwipeArrow {
//                                        stopSwipe()
//                                    } else {
//                                        startSwipe()
//                                    }
//                                }
//                                .accessibilityLabel("Swipe \(swipeDirection.label)")
//                        } else {
//                            Text("Press 'space' to start")
//                                .font(.largeTitle)
//                                .foregroundColor(.gray)
//                                .onTapGesture {
//                                    if showSwipeArrow {
//                                        stopSwipe()
//                                    } else {
//                                        startSwipe()
//                                    }
//                                }
//                        }
//                    }
//                    // ------------------------------------------------
//                    // CONDITION 2 (Existing Arrow Images)
//                    // ------------------------------------------------
//                    else {
//                        if showSwipeArrow {
//                            Image(swipeDirection.imageName)
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 200, height: 200) // Adjust size as needed
//                                .onTapGesture {
//                                    if showSwipeArrow {
//                                        stopSwipe()
//                                    } else {
//                                        startSwipe()
//                                    }
//                                }
//                                .accessibilityLabel("Swipe \(swipeDirection.label)")
//                        } else {
//                            Text("Press 'space' to start")
//                                .font(.largeTitle)
//                                .foregroundColor(.gray)
//                                .onTapGesture {
//                                    if showSwipeArrow {
//                                        stopSwipe()
//                                    } else {
//                                        startSwipe()
//                                    }
//                                }
//                        }
//                    }
//                }
//            }
//        }
//        .onAppear {
//            sensorDataManager.isRunning = false
//            webSocketServer.startServer()
//            webSocketServer.onToggleSwipe = { toggleSwipeState() }
//            
//            // Start a separate timer to collect data in real time
//            sensorDataManager.sensorTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
//                // Check if sensor data is available and start collecting only after the first valid reading
//                if let accelData = sensorDataManager.accelerometerData,
//                   let gyroData = sensorDataManager.gyroscopeData {
//                    
//                    let timestamp = Date().timeIntervalSince1970 // Current timestamp in seconds
//                    
//                    // Set startTimestamp only once at the moment of the first valid sensor reading
//                    if startTimestamp == nil {
//                        startTimestamp = timestamp
//                    }
//                    
//                    // Calculate relativeTime using startTimestamp
//                    let relativeTime = timestamp - (startTimestamp ?? timestamp)
//                    
//                    // Format timestamp to EST
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.timeZone = TimeZone(identifier: "America/Toronto") // EST Time Zone
//                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                    let estTimestamp = dateFormatter.string(from: Date(timeIntervalSince1970: timestamp))
//                    
//                    let data = SwipeData(
//                        accelX: accelData.x,
//                        accelY: accelData.y,
//                        accelZ: accelData.z,
//                        gyroX: gyroData.x,
//                        gyroY: gyroData.y,
//                        gyroZ: gyroData.z,
//                        iteration: sensorDataManager.currentIteration,
//                        label: sensorDataManager.swipeLabel ?? "0",
//                        timestamp: Date(timeIntervalSince1970: timestamp), // Original timestamp as Date
//                        relativeTime: relativeTime
//                    )
//                    swipeDataArray.append(data)
//                    print(data) // Log to console to verify
//                }
//            }
//        }
//        .onDisappear {
//            stopDataCollection() // Ensure data collection stops when view disappears
//            exportDataToCSV()    // Export to CSV upon exit
//            webSocketServer.stopServer()
//        }
//    }
//    
//    // MARK: - Helper Functions
//    
//    private func toggleSwipeState() {
//        if sensorDataManager.isRunning {
//            if showSwipeArrow {
//                stopSwipe()
//            } else {
//                startSwipe()
//            }
//        }
//    }
//
//    private func startBlock() {
//        sensorDataManager.isRunning = true
//        currentTrial = 0
//        print("Block started. Condition: \(condition), Max Trials: \(maxTrials)")
//        sensorDataManager.startSensors()
//        nextSwipe()
//    }
//    
//    private func nextSwipe() {
//        if currentTrial >= maxTrials {
//            stopDataCollection() // Stop data collection when trials complete
//            exportDataToCSV()    // Export data when session ends
//            print("Block completed.")
//            return
//        }
//        
//        showSwipeArrow = false
//        sensorDataManager.stopSwipe()
//        
//        swipeDirection = selectSwipeDirection()
//        print("Next Swipe: \(swipeDirection.label), Trial: \(currentTrial + 1)")
//    }
//    
//    // Randomly choose from condition-specific directions
//    private func selectSwipeDirection() -> SwipeDirection {
//        // Condition 1 directions
//        let condition1Directions: [SwipeDirection] = [.leftToRight, .rightToLeft, .bottomToTop, .topToBottom]
//        // Condition 2 directions
//        let condition2Directions: [SwipeDirection] = [.bottomLeftToTopRight, .bottomRightToTopLeft, .topLeftToBottomRight, .topRightToBottomLeft]
//        
//        if condition == 1 {
//            return condition1Directions.randomElement()!
//        } else {
//            return condition2Directions.randomElement()!
//        }
//    }
//    
//    private func startSwipe() {
//        sensorDataManager.startSwipe(with: swipeDirection.label, iteration: currentTrial + 1)
//        showSwipeArrow = true
//        print("Swipe started: \(sensorDataManager.swipeLabel ?? "0")")
//    }
//    
//    private func stopSwipe() {
//        print("Swipe ended: \(sensorDataManager.swipeLabel ?? "0")")
//        
//        sensorDataManager.stopSwipe()
//        showSwipeArrow = false
//        
//        // Increment `currentTrial` after stopping each swipe
//        currentTrial += 1
//        nextSwipe()
//    }
//    
//    private func stopDataCollection() {
//        sensorDataManager.stopSensors()
//        sensorDataManager.sensorTimer?.invalidate()
//        sensorDataManager.sensorTimer = nil
//        sensorDataManager.isRunning = false
//    }
//    
//    private func exportDataToCSV() {
//        let fileName = "SwipeData.csv"
//        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
//        
//        var csvText = "AccelX,AccelY,AccelZ,GyroX,GyroY,GyroZ,Iteration,Label,Timestamp,RelativeTime\n"
//        
//        // DateFormatter for EST
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(identifier: "America/Toronto") // EST Time Zone
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        
//        for data in swipeDataArray {
//            let estTimestamp = dateFormatter.string(from: data.timestamp)
//            let row = "\(data.accelX),\(data.accelY),\(data.accelZ),\(data.gyroX),\(data.gyroY),\(data.gyroZ),\(data.iteration),\(data.label),\(estTimestamp),\(data.relativeTime)\n"
//            csvText.append(row)
//        }
//        
//        do {
//            try csvText.write(to: path, atomically: true, encoding: .utf8)
//            print("CSV file saved successfully at \(path)")
//        } catch {
//            print("Failed to save CSV file: \(error.localizedDescription)")
//        }
//    }
//}
//
//  ContentView.swift
//  DirectionalSwipe
//
//  Created by Neel Shah on 2024-11-12.
//

import SwiftUI
import UIKit
import CoreMotion
import Network

// MARK: - SwipeData Structure

struct SwipeData: Identifiable {
    let id = UUID()
    let accelX: Double
    let accelY: Double
    let accelZ: Double
    let gyroX: Double
    let gyroY: Double
    let gyroZ: Double
    let iteration: Int
    let label: String
    let timestamp: Date
    let relativeTime: Double
}

// MARK: - SensorDataManager Class

class SensorDataManager: ObservableObject {
    private let motionManager = CMMotionManager()
    var sensorTimer: Timer?
    
    @Published var accelerometerData: CMAcceleration?
    @Published var gyroscopeData: CMRotationRate?
    @Published var swipeLabel: String? = "0"
    @Published var currentIteration: Int = 0
    @Published var isRunning: Bool = false
    
    func startSensors() {
        if motionManager.isAccelerometerAvailable && motionManager.isGyroAvailable {
            motionManager.startAccelerometerUpdates()
            motionManager.startGyroUpdates()
            
            sensorTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                
                if let accelData = self.motionManager.accelerometerData,
                   let gyroData = self.motionManager.gyroData {
                    
                    self.accelerometerData = accelData.acceleration
                    self.gyroscopeData = gyroData.rotationRate
                    
                    // Check if a swipe is active; if not, set iteration and label to "0"
                    let label = self.swipeLabel ?? "0"
                    let iteration = label == "0" ? 0 : self.currentIteration
                    
                    // Log data with updated values
                    let timestamp = Date().timeIntervalSince1970
                    let formattedData = String(
                        format: "AccelX: %.4f, AccelY: %.4f, AccelZ: %.4f, GyroX: %.4f, GyroY: %.4f, GyroZ: %.4f, Iteration: %d, Label: %@, TimeStamp: %.4f",
                        accelData.acceleration.x,
                        accelData.acceleration.y,
                        accelData.acceleration.z,
                        gyroData.rotationRate.x,
                        gyroData.rotationRate.y,
                        gyroData.rotationRate.z,
                        iteration,
                        label,
                        timestamp
                    )
                    print(formattedData)
                }
            }
        }
    }
    
    func stopSensors() {
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        sensorTimer?.invalidate()
        sensorTimer = nil
    }
    
    func startSwipe(with label: String, iteration: Int) {
        swipeLabel = label
        currentIteration = iteration
    }
    
    func stopSwipe() {
        swipeLabel = "0"
        currentIteration = 0
    }
}

// MARK: - SwipeDirection Enumeration

enum SwipeDirection: String, CaseIterable {
    // Condition 1 directions
    case leftToRight = "Arrow_LR"
    case rightToLeft = "Arrow_RL"
    case bottomToTop = "Arrow_BT"
    case topToBottom = "Arrow_TB"
    
    // Condition 2 directions
    case bottomLeftToTopRight = "Arrow_BLTR"
    case bottomRightToTopLeft = "Arrow_BRTL"
    case topLeftToBottomRight = "Arrow_TLBR"
    case topRightToBottomLeft = "Arrow_TRBL"
    
    var imageName: String {
        return self.rawValue
    }
    
    var label: String {
        switch self {
        // Condition 1
        case .leftToRight: return "Left to Right"
        case .rightToLeft: return "Right to Left"
        case .bottomToTop: return "Bottom to Top"
        case .topToBottom: return "Top to Bottom"
            
        // Condition 2
        case .bottomLeftToTopRight: return "Bottom Left to Top Right"
        case .bottomRightToTopLeft: return "Bottom Right to Top Left"
        case .topLeftToBottomRight: return "Top Left to Bottom Right"
        case .topRightToBottomLeft: return "Top Right to Bottom Left"
        }
    }
}

// MARK: - ContentView

struct ContentView: View {
    @StateObject private var sensorDataManager = SensorDataManager()
    
    // Choose Condition 1 or Condition 2
    @State private var condition = 1
    // Trial management
    @State private var maxTrials = 20
    @State private var currentTrial = 0
    
    // Break management
    @State private var breakInterval = 5    // e.g., after 50 trials
    @State private var breakDuration = 10    // break length in seconds
    @State private var isBreakActive = false
    @State private var breakRemainingTime = 0
    @State private var breakTimer: Timer?
    
    // This flag prevents a second break from immediately restarting.
    @State private var justHadBreak = false
    
    // Swipe state
    @State private var showSwipeArrow = false
    @State private var swipeDirection: SwipeDirection = .bottomLeftToTopRight
    
    // Data collection
    @State private var swipeDataArray: [SwipeData] = []
    @State private var startTimestamp: TimeInterval? = nil
    private let webSocketServer = WebSocketServer()
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                // If not running, show "Start the Block" button
                if !sensorDataManager.isRunning {
                    Button(action: startBlock) {
                        Text("Start the Block")
                            .font(.largeTitle)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                // If running and break is active, show the break timer
                else if isBreakActive {
                    Text("Break time: \(breakRemainingTime) seconds remaining")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                }
                // Otherwise, show the normal swipe UI
                else {
                    if condition == 1 {
                        // Condition 1
                        if showSwipeArrow {
                            Image(swipeDirection.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .onTapGesture {
                                    if showSwipeArrow { stopSwipe() }
                                    else { startSwipe() }
                                }
                                .accessibilityLabel("Swipe \(swipeDirection.label)")
                        } else {
                            Text("Press 'space' to start")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    if showSwipeArrow { stopSwipe() }
                                    else { startSwipe() }
                                }
                        }
                    } else {
                        // Condition 2
                        if showSwipeArrow {
                            Image(swipeDirection.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .onTapGesture {
                                    if showSwipeArrow { stopSwipe() }
                                    else { startSwipe() }
                                }
                                .accessibilityLabel("Swipe \(swipeDirection.label)")
                        } else {
                            Text("Press 'space' to start")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    if showSwipeArrow { stopSwipe() }
                                    else { startSwipe() }
                                }
                        }
                    }
                }
            }
        }
        .onAppear {
            sensorDataManager.isRunning = false
            webSocketServer.startServer()
            webSocketServer.onToggleSwipe = { toggleSwipeState() }
            
            // Start sensor updates on a 0.1s interval
            sensorDataManager.sensorTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                if let accelData = sensorDataManager.accelerometerData,
                   let gyroData = sensorDataManager.gyroscopeData {
                    
                    let timestamp = Date().timeIntervalSince1970
                    if startTimestamp == nil {
                        startTimestamp = timestamp
                    }
                    let relativeTime = timestamp - (startTimestamp ?? timestamp)
                    
                    let data = SwipeData(
                        accelX: accelData.x,
                        accelY: accelData.y,
                        accelZ: accelData.z,
                        gyroX: gyroData.x,
                        gyroY: gyroData.y,
                        gyroZ: gyroData.z,
                        iteration: sensorDataManager.currentIteration,
                        label: sensorDataManager.swipeLabel ?? "0",
                        timestamp: Date(timeIntervalSince1970: timestamp),
                        relativeTime: relativeTime
                    )
                    swipeDataArray.append(data)
                }
            }
        }
        .onDisappear {
            stopDataCollection()
            exportDataToCSV()
            webSocketServer.stopServer()
        }
    }
    
    // MARK: - Helper Functions
    
    private func toggleSwipeState() {
        // Only allow toggling if running and not on break
        if sensorDataManager.isRunning && !isBreakActive {
            if showSwipeArrow { stopSwipe() }
            else { startSwipe() }
        }
    }

    private func startBlock() {
        sensorDataManager.isRunning = true
        currentTrial = 0
        print("Block started. Condition: \(condition), Max Trials: \(maxTrials)")
        sensorDataManager.startSensors()
        proceedToNextSwipe()
    }
    
    private func proceedToNextSwipe() {
        // If we've reached maxTrials, end session
        if currentTrial >= maxTrials {
            stopDataCollection()
            exportDataToCSV()
            print("Block completed.")
            return
        }
        
        // If we didn't just have a break, and we hit a break multiple, and not at the final trial
        if !justHadBreak,
           currentTrial > 0,
           currentTrial % breakInterval == 0,
           currentTrial < maxTrials {
            startBreak()
            return
        }
        
        // Otherwise, continue with next trial
        showSwipeArrow = false
        sensorDataManager.stopSwipe() // resets label to "0"
        justHadBreak = false  // We'll allow future breaks once a new swipe starts.
        
        // Pick a random direction per condition
        swipeDirection = selectSwipeDirection()
        print("Next Swipe: \(swipeDirection.label), Trial: \(currentTrial + 1)")
    }
    
    private func startBreak() {
        isBreakActive = true
        breakRemainingTime = breakDuration
        
        // Invalidate old break timer if needed
        breakTimer?.invalidate()
        
        breakTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.breakRemainingTime > 0 {
                self.breakRemainingTime -= 1
            } else {
                // Break is over
                self.breakTimer?.invalidate()
                self.breakTimer = nil
                self.isBreakActive = false
                // Mark that we just had a break to avoid immediate re-trigger
                self.justHadBreak = true
                // Continue the trial flow
                self.proceedToNextSwipe()
            }
        }
    }
    
    private func selectSwipeDirection() -> SwipeDirection {
        let condition1Directions: [SwipeDirection] = [.leftToRight, .rightToLeft, .bottomToTop, .topToBottom]
        let condition2Directions: [SwipeDirection] = [.bottomLeftToTopRight, .bottomRightToTopLeft, .topLeftToBottomRight, .topRightToBottomLeft]
        
        if condition == 1 {
            return condition1Directions.randomElement()!
        } else {
            return condition2Directions.randomElement()!
        }
    }
    
    private func startSwipe() {
        // Once we start a swipe, it's safe to reset the break flag
        justHadBreak = false
        sensorDataManager.startSwipe(with: swipeDirection.label, iteration: currentTrial + 1)
        showSwipeArrow = true
        print("Swipe started: \(sensorDataManager.swipeLabel ?? "0")")
    }
    
    private func stopSwipe() {
        print("Swipe ended: \(sensorDataManager.swipeLabel ?? "0")")
        
        sensorDataManager.stopSwipe()
        showSwipeArrow = false
        
        // One swipe completed => increment trial
        currentTrial += 1
        proceedToNextSwipe()
    }
    
    private func stopDataCollection() {
        sensorDataManager.stopSensors()
        sensorDataManager.sensorTimer?.invalidate()
        sensorDataManager.sensorTimer = nil
        sensorDataManager.isRunning = false
        
        breakTimer?.invalidate()
        breakTimer = nil
        isBreakActive = false
    }
    
    private func exportDataToCSV() {
        let fileName = "SwipeData.csv"
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
        
        var csvText = "AccelX,AccelY,AccelZ,GyroX,GyroY,GyroZ,Iteration,Label,Timestamp,RelativeTime\n"
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "America/Toronto")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        for data in swipeDataArray {
            let estTimestamp = dateFormatter.string(from: data.timestamp)
            let row = "\(data.accelX),\(data.accelY),\(data.accelZ),\(data.gyroX),\(data.gyroY),\(data.gyroZ),\(data.iteration),\(data.label),\(estTimestamp),\(data.relativeTime)\n"
            csvText.append(row)
        }
        
        do {
            try csvText.write(to: path, atomically: true, encoding: .utf8)
            print("CSV file saved successfully at \(path)")
        } catch {
            print("Failed to save CSV file: \(error.localizedDescription)")
        }
    }
}
