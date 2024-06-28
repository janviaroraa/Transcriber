//
//  RecordViewController.swift
//  Transcriber
//
//  Created by Janvi Arora on 27/06/24.
//

import UIKit
import AVFoundation
import Speech

class RecordViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
    private var audioRecorder: AVAudioRecorder?
    private var recordedFileURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        recordedFileURL = Utilities.getAudioFileURL()
        print(recordedFileURL?.absoluteString ?? "No recorded file found")
        recordAudio()
    }

    // MARK: Audio Recording

    private func recordAudio() {
        let session = AVAudioSession.sharedInstance()
        guard let recordedFileURL else { return }
        do {
            try session.setCategory(.playAndRecord, options: .defaultToSpeaker)
            try session.setActive(true)

            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            audioRecorder = try AVAudioRecorder(url: recordedFileURL, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
        } catch let error {
            print(error.localizedDescription)
            recordingEnded(success: false)
        }
    }

    @IBAction func stopRecording(_ sender: UIButton) {
        audioRecorder?.stop()
        sender.isEnabled = false
        UIView.animate(withDuration: 0.5) {
            self.image.image = UIImage(systemName: "checkmark.gobackward")
        }
    }

    // MARK: Audio Trnascription

    fileprivate func recordingEnded(success: Bool) {
        if success {
            do {
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

extension RecordViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        recordingEnded(success: flag)
    }
}
