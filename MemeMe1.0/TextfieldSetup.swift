//
//  textfieldSetup.swift
//  MemeMe1.0
//
//  Created by Ramon Yepez on 3/10/21.
//

import Foundation
import UIKit

// creating a property for setting the text in the style of memes
let memeTextAttributes: [NSAttributedString.Key: Any] = [
    .strokeColor: UIColor.black,
    .foregroundColor: UIColor.white,
    .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    .strokeWidth: -3.0
]

// function use to setup the textfields

func textSetup(textfiled: UITextField, initialText: String) {
    
    textfiled.text = initialText
    textfiled.defaultTextAttributes = memeTextAttributes
    textfiled.textAlignment = .center

}
