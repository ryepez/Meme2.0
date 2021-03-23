//
//  meme.swift
//  MemeMe1.0
//
//  Created by Ramon Yepez on 3/10/21.
//

import Foundation
import UIKit

//saving the meme on a struct. I don't need a init because struct do that for me on the background
struct Meme {
    let topText: String?
    let bottomText: String?
    let originalImage: UIImage?
    let memedImage: UIImage
}
