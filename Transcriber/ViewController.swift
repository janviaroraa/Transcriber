//
//  ViewController.swift
//  Transcriber
//
//  Created by Janvi Arora on 27/06/24.
//

import UIKit
import AVFoundation
import Speech

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBAction func grantPermissions(_ sender: UIButton) {
        requestRecordPermissions()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func requestRecordPermissions() {
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] permission in
            DispatchQueue.main.async {
                if permission {
                    self?.requestTranscribePermissions()
                } else {
                    self?.showError()
                }
            }
        }
    }

    private func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                if status == .authorized {
                    self?.dismiss(animated: true, completion: nil)
                } else {
                    self?.showError()
                }
            }
        }
    }

    private func showError() {
        label.text = "You have previously denied the permission. Please go back to your settings, turn the permissions on and restart the app to continue enjoying our services!"
        button.isEnabled = false
        UIView.animate(withDuration: 0.4) {
            self.button.alpha = 0
        }
    }

}

