//
//  ProtocolsImage.swift
//  ToDo
//
//  Created by Rusell on 14.02.2021.
//

import UIKit

protocol ImageSave {
    func saveImage(image: UIImage, nameImage: String) -> Bool
}

protocol ImageGet {
    func getSavedImage(named: String) -> UIImage?
}
