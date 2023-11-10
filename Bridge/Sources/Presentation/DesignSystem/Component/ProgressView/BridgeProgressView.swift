//
//  BridgeProgressView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/03.
//

import UIKit

final class BridgeProgressView: BaseProgressView {
    
    init(_ progress: Float) {
        super.init(frame: .zero)
        self.progress = progress
    }
    
    override func configureAttributes() {
        progressTintColor = BridgeColor.primary1
        backgroundColor = BridgeColor.gray7
    }

}
