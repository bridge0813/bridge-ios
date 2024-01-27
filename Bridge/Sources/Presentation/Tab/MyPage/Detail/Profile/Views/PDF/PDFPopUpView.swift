//
//  PDFPopUpView.swift
//  Bridge
//
//  Created by 엄지호 on 1/15/24.
//

import UIKit
import PDFKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

/// PDF 파일을 보여주는 팝업 뷰
final class PDFPopUpView: BridgeBasePopUpView {
    // MARK: - UI
    private let pdfView = PDFView()
    
    // MARK: - Property
    override var containerHeight: CGFloat { UIScreen.main.bounds.height - 50 }
    override var dismissYPosition: CGFloat { UIScreen.main.bounds.height / 2 }
    
    var url: URL? {
        didSet {
            loadPDF()
        }
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        super.configureAttributes()
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        super.configureLayouts()
        
        rootFlexContainer.flex.define { flex in
            flex.addItem(dragHandleBar).alignSelf(.center).marginTop(10)
            flex.addItem().backgroundColor(BridgeColor.gray08).height(1).marginTop(30)
            flex.addItem(pdfView).grow(1)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Hide
    override func hide() {
        super.hide()
        pdfView.document = nil
    }
}

extension PDFPopUpView {
    /// PDF 파일 로드
    private func loadPDF() {
        guard let url = url else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let pdfDocument = PDFDocument(url: url) else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.pdfView.document = pdfDocument
            }
        }
    }
}
