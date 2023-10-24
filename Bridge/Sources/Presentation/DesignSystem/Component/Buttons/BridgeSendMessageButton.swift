//
//  BridgeSendMessageButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/25.
//

import UIKit

/// 채팅 메시지 전송 버튼
final class BridgeSendMessageButton: BaseButton {
    
    override var isEnabled: Bool {
        didSet { updateColors() }
    }
    
    override func configureAttributes() {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(named: "send.fill")?
            .resize(to: CGSize(width: 24, height: 24))
            .withRenderingMode(.alwaysTemplate)
        configuration.baseForegroundColor = BridgeColor.gray4
        configuration.baseBackgroundColor = BridgeColor.gray9
        self.configuration = configuration
        
        layer.cornerRadius = 4
    }
    
    private func updateColors() {
        UIView.animate(withDuration: 0.3) { [unowned self] in
            let tintColor: UIColor = self.isEnabled ? BridgeColor.gray10 : BridgeColor.gray4
            let backgroundColor: UIColor = self.isEnabled ? BridgeColor.primary1 : BridgeColor.gray9
            
            var updatedConfiguration = self.configuration
            updatedConfiguration?.baseForegroundColor = tintColor
            updatedConfiguration?.baseBackgroundColor = backgroundColor
            self.configuration = updatedConfiguration
        }
    }
}
