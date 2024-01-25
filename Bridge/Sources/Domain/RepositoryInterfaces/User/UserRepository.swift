//
//  UserRepository.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/25.
//

import RxSwift

protocol UserRepository {
    func fetchMyProfile() -> Observable<Profile>
    func fetchOtherUserProfile(userID: Int) -> Observable<Profile>
    func fetchProfilePreview() -> Observable<ProfilePreview>
    func createProfile(_ profile: Profile) -> Observable<Void>
    func updateProfile(_ profile: Profile) -> Observable<Void>
    func changeField(selectedFields: [String]) -> Observable<Void>
    func fetchBookmarkedProjects() -> Observable<[BookmarkedProject]>
}
