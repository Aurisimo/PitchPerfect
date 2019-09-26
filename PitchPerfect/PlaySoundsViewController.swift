//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Aurelijus Lape on 24/09/2019.
//  Copyright © 2019 Aurelijus Lape. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    @IBOutlet var slowButton: UIButton!
    @IBOutlet var fastButton: UIButton!
    @IBOutlet var chipmunkButton: UIButton!
    @IBOutlet var darthVaderButton: UIButton!
    @IBOutlet var reverbButton: UIButton!
    @IBOutlet var echoButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    
    var recordedAudioURL: URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!

    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        
        [slowButton, fastButton, chipmunkButton, darthVaderButton, reverbButton, echoButton].forEach { $0?.imageView?.contentMode = .scaleAspectFit }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }

    @IBAction func stopButtonPressed(_ sender: Any) {
        stopAudio()
    }
    
    @IBAction func playSoundForButton(_ sender: UIButton) {
        switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }

        configureUI(.playing)
    }
}
