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
    let isSingleButton: Bool  // Alert이 하나의 버튼만을 필요로 할 경우 사용(이 때, 사용되는 버튼은 rightButton)
    
    init(
        imageName: String,
        title: String,
        description: String,
        leftButtonTitle: String = "취소하기",
        rightButtonTitle: String,
        isSingleButton: Bool = false
    ) {
        self.imageName = imageName
        self.title = title
        self.description = description
        self.leftButtonTitle = leftButtonTitle
        self.rightButtonTitle = rightButtonTitle
        self.isSingleButton = isSingleButton
    }
    
    init(
        title: String,
        description: String?,
        leftButtonTitle: String = "취소하기",
        rightButtonTitle: String,
        isSingleButton: Bool = false
    ) {
        self.imageName = nil
        self.title = title
        self.description = description
        self.leftButtonTitle = leftButtonTitle
        self.rightButtonTitle = rightButtonTitle
        self.isSingleButton = isSingleButton
    }
}

// MARK: - Auth
extension AlertConfiguration {
    static let signIn = AlertConfiguration(
        imageName: "graphic_sign_in",
        title: "로그인 후 사용 가능해요!",
        description: "로그인해야 사용할 수 있는 기능입니다.",
        rightButtonTitle: "로그인하기"
    )
    
    static let signOut = AlertConfiguration(
        title: "로그아웃",
        description: "로그아웃 하시겠습니까?",
        leftButtonTitle: "아니오",
        rightButtonTitle: "로그아웃"
    )
    
    static let withdrawal = AlertConfiguration(
        title: "회원탈퇴",
        description: "탈퇴시 계정 정보 및 작성한 공고, 메시지가\n초기화되며 복구가 불가합니다.",
        rightButtonTitle: "계정삭제"
    )
}
    
// MARK: - Project
extension AlertConfiguration {
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
    
    static let cancelApplication = AlertConfiguration(
        title: "프로젝트 지원을 취소할까요?",
        description: nil,
        leftButtonTitle: "아니오",
        rightButtonTitle: "취소하기"
    )
}
 
// MARK: - Chat
extension AlertConfiguration {
    static let leaveChannel = AlertConfiguration(
        title: "채팅방에서 나갈까요?",
        description: "채팅 목록 및 대화 내용이 모두 삭제됩니다.",
        rightButtonTitle: "나가기"
    )
    
    static let report = AlertConfiguration(
        imageName: "graphic_siren",
        title: "정말 신고하실 건가요?",
        description: "신고는 되돌릴 수 없으며\n채팅방에서 나가집니다.",
        rightButtonTitle: "신고하기"
    )
}

// MARK: - ProjectDetail
extension AlertConfiguration {
    static let editProject = AlertConfiguration(
        title: "프로젝트를 수정할까요?",
        description: nil,
        rightButtonTitle: "수정하기"
    )
    
    static let closeProject = AlertConfiguration(
        title: "프로젝트를 마감할까요?",
        description: nil,
        rightButtonTitle: "마감하기"
    )
    
    static let deleteProject = AlertConfiguration(
        title: "프로젝트를 삭제할까요?",
        description: nil,
        rightButtonTitle: "삭제하기"
    )
    
    static let apply = AlertConfiguration(
        imageName: "graphic_support",
        title: "프로젝트를 지원할까요?",
        description: "프로젝트의 팀원이 되어 함께 해보세요.",
        rightButtonTitle: "지원하기"
    )
    
    static let completedApplication = AlertConfiguration(
        title: "지원 완료",
        description: "프로젝트 지원이 완료되었어요.",
        rightButtonTitle: "확인하기",
        isSingleButton: true
    )
}

// MARK: - User
extension AlertConfiguration {
    static let fieldChanged = AlertConfiguration(
        title: "관심분야 변경 완료",
        description: "관심분야 변경이 완료되었어요.",
        rightButtonTitle: "확인하기",
        isSingleButton: true
    )
    
    static let createProfile = AlertConfiguration(
        title: "등록된 프로필이 없습니다.",
        description: "프로필을 작성하러 가볼까요?",
        rightButtonTitle: "작성하기"
    )
}

// MARK: - download
extension AlertConfiguration {
    static let downloadFile = AlertConfiguration(
        title: "파일 다운로드",
        description: "선택하신 파일을 다운로드하시겠습니까?",
        rightButtonTitle: "확인하기"
    )
}
