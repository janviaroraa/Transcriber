//
//  ViewController.swift
//  QuickShare
//
//  Created by Janvi Arora on 28/06/24.
//

import UIKit
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var quickShareTableView: UITableView!

    private let identifier = "quickShareTableViewCell"
    private var assetCollection: PHAssetCollection?
    private var photos: PHFetchResult<PHAsset>?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPhotos()
        configureTableView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == "showFullImageSegue",
           let newVC = segue.destination as? DetailsViewController,
           let cell = sender as? UITableViewCell,
           let indexPath = self.quickShareTableView.indexPath(for: cell) {
            newVC.configureAsset(asset: (photos?[indexPath.row])!)
        }
    }

    private func configureTableView() {
        quickShareTableView.delegate = self
        quickShareTableView.dataSource = self
    }

    private func setupPhotos() {
        let collection = PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .smartAlbumUserLibrary,
            options: .none
        )

        if collection.firstObject != nil {
            assetCollection = collection.firstObject

            let options = PHFetchOptions()
            options.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

            guard let assetCollection else { return }
            photos = PHAsset.fetchAssets(in: assetCollection, options: options)
        } else {
            print("MANUAL ERROR: Nothing found")
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? QuickShareTableViewCell else { return UITableViewCell() }

        if let asset = photos?[indexPath.row] {
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: CGSize(width: 320, height: 240),
                contentMode: .aspectFill,
                options: .none
            ) { resultImage, info in
                if let resultImage {
                    cell.quickShareImage.image = resultImage
                }
            }
        }
        return cell
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
