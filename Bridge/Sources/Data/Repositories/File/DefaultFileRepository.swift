//
//  DefaultFileRepository.swift
//  Bridge
//
//  Created by 엄지호 on 1/15/24.
//

import Foundation
import RxSwift

final class DefaultFileRepository: FileRepository {
    // MARK: - Properties
    private let networkService: NetworkService
    
    // MARK: - Initializer
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    // MARK: - Methods
    func downloadFile(from urlString: URLString) -> Observable<URL> {
        return networkService.download(from: urlString)
    }
}
