//
//  TranscriptionsTableViewController.swift
//  Transcriber
//
//  Created by Janvi Arora on 27/06/24.
//

import UIKit
import AVFoundation
import Speech

class TranscriptionsTableViewController: UITableViewController {

    private let identifier = "transcriptionsTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermissions()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = "Dummy"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: Permissions
    private func checkPermissions() {
        let recordAuthorized = AVAudioSession.sharedInstance().recordPermission == .granted
        let transcribeAuthorized = SFSpeechRecognizer.authorizationStatus() == .authorized

        let authorized = recordAuthorized && transcribeAuthorized

        if !authorized {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PermissionsVC") {
                self.navigationController?.present(vc, animated: true, completion: nil)
            }
        }
    }
}
