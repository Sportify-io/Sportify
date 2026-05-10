//
//  ImageExtension.swift
//  Sportify
//

import UIKit
import SDWebImage

extension UIImageView {

    func setImage(
        urlString: String?,
        type: APISport
    ) {

        let placeholder: UIImage?

        switch type {

        case .football:
            placeholder = UIImage(named: "ball")

        case .basketball:
            placeholder = UIImage(named: "basketball")

        case .cricket:
            placeholder = UIImage(named: "cricket")

        case .tennis:
            placeholder = UIImage(named: "tennis")
        }
        
        guard let urlString = urlString,
              let url = URL(string: urlString) else {

            self.image = placeholder
            return
        }

        self.sd_setImage(
            with: url,
            placeholderImage: placeholder
        ) { [weak self] image, error, _, _ in

            guard let self = self else { return }

            if error != nil || image == nil {

                self.image = placeholder
            }
        }
    }
}
