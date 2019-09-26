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

    // MARK: Alerts
    
    struct Alerts {
        static let DismissAlert = "Dismiss"
        static let AudioRecorderStoppingFailedTitle = "Stopping Failed"
        static let AudioRecorderStoppingFailedMessage = "Audio Recorder stopping failed"
    }
    
    // MARK: Audio Recorder Statuses
    
    struct AudioRecorderStatuses {
        static let RecordingInProgress = "Recording in Progress"
        static let NotRecording = "Tap to Record"
    }
    
    // Mark: Segue Indentifiers
    
    struct SegueIdentifiers {
        static let StopRecording = "stopRecording"
    }
    
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

    @IBAction func stopRecording(_ sender: Any) {
        setupUI(isRecording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        print(audioRecorder.url.path)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: SegueIdentifiers.StopRecording, sender: audioRecorder.url)
        } else {
            showAlert(Alerts.AudioRecorderStoppingFailedTitle, message: Alerts.AudioRecorderStoppingFailedMessage)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.StopRecording {
            let playSoundVC = segue.destination as! PlaySoundsViewController
            playSoundVC.recordedAudioURL = sender as? URL
        }
    }
    
    //MARK: Helper Functions
    
    func setupUI(isRecording: Bool) {
        recordingLabel.text = isRecording ? AudioRecorderStatuses.RecordingInProgress : AudioRecorderStatuses.NotRecording
        recordingButton.isEnabled = !isRecording
        stopRecordingButton.isEnabled = isRecording
    }
    
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getDocumentDirectoryUrl() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}

