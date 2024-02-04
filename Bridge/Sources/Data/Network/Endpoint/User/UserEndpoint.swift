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
    
    case fetchProfile(userID: String)
    case createProfile(multipartData: ProfileMultipartData, userID: String, boundaryName: String)
    case updateProfile(multipartData: ProfileMultipartData, userID: String, boundaryName: String)
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
            
        case .fetchProfile:
            return "/users/profile"
            
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
            
        case .fetchProfile(let userID):
            return ["userId": userID]
            
        case .createProfile(_, let userID, _):
            return ["userId": userID]
            
        case .updateProfile(_, let userID, _):
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
            
        case .fetchProfile:
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
            
        case .fetchProfile:
            return ["Content-Type": "application/json"]
            
        case .createProfile(_, _, let boundaryName):
            let contentType = "multipart/form-data; boundary=\(boundaryName)"
            return ["Content-Type": contentType]
            
        case .updateProfile(_, _, let boundaryName):
            let contentType = "multipart/form-data; boundary=\(boundaryName)"
            return ["Content-Type": contentType]
        }
    }
    
    var task: NetworkTask {
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
            
        case .fetchProfile:
            return nil
            
        case .createProfile(let multipartData, _, let boundaryName):
            var body = Data()
            
            // 프로필 데이터 추가
            if let profileFormData = try? JSONEncoder().encode(multipartData.createProfile) {
                body.appendFileDataForMultipart(
                    profileFormData,
                    fieldName: "profile",
                    fileName: "createProfile.json",
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
        
            // 요청의 마무리 경계선 추가
            body.append("--\(boundaryName)--\r\n".data(using: .utf8)!)
            
            return body
            
        case .updateProfile(let multipartData, _, let boundaryName):
            var body = Data()
            
            // 프로필 데이터 추가
            if let profileFormData = try? JSONEncoder().encode(multipartData.updateProfile) {
                body.appendFileDataForMultipart(
                    profileFormData,
                    fieldName: "request",
                    fileName: "updateProfile.json",
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
            
            // 요청의 마무리 경계선 추가
            body.append("--\(boundaryName)--\r\n".data(using: .utf8)!)
        
            return body
        }
    }
}
