//
//  SoundBrain.swift
//  Alias
//
//  Created by kudr7k on 7.05.22.
//

import AVFoundation

final class SoundBrain {

    var audio: AVPlayer!

    func answerRightSound() {
        playSound(url: "rightSound")
    }

    func skipWordSound() {
        playSound(url: "skipWordSound")
    }

    func playSound(url: String) {
        guard SettingsManager.shared.isSoundsEnabled else { return }
        if let url = Bundle.main.url(forResource: url, withExtension: "mp3") {
            audio = AVPlayer.init(url: url)
            audio.play()
        }
    }
}
