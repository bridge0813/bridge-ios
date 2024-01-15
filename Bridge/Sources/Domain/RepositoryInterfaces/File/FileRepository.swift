//
//  FileRepository.swift
//  Bridge
//
//  Created by 엄지호 on 1/15/24.
//

import Foundation
import RxSwift

protocol FileRepository {
    func downloadFile(from urlString: URLString) -> Observable<URL>
}
