//
//  MockProfileRepository.swift
//  Bridge
//
//  Created by 엄지호 on 2023/12/04.
//

import RxSwift

final class MockProfileRepository: ProfileRepository {
    func fetchProfilePreview() -> Observable<ProfilePreview> {
        .just(ProfilePreviewResponseDTO.testData.toEntity())
//        .error(NetworkError.statusCode(401))
    }
}
