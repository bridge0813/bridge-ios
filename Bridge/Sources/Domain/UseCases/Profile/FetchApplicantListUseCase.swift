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
    
    private let profileRepository: ProfileRepository
    
    init(profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
    }
    
    func fetchApplicantList(projectID: Int) -> Observable<[ApplicantProfile]> {
        profileRepository.fetchApplicantList(projectID: projectID)
    }
}
