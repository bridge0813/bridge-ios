//
//  FetchApplicantListUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 12/12/23.
//

import RxSwift

protocol FetchApplicantListUseCase {
    func fetchApplicantList(projectID: Int) -> Observable<[ApplicantProfile]>
}

final class DefaultFetchApplicantListUseCase: FetchApplicantListUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func fetchApplicantList(projectID: Int) -> Observable<[ApplicantProfile]> {
        userRepository.fetchApplicantList(projectID: projectID)
    }
}
