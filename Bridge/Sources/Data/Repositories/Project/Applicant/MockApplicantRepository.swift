//
//  MockApplicantRepository.swift
//  Bridge
//
//  Created by 엄지호 on 12/23/23.
//

import RxSwift

final class MockApplicantRepository: ApplicantRepository {
    func fetchApplicantList(projectID: Int) -> Observable<[ApplicantProfile]> {
        .just(ApplicantProfileResponseDTO.testArray.compactMap { $0.toEntity() })
    }
    
    func accept(projectID: Int, applicantID: Int) -> Observable<Int> {
        .just(applicantID)
    }
    
    func reject(projectID: Int, applicantID: Int) -> Observable<Int> {
        .just(applicantID)
    }
    
    func cancel(projectID: Int) -> Observable<Int> {
        .just(projectID)
    }
    
    func apply(projectID: Int) -> Observable<Void> {
        .just(())
    }
}
