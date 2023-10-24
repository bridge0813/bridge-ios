//
//  AlertConfiguration.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/27.
//

struct AlertConfiguration {
    var imageName: String?
    let title: String
    var description: String?
    let leftButtonTitle: String
    let rightButtonTitle: String
    
    init(
        imageName: String,
        title: String,
        description: String,
        leftButtonTitle: String = "취소하기",
        rightButtonTitle: String
    ) {
        self.imageName = imageName
        self.title = title
        self.description = description
        self.leftButtonTitle = leftButtonTitle
        self.rightButtonTitle = rightButtonTitle
    }
    
    init(
        title: String,
        description: String?,
        leftButtonTitle: String = "취소하기",
        rightButtonTitle: String
    ) {
        self.imageName = nil
        self.title = title
        self.description = description
        self.leftButtonTitle = leftButtonTitle
        self.rightButtonTitle = rightButtonTitle
    }
}

extension AlertConfiguration {
    static let signIn = AlertConfiguration(
        imageName: "graphic_signIn",
        title: "로그인 후 사용 가능해요!",
        description: "로그인해야 사용할 수 있는 기능입니다.",
        rightButtonTitle: "로그인하기"
    )
    
    static let refuse = AlertConfiguration(
        imageName: "graphic_refuse",
        title: "정말 거절하실 건가요?",
        description: "거절하면 되돌릴 수 없습니다.\n신중하게 결정해주세요.",
        rightButtonTitle: "거절하기"
    )
    
    static let accept = AlertConfiguration(
        imageName: "graphic_handshake",
        title: "정말 수락하실 건가요?",
        description: "수락하면 되돌릴 수 없습니다.\n신중하게 결정해주세요.",
        rightButtonTitle: "수락하기"
    )
    
    static let report = AlertConfiguration(
        imageName: "graphic_siren",
        title: "정말 신고하실 건가요?",
        description: "신고는 되돌릴 수 없으며\n채팅방에서 나가집니다.",
        rightButtonTitle: "신고하기"
    )
    
    static let createProject = AlertConfiguration(
        imageName: "graphic_recruitment",
        title: "모집 글을 작성할까요?",
        description: "팀원들이 기다리고 있어요!",
        rightButtonTitle: "작성하기"
    )
    
    static let checkProject = AlertConfiguration(
        imageName: "graphic_rocket",
        title: "작성한 글을 보러갈까요?",
        description: "작성하신 글은 수정 및 삭제가 가능해요.",
        rightButtonTitle: "보러가기"
    )
}
