//
//  FetchApplicantListUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 12/12/23.
//

import RxSwift

protocol FetchApplicantListUseCase {
    func fetch(projectID: Int) -> Observable<[ApplicantProfile]>
}

final class DefaultFetchApplicantListUseCase: FetchApplicantListUseCase {
    
    private let applicantRepository: ApplicantRepository
    
    init(applicantRepository: ApplicantRepository) {
        self.applicantRepository = applicantRepository
    }
    
    func fetch(projectID: Int) -> Observable<[ApplicantProfile]> {
        applicantRepository.fetchApplicantList(projectID: projectID)
    }
}
