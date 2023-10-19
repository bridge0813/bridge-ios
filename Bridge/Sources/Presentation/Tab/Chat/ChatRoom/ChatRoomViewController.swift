//
//  ChatRoomViewController.swift
//  Bridge
//
//  Created by 정호윤 on 10/16/23.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift
import Starscream

final class ChatRoomViewController: BaseViewController {
    // MARK: - UI
    private let rootFlexConatiner: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray9
        return view
    }()
    
    private let messageTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .black
        textView.textColor = .white
        textView.isEditable = false
        return textView
    }()
    
    private let messageInputBar = BridgeMessageInputBar()
    
    private let viewModel: ChatRoomViewModel
    
    init(viewModel: ChatRoomViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        enableKeyboardHiding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(rootFlexConatiner)
        
        let margin: CGFloat = 16
        
        rootFlexConatiner.flex.define { flex in
            flex.addItem(messageTextView).height(300).marginHorizontal(margin).marginVertical(20)
            flex.addItem().grow(1)
            flex.addItem(messageInputBar)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlexConatiner.pin.all(view.pin.safeArea)
        rootFlexConatiner.flex.layout()
    }
    
    // MARK: - Binding
    override func bind() {
        messageInputBar.rx.keyboardLayoutChanged
            .bind(to: messageInputBar.rx.yPosition)
            .disposed(by: disposeBag)
        
        let input = ChatRoomViewModel.Input(sendMessage: messageInputBar.sendMessage)
        let output = viewModel.transform(input: input)
        
        output.messages
            .drive { [weak self] message in
                self?.messageTextView.text += message + "\n"
            }
            .disposed(by: disposeBag)
    }
}
