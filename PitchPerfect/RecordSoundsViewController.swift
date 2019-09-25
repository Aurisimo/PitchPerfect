//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Aurelijus Lape on 23/09/2019.
//  Copyright © 2019 Aurelijus Lape. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet var recordingLabel: UILabel!
    @IBOutlet var recordingButton: UIButton!
    @IBOutlet var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    enum RecorderStatus {
        case Recording
        case Stopped
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI(isRecording: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func recordAudio(_ sender: Any) {
        setupUI(isRecording: true)
    
        let fileUrl = getDocumentDirectoryUrl().appendingPathComponent("recorderVoice.wav")
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(.playAndRecord, options: .defaultToSpeaker)
        
        audioRecorder = try! AVAudioRecorder(url: fileUrl, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func setupUI(isRecording: Bool) {
        if isRecording {
            recordingLabel.text = "Recording in Progress"
            recordingButton.isEnabled = false
            stopRecordingButton.isEnabled = true
            return
        }
    
        recordingButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        recordingLabel.text = "Tap to Record"
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        setupUI(isRecording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        print(audioRecorder.url.path)
    }
    
    func getDocumentDirectoryUrl() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Unable to stop recording")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destination as! PlaySoundsViewController
            playSoundVC.recordedAudioURL = sender as? URL
        }
    }
}

