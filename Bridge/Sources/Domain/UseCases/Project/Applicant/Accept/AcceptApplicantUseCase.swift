//
//  AcceptApplicantUseCase.swift
//  Bridge
//
//  Created by 엄지호 on 12/12/23.
//

import RxSwift

/// 모집글의 지원을 수락하는 UseCase
protocol AcceptApplicantUseCase {
    func accept(projectID: Int, applicantID: Int) -> Observable<Int>
}

final class DefaultAcceptApplicantUseCase: AcceptApplicantUseCase {
    
    private let applicantRepository: ApplicantRepository
    
    init(applicantRepository: ApplicantRepository) {
        self.applicantRepository = applicantRepository
    }
    
    func accept(projectID: Int, applicantID: Int) -> Observable<Int> {
        applicantRepository.accept(projectID: projectID, applicantID: applicantID)
    }
}
