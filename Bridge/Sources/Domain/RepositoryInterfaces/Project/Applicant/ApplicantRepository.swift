//
//  ApplicantRepository.swift
//  Bridge
//
//  Created by 엄지호 on 12/23/23.
//

import RxSwift

protocol ApplicantRepository {
    // MARK: - ApplicantList
    func fetchApplicantList(projectID: Int) -> Observable<[ApplicantProfile]>
    
    // MARK: - Accept
    func accept(projectID: Int, applicantID: Int) -> Observable<Int>
    
    // MARK: - Reject
    func reject(projectID: Int, applicantID: Int) -> Observable<Int>
    
    // MARK: - CancelApplication
    func cancel(projectID: Int) -> Observable<Int>
    
    // MARK: - Apply
    func apply(projectID: Int) -> Observable<Void>
}
