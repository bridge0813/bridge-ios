//
//  ProjectCollectionViewCell.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/02.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class ProjectCollectionViewCell: BaseCollectionViewCell {
    // MARK: - Properties
    private let projectBackgroundView = UIView()
    
    private let titleLabel = UILabel()
    private let dDayLabel = UILabel()
    
    private let tagLabel1 = UILabel()
    private let tagLabel2 = UILabel()
    
    private let personImageView = UIImageView()
    private let recruitsLabel = UILabel()
    
    private let rectangleImageView = UIImageView()
    private let periodLabel = UILabel()
    
    private let scrapButton = UIButton()

    func bind(_ chatRoom: Driver<Project>) {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = ""
        dDayLabel.text = ""
        tagLabel1.text = ""
        tagLabel2.text = ""
        recruitsLabel.text = ""
        disposeBag = DisposeBag()
    }
    
    // MARK: - Configurations
    override func configureLayouts() {
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.numberOfLines = 2
        
        dDayLabel.textColor = .blue
        dDayLabel.font = .systemFont(ofSize: 13.5)
        dDayLabel.clipsToBounds = true
        dDayLabel.layer.cornerRadius = 13
        dDayLabel.layer.borderColor = UIColor.blue.cgColor
        dDayLabel.layer.borderWidth = 1
        dDayLabel.textAlignment = .center
        
        tagLabel1.textColor = .darkGray
        tagLabel1.font = .systemFont(ofSize: 13.5)
        tagLabel1.clipsToBounds = true
        tagLabel1.layer.cornerRadius = 13
        tagLabel1.layer.borderColor = UIColor.darkGray.cgColor
        tagLabel1.layer.borderWidth = 1
        tagLabel1.textAlignment = .center
        
        tagLabel2.textColor = .darkGray
        tagLabel2.font = .systemFont(ofSize: 13.5)
        tagLabel2.clipsToBounds = true
        tagLabel2.layer.cornerRadius = 13
        tagLabel2.layer.borderColor = UIColor.darkGray.cgColor
        tagLabel2.layer.borderWidth = 1
        tagLabel2.textAlignment = .center
        
        personImageView.image = UIImage(systemName: "person.fill")
        personImageView.backgroundColor = .clear
        personImageView.tintColor = .darkGray
        
        recruitsLabel.textColor = .darkGray
        recruitsLabel.font = .boldSystemFont(ofSize: 15)
        
        rectangleImageView.image = UIImage(systemName: "rectangle.fill")
        rectangleImageView.backgroundColor = .clear
        rectangleImageView.tintColor = .darkGray
        
        periodLabel.textColor = .darkGray
        periodLabel.font = .boldSystemFont(ofSize: 15)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        let buttonImage = UIImage(systemName: "star", withConfiguration: imageConfig)
        scrapButton.setImage(buttonImage, for: .normal)
        scrapButton.tintColor = .gray
        
        addSubview(projectBackgroundView)
        projectBackgroundView.backgroundColor = .white
        projectBackgroundView.layer.cornerRadius = 10
        projectBackgroundView.layer.shadowColor = UIColor.black.cgColor
        projectBackgroundView.layer.shadowOpacity = 0.5
        projectBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        projectBackgroundView.layer.shadowRadius = 1.0
        projectBackgroundView.layer.masksToBounds = false
        
        projectBackgroundView.flex.direction(.column).padding(5).define { flex in
            flex.addItem().direction(.row).justifyContent(.spaceBetween).define { flex in
                flex.addItem(titleLabel).height(50).width(150).marginTop(10).marginLeft(15)
                flex.addItem(dDayLabel).width(60).height(25).marginTop(10).marginRight(15)
            }
            
            flex.addItem().direction(.row).alignItems(.center).marginTop(10).define { flex in
                flex.addItem(tagLabel1).width(60).height(25).marginLeft(15)
                flex.addItem(tagLabel2).width(60).height(25).marginLeft(8)
            }
            
            flex.addItem().grow(1)  // 빈 공간을 채우는 아이템 추가
            
            flex.addItem().direction(.row).marginBottom(10).justifyContent(.spaceBetween).define { flex in
                flex.addItem().direction(.row).alignItems(.center).define { flex in
                    flex.addItem(personImageView).size(15).marginLeft(15)
                    flex.addItem(recruitsLabel).marginLeft(5)
                }
                
                flex.addItem().direction(.row).alignItems(.center).define { flex in
                    flex.addItem(rectangleImageView).size(15)
                    flex.addItem(periodLabel).marginLeft(5)
                }
                
                flex.addItem(scrapButton).size(23).marginRight(15)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        projectBackgroundView.pin.all().margin(10)
        projectBackgroundView.flex.layout()
    }
}

// MARK: - Configuration
extension ProjectCollectionViewCell {
    func configureCell(with project: Project) {
        titleLabel.text = project.title
        dDayLabel.text = "D-\(project.dDays)"
        tagLabel1.text = project.recruitmentField[0]
        tagLabel2.text = project.techStackTags[0]
        recruitsLabel.text = "\(project.numberOfRecruits)명 모집"
        periodLabel.text = "\(project.startDate)-\(project.endDate)"
    }
}
