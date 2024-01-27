//
//  ProfileMultipartFormData.swift
//  Bridge
//
//  Created by 엄지호 on 1/24/24.
//

import Foundation

/// Multipart/form-data 형식의 Body를 구현하기 위한 객체
struct ProfileMultipartData {
    let createProfile: CreateProfileRequestDTO
    let updateProfile: UpdateProfileRequestDTO
    let imageData: Data?
    let files: [ReferenceFileRequestDTO]
}
