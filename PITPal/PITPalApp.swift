//
//  PITPalApp.swift
//  PITPal
//
//  Created by Doug Haacke on 6/11/25.
//

import Foundation
import SwiftData
import SwiftUI
import AVFoundation

@main
struct PITPalApp: App {
    @Environment(\.modelContext) var modelContext
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    @State private var locationsHandler = LocationsHandler.shared
    @State private var jsonManager      = JSONManager()
    @State private var networkMonitor   = NetworkMonitor()

    @State private var isWaitingForLaunchView = true
    @State private var launchTimer  = Timer.publish(every:3.6, on: .main, in: .common).autoconnect()
    @State private var audioPlayer: AVAudioPlayer?
    @State private var hasPlayedSound = false
    
    @State private var isFlashing = false
    @State private var flashTimer: Timer?
    
    var body: some Scene {
        WindowGroup {
            VStack {
                if isWaitingForLaunchView == false {
                    if locationsHandler.isAuthorized {
                        ContentView()
                            .environment(locationsHandler)
                            .environment(jsonManager)
                            .environment(networkMonitor)
                    } else {
                        LocationDeniedView()
                    }
                } else {
                    Image("ShockingTrout")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .grayscale(isFlashing ? 0.0 : 1.0)
                        .frame(width: 720, height: 960)
                        .padding(.bottom, 30)
                    Text("Loading PIT Pal \(getAppVersion()) (Build \(getBuildNumber()))")
                    ProgressView()
                }
            }
            // .environment(\.colorScheme, darkMode == true ? .dark : .light)
            // .preferredColorScheme(darkMode == true ? .dark : .light)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            // .background(Color("AppBackground"))
            .background(Color.black)
            .onReceive(launchTimer) { time in
                stopFlashing()
                isWaitingForLaunchView = false
                launchTimer.upstream.connect().cancel()
            }
            .onAppear {
                print("Autosave disabled: \(modelContext.autosaveEnabled)")
                setupAudioPlayer()
                playSound()
                hasPlayedSound = true
                startFlashing()
                print("Start flashing")
            }
            .onDisappear {
                print("Stop flashing")
                stopFlashing()
            }
            .task {
                print(modelContext.sqliteCommand)
                locationsHandler.updatesStarted = true
                // networkManager.checkNetworkConnection()
                
            }
        }
        .modelContainer(for: [Trip.self, Fish.self, Species.self, Gender.self, SurveySection.self, Watershed.self, TripType.self, Comment.self])
    }
    
    func getAppVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "N/A"
    }

    func getBuildNumber() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "N/A"
    }
    
    // Function to set up the audio player
    func setupAudioPlayer() {
        // Locate the MP3 file in the app bundle
        if let soundURL = Bundle.main.url(forResource: "electricity", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.prepareToPlay()
            } catch {
                print("Error loading audio file: \(error.localizedDescription)")
            }
        } else {
            print("MP3 file not found in the bundle")
        }
    }

    // Function to play the sound
    func playSound() {
        guard !hasPlayedSound else { return }
        guard let player = audioPlayer else {
            print("Audio player not initialized")
            return
        }
        // Play the sound from the beginning
        player.currentTime = 0
        player.play()
    }
    
    func toggleFlashing() {
        if isFlashing {
            stopFlashing()
        } else {
            startFlashing()
        }
    }

    // Function to start the flashing effect
    func startFlashing() {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else {
            print("No flashlight available")
            return
        }
        isFlashing = true
        do {
            try device.lockForConfiguration()
            // Random intensity (0.3 to 1.0) for realism, if supported
            let intensity = Float.random(in: 0.3...1.0)
            if device.isTorchModeSupported(.on) {
                try device.setTorchModeOn(level: intensity)
            } else {
                device.torchMode = .on // Fallback to full brightness
            }
            device.unlockForConfiguration()

            // Turn off flashlight after a brief random duration (0.1 to 0.3 seconds)
            let flashDuration = Double.random(in: 0.1...0.3)
            DispatchQueue.main.asyncAfter(deadline: .now() + flashDuration) {
                do {
                    try device.lockForConfiguration()
                    device.torchMode = .off
                    device.unlockForConfiguration()
                } catch {
                    print("Error turning off flashlight: \(error.localizedDescription)")
                }
                // Schedule the next flash after a random interval (0.5 to 3 seconds)
                if isFlashing {
                    stopFlashing()
                    let nextFlashDelay = Double.random(in: 0.1...0.3)
                    flashTimer = Timer.scheduledTimer(withTimeInterval: nextFlashDelay, repeats: false) { _ in
                        startFlashing()
                    }
                }
            }
        } catch {
            print("Error starting flashlight: \(error.localizedDescription)")
        }
    }
    
    func stopFlashing() {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }

        isFlashing = false
        flashTimer?.invalidate()
        flashTimer = nil

        do {
            try device.lockForConfiguration()
            device.torchMode = .off // Ensure flashlight is off
            device.unlockForConfiguration()
        } catch {
            print("Error turning off flashlight: \(error.localizedDescription)")
        }
    }
}
