//
//  Utilities.swift
//  Transcriber
//
//  Created by Janvi Arora on 27/06/24.
//

import Foundation

class Utilities {

    static func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    /// Example: file:///Users/janviarora/Library/Developer/CoreSimulator/Devices/FAC4A6B7-445C-4AD5-B751-BDEF5EEE6603/data/Containers/Data/Application/92FE5C13-7151-4CA3-8541-3E45D322F185/Documents/2024-06-27-19-25-00.m4a
    ///
    /// Device Designator "FAC4A6B7-445C-4AD5-B751-BDEF5EEE6603" : Changes on the basis of simulator selected
    ///
    /// Application Container ID "92FE5C13-7151-4CA3-8541-3E45D322F185"
    ///
    ///  Please note whenever you are stoing items to iCloud, only ''2024-06-27-19-25-00.m4a" should be stored
    static func getAudioFileURL() -> URL? {
        let audioURL = getDocumentDirectory().appendingPathComponent(getDateAndTime() + ".m4a")
        return audioURL
    }

    static func getDateAndTime() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let dateAndTimeString = formatter.string(from: date)
        return dateAndTimeString
    }
}
