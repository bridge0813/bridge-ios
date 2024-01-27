//
//  StorageObject.swift
//  Bridge
//
//  Created by 엄지호 on 1/28/24.
//

import Foundation

// 메모리와 디스크에 저장할 객체
final class StorageObject {
    let imageData: Data
    
    init(imageData: Data) {
        self.imageData = imageData
    }
}
