//
//  CoreDataHelper.swift
//  Transcriber
//
//  Created by Janvi Arora on 28/06/24.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper {

    static let shared = CoreDataHelper()

    private init() {
        let container = NSPersistentContainer(name: "Transcriber")
        container.loadPersistentStores { storeDesc, error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }

    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func storeTranscription(audioFileUrlString: String, textFileUrlString: String) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Transcription", in: context)
        let transcription = NSManagedObject(entity: entity!, insertInto: context)
        transcription.setValue(audioFileUrlString, forKey: "audioFileUrlString")
        transcription.setValue(textFileUrlString, forKey: "textFileUrlString")

        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
