//
//  DownloadFileUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 1/15/24.
//

import Foundation
import RxSwift

protocol DownloadFileUseCase {
    func download(from urlString: URLString) -> Observable<URL>
}

final class DefaultDownloadFileUseCase: DownloadFileUseCase {
    private let fileRepository: FileRepository
    
    init(fileRepository: FileRepository) {
        self.fileRepository = fileRepository
    }
    
    func download(from urlString: URLString) -> Observable<URL> {
        fileRepository.downloadFile(from: urlString)
    }
}
