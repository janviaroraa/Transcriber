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
    @IBOutlet weak var textView: UITextView!
    
    private var audioRecorder: AVAudioRecorder?
    private var recordedFileURL: URL?
    private var textFileURL: URL?
    private var audioPlayer: AVAudioPlayer?
    private var transcribed = false

    override func viewDidLoad() {
        super.viewDidLoad()
        let utilities = Utilities()
        recordedFileURL = utilities.getAudioFileURL()
        textFileURL = utilities.getTextFileURL()
        print(recordedFileURL?.absoluteString ?? "No recorded file found")
        recordAudio()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        audioPlayer?.stop()
        if transcribed {
            CoreDataHelper.shared.storeTranscription(audioFileUrlString: recordedFileURL?.absoluteString ?? "", textFileUrlString: textFileURL?.absoluteString ?? "")
        }
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

    private func transcribeAudio() {
        guard let recordedFileURL, let textFileURL else { return }
        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: recordedFileURL)
        recognizer?.recognitionTask(with: request) { [weak self] (result, error) in
            guard let result else {
                print(error?.localizedDescription)
                return
            }
            if result.isFinal {
                let text = result.bestTranscription.formattedString
                self?.textView.text = text
                try? text.write(to: textFileURL, atomically: true, encoding: .utf8)
                self?.transcribed = true
            }
        }
    }

    // MARK: Play & transcribe audio
    private func recordingEnded(success: Bool) {
        if success {
            audioPlayer?.stop()
            guard let recordedFileURL else { return }
            audioPlayer = try? AVAudioPlayer(contentsOf: recordedFileURL)
            audioPlayer?.play()
            transcribeAudio()
        }
    }
}

extension RecordViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        recordingEnded(success: flag)
    }
}
