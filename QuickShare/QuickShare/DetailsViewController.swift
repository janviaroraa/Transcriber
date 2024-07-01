//
//  DetailsViewController.swift
//  QuickShare
//
//  Created by Janvi Arora on 29/06/24.
//

import UIKit
import Photos
import Social

class DetailsViewController: UIViewController, UIDocumentInteractionControllerDelegate {

    @IBOutlet weak var detailImageView: UIImageView!

    private var asset: PHAsset?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureImage()
    }

    func configureAsset(asset: PHAsset) {
        self.asset = asset
    }

    private func configureImage() {
        if let asset {
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: CGSize(width: self.view.frame.width, height: self.view.frame.width * 0.5625),
                contentMode: .aspectFill,
                options: .none
            ) { resultImage, info in
                if let resultImage {
                    self.detailImageView.image = resultImage
                }
            }
        }
    }

    @IBAction func shareButtonClicked(_ sender: UIButton) {
        switch sender.tag {
        case 0: print("Facebook")
        case 1: shareOnInstagram()
        case 2: print("Whatsapp")
        case 3: print("Pinterest")
        case 4: print("X")
        default: print("Default")
        }
    }

}

extension DetailsViewController {
    private func shareOnInstagram() {
        let url = URL(string: "instagram//:app")
        guard let url else { return }
        if UIApplication.shared.canOpenURL(url) {
            let imageData = detailImageView.image!.jpegData(compressionQuality: 85)
            let caption = "Default caption"
            let writePath = NSTemporaryDirectory().appending("instagram.igo")

            do {
                let fileURL = URL(fileURLWithPath: writePath)
                try imageData?.write(to: fileURL, options: [.atomicWrite])
                
            } catch {
                print("Error - Instagram")
            }
        }
    }
}
