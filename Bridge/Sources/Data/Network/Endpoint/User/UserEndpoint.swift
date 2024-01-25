//
//  UserEndpoint.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/25.
//  Edited by 정호윤 on 2023/12/12.

import Foundation

enum UserEndpoint {
    case fetchProfilePreview(userID: String)
    case changeField(requestDTO: ChangeFieldRequestDTO)
    case fetchBookmarkedProjects(userID: String)
    case createProfile(multipartData: ProfileMultipartData, userID: String)
    case updateProfile(requestDTO: UpdateProfileRequestDTO, userID: String)
    
    /// Multipart에서 각 데이터의 경계를 나타낼 바운더리
    var boundaryName: String {
        return "Boundary-\(UUID().uuidString)"
    }
}

extension UserEndpoint: Endpoint {
    var path: String {
        switch self {
        case .fetchProfilePreview:
            return "/users/mypage"
            
        case .changeField:
            return "/users/field"
            
        case .fetchBookmarkedProjects:
            return "/users/bookmark"
            
        case .createProfile:
            return "/users/profile"
            
        case .updateProfile:
            return "/users/profile"
        }
    }
    
    var queryParameters: QueryParameters? {
        switch self {
        case .fetchProfilePreview(let userID):
            return ["userId": userID]
            
        case .changeField:
            return nil
            
        case .fetchBookmarkedProjects(let userID):
            return ["userId": userID]
            
        case .createProfile(_, let userID):
            return ["userId": userID]
            
        case .updateProfile(_, let userID):
            return ["userId": userID]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchProfilePreview:
            return .get
            
        case .changeField:
            return .put
            
        case .fetchBookmarkedProjects:
            return .get
            
        case .createProfile:
            return .post
            
        case .updateProfile:
            return .put
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .fetchProfilePreview:
            return ["Content-Type": "application/json"]
            
        case .changeField:
            return ["Content-Type": "application/json"]
            
        case .fetchBookmarkedProjects:
            return ["Content-Type": "application/json"]
            
        case .createProfile:
            let contentType = "multipart/form-data; boundary=\(boundaryName)"
            return ["Content-Type": contentType]
            
        case .updateProfile:
            let contentType = "multipart/form-data; boundary=\(boundaryName)"
            return ["Content-Type": contentType]
        }
    }
    
    var task: Task {
        switch self {
        case .createProfile, .updateProfile:
            return .uploadMultipartFormData
            
        default:
            return .requestPlain
        }
    }
    
    var body: Encodable? {
        switch self {
        case .fetchProfilePreview:
            return nil
            
        case .changeField(let requestDTO):
            return requestDTO
            
        case .fetchBookmarkedProjects:
            return nil
            
        case .createProfile(let multipartData, _):
            var body = Data()
            
            // 프로필 데이터 추가
            if let profileFormData = try? JSONEncoder().encode(multipartData.createProfile) {
                body.appendFileDataForMultipart(
                    profileFormData,
                    fieldName: "profile",
                    fileName: "profile.json",
                    mimeType: "application/json",
                    boundary: boundaryName
                )
            }
            
            // 이미지 데이터 추가
            if let imageFormData = multipartData.imageData {
                body.appendFileDataForMultipart(
                    imageFormData,
                    fieldName: "photo",
                    fileName: "profileImage.jpg",
                    mimeType: "image/jpeg",
                    boundary: boundaryName
                )
            }
            
            // 파일 데이터 추가
            multipartData.files.forEach { file in
                body.appendFileDataForMultipart(
                    file.data,
                    fieldName: "refFiles",
                    fileName: file.name,
                    mimeType: "application/pdf",
                    boundary: boundaryName
                )
            }
        
            return body
            
        case .updateProfile(let requestDTO, _):
            var body = Data()
            
            // 업로드를 위한 이미지 데이터 추가
            if let imageData = requestDTO.imageData {
                body.appendFileDataForMultipart(imageData, fieldName: "photo", fileName: "profileImage.jpg", mimeType: "image/jpeg", boundary: boundaryName)
            }
            
            // 업로드를 위한 파일 데이터 추가
            requestDTO.newFiles.forEach { file in
                body.appendFileDataForMultipart(
                    file.data,
                    fieldName: "refFiles",
                    fileName: file.name,
                    mimeType: "application/pdf",
                    boundary: boundaryName
                )
            }
        
            return body
        }
    }
}
