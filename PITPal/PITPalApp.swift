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
    
    @State private var launchTimer = Timer.publish(every:3.0, on: .main, in: .common).autoconnect()
    @State private var isGrayScale = false
    @State private var isFlashing  = false

    private let totalDuration = 4.0
    private let flashDuration = 0.35

    @State private var audioPlayer: AVAudioPlayer?
    @State private var hasPlayedSound = false
    
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
                        // .aspectRatio(contentMode: .fit)
                        .scaledToFit()
                        .frame(width: 720, height: 960)
                        .saturation(isGrayScale ? 0 : 1)
                        .animation(.easeInOut(duration: flashDuration), value: isGrayScale)
                        .padding(.bottom, 30)
                    Text("Loading PIT Pal \(getAppVersion()) (Build \(getBuildNumber()))")
                    ProgressView()
                }
            }
            // .environment(\.colorScheme, darkMode == true ? .dark : .light)
            // .preferredColorScheme(darkMode == true ? .dark : .light)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color.black)
            
            .onReceive(launchTimer) { time in
                isFlashing = false
                print("Timers cancelled")
                isWaitingForLaunchView = false
                launchTimer.upstream.connect().cancel()
            }
            .onAppear {
                print("Start flashing");
                startFlashing()
                print("Autosave disabled: \(modelContext.autosaveEnabled)")
                setupAudioPlayer()
                playSound()
                hasPlayedSound = true
            }
            .task {
                // DispatchQueue.main.async {

                // }
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
        print("Play sound")
        guard !hasPlayedSound else { return }
        guard let player = audioPlayer else {
            print("Audio player not initialized")
            return
        }
        // Play the sound from the beginning
        player.currentTime = 0
        player.play()
    }
    
    // Function to start the flashing effect
    private func startFlashing() {
        guard !isFlashing else { return }
        isFlashing = true
        print("Is flashing: \(isFlashing)")
        
        // Timer to toggle between color and grayscale
        let timer = Timer.scheduledTimer(withTimeInterval: flashDuration, repeats: true) { _ in
            isGrayScale.toggle()
        }
        
        // Stop flashing after totalDuration
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
            timer.invalidate()
            isGrayScale = false // Ensure it ends in color
            isFlashing = false
        }
    }
    
}


/*
 
 struct SoundPlayerView: View {
     @StateObject private var audioManager = AudioManager()
     
     var body: some View {
         VStack {
             Button(action: {
                 audioManager.playSoundForFiveSeconds()
             }) {
                 Text("Play Sound for 5 Seconds")
                     .padding()
                     .background(Color.blue)
                     .foregroundColor(.white)
                     .clipShape(RoundedRectangle(cornerRadius: 10))
             }
         }
     }
 }

 class AudioManager: ObservableObject {
     private var audioPlayer: AVAudioPlayer?
     
     init() {
         // Load the audio file
         if let soundURL = Bundle.main.url(forResource: "sound", withExtension: "mp3") {
             do {
                 audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                 audioPlayer?.prepareToPlay()
             } catch {
                 print("Error loading audio file: \(error.localizedDescription)")
             }
         } else {
             print("Audio file not found")
         }
     }
     
     func playSoundForFiveSeconds() {
         guard let player = audioPlayer else { return }
         
         // Play the sound
         player.play()
         
         // Stop the sound after 5 seconds
         DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
             player.stop()
             player.currentTime = 0 // Reset to start for next play
         }
     }
 }
 
 */
