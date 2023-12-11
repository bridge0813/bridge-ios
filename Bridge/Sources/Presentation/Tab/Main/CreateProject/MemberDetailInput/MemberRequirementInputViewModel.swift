//
//  MemberDetailInputViewModel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import RxSwift
import RxCocoa

final class MemberRequirementInputViewModel: ViewModelType {
    // MARK: - Input & Output
    struct Input {
        let recruitNumber: Observable<Int>
        let techTags: Observable<[String]>
        let requirementText: Observable<String>
        let nextButtonTapped: Observable<Void>
    }
    
    struct Output {
        let selectedField: Driver<String>
        let recruitNumber: Driver<Int>
        let techTags: Driver<[String]>
        let isNextButtonEnabled: Driver<Bool>
    }
    
    // MARK: - Property
    let disposeBag = DisposeBag()
    private weak var coordinator: CreateProjectCoordinator?
    
    private var selectedFields: [String]
    private let dataStorage: ProjectDataStorage
    
    // MARK: - Init
    init(
        coordinator: CreateProjectCoordinator,
        selectedFields: [String],
        dataStorage: ProjectDataStorage
    ) {
        self.coordinator = coordinator
        self.selectedFields = selectedFields
        self.dataStorage = dataStorage
    }
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let field = selectedFields[0]
        selectedFields.removeFirst()   // 선택한 분야는 저장소에서 제거
        
        var requirement = MemberRequirement(field: field, recruitNumber: 0, requiredSkills: [], requirementText: "")
        
        let recruitNumber = input.recruitNumber
            .do(onNext: { number in
                requirement.recruitNumber = number
            })
            
        let techTags = input.techTags
            .do(onNext: { tags in
                requirement.requiredSkills = tags.map { $0.uppercased() }
            })
            
        input.requirementText
            .subscribe(onNext: { text in
                requirement.requirementText = text
            })
            .disposed(by: disposeBag)
                
        input.nextButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.dataStorage.updateMemberRequirements(with: requirement)
                
                if owner.selectedFields.isEmpty {
                    owner.coordinator?.showApplicantRestrictionViewController()
                    
                } else {
                    owner.coordinator?.showMemberRequirementInputViewController(
                        with: owner.selectedFields
                    )
                }
            })
            .disposed(by: disposeBag)
        
        let isNextButtonEnabled = Observable.combineLatest(
            input.recruitNumber.map { $0 > 0 },
            input.techTags.map { !$0.isEmpty },
            input.requirementText.map { !$0.isEmpty }
        )
        .map { recruitNumberIsValid, tagIsValid, requirementTextIsValid in
            return recruitNumberIsValid && tagIsValid && requirementTextIsValid
        }
                
        return Output(
            selectedField: Observable.just(FieldTagType(from: field).rawValue).asDriver(onErrorJustReturn: ""),
            recruitNumber: recruitNumber.asDriver(onErrorJustReturn: 0),
            techTags: techTags.asDriver(onErrorJustReturn: []),
            isNextButtonEnabled: isNextButtonEnabled.asDriver(onErrorJustReturn: false)
        )
    }
}

extension MemberRequirementInputViewModel {
    /// 유저에게 보이는 문자열로 맵핑처리
    enum FieldTagType: String {
        case ios = "iOS"
        case android = "안드로이드"
        case frontend = "프론트엔드"
        case backend = "백엔드"
        case uiux = "UI/UX"
        case bibx = "BI/BX"
        case videomotion = "영상/모션"
        case pm = "PM"
        
        init(from type: String) {
            switch type {
            case "ios": self = .ios
            case "android": self = .android
            case "frontend": self = .frontend
            case "backend": self = .backend
            case "uiux": self = .uiux
            case "bibx": self = .bibx
            case "videomotion": self = .videomotion
            case "pm": self = .pm
            default: self = .ios
            }
        }
    }
}
