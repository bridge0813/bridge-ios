//
//  Dropdown.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/01.
//

import UIKit
import RxSwift
import RxCocoa

// 출처: https://github.com/AssistoLab/DropDown

typealias Index = Int
typealias Closure = () -> Void

/// 드롭다운 선택했을 경우 넘겨주는 데이터
typealias DropdownItem = (indexRow: Index, title: String)

/// 드롭다운 항목의 셀을 구성할 때 사용되는 클로저.
typealias CellConfigurationClosure = (Index, String, UITableViewCell) -> Void

/// 화면상에서 드롭다운의 레이아웃을 계산할 때, 사용될 것으로 보이는 튜플. x, y좌표와 넓이, 그리고 화면 바깥 영역의 높이 값을 포함.
typealias ComputeLayoutTuple = (x: CGFloat, y: CGFloat, width: CGFloat, offscreenHeight: CGFloat)

final class DropDown: BaseView {
    
    // MARK: - 드롭다운 UI 구조
    /// 드롭다운 외부를 탭할 때, 드롭다운을 닫는 기능
    private let dismissableView = UIView()
    
    /// 테이블뷰를 포함하는 컨테이너 뷰
    private let tableViewContainer = UIView()
    
    /// 드롭다운 항목들을 표시하기 위한 UITableView
    private let tableView = UITableView()
    
    /// 드롭다운의 width가 정의되지 않았을 경우, cell 내부 컨텐츠의 크기에 맞게 적절하게 width를 계산
    private var templateCell: BaseDropdownCell?
    
    private weak var anchorView: AnchorView?
    private var bottomOffset: CGPoint
    private var dataSource: [String]
    
    // MARK: - 드롭다운 Cell 스타일
    private var cellHeight: CGFloat
    private var itemTextColor: UIColor
    private var itemTextFont: UIFont
    private var selectedItemTextColor: UIColor
    private var selectedItemBackgroundColor: UIColor
    private var separatorColor: UIColor
    private var tableViewBackgroundColor: UIColor
    
    // MARK: - 드롭다운 UI
    private var width: CGFloat?
    private var cornerRadius: CGFloat  // 테이블뷰, 컨테이너, 드롭다운 모두 적용
    private var shadowColor: UIColor
    private var shadowOffset: CGSize
    private var shadowOpacity: Float
    private var shadowRadius: CGFloat
    
    private var dimmedBackgroundColor: UIColor
    
    // MARK: - 드롭다운 애니메이션
    private var animationduration: Double
    private var downScaleTransform: CGAffineTransform
    
    
    // MARK: - 드롭다운 커스텀 셀
    private var customCellType: UITableViewCell.Type
    private var customCellConfiguration: CellConfigurationClosure?
    
    
    // MARK: - 액션
    let itemSelected = PublishSubject<DropdownItem>()  // 드롭다운 항목을 선택했을 경우
    let willShow = PublishSubject<Void>()              // 드롭다운이 보일 때
    let willHide = PublishSubject<Void>()              // 드롭다운이 사라질 때
    
    
    // MARK: - Properties
    private var heightConstraint: NSLayoutConstraint?  // DropDown의 높이(height)를 결정하는 제약 조건을 참조
    private var widthConstraint: NSLayoutConstraint?   // DropDown의 너비(width)를 결정하는 제약 조건을 참조
    private var xConstraint: NSLayoutConstraint?       // DropDown의 x 위치(수평 위치)를 결정하는 제약 조건을 참조
    private var yConstraint: NSLayoutConstraint?       // DropDown의 y 위치(수직 위치)를 결정하는 제약 조건을 참조

    /// 선택된 항목의 인덱스를 추적하기 위해 사용된다.
    var selectedItemIndexRow: Index?
    
    /// dataSource에 있는 모든 아이템들을 보여주기 위한 TableView의 높이
    private var tableHeight: CGFloat {
        return tableView.rowHeight * CGFloat(dataSource.count)
    }

    /// 드롭다운에서 표시될 수 있는 셀의 최소 높이를 제공
    var minHeight: CGFloat {
        return tableView.rowHeight
    }

    /// 드롭다운 뷰의 제약 조건이 설정되었는지 여부를 나타낸다. 중복적인 제약 조건의 추가를 방지하기 위해 플래그를 사용함(default: false)
    var didSetupConstraints = false

    
    // MARK: - 초기화
    /// 드롭다운의 초기화메서드로 기본적으로 anchorView와 dataSource를 필요로 합니다.
    /// - Parameters:
    ///   - anchorView: 드롭다운의 위치를 정하는 기준이되면서, 드롭다운을 트리거하는 역할의 뷰입니다.
    ///   - bottomOffset: 드롭다운과 anchorView의 간격을 조절하는 offset입니다.
    ///   - dataSource: 드롭다운 항목의 데이터소스입니다.
    ///   - cellHeight: 드롭다운 항목의 높이입니다.
    ///   - itemTextColor: 드롭다운 항목의 텍스트 컬러입니다.
    ///   - itemTextFont: 드롭다운 항목의 텍스트 폰트입니다.
    ///   - selectedItemTextColor: 드롭다운 항목이 선택되었을 때, 텍스트 컬러입니다.
    ///   - selectedItemBackgroundColor: 드롭다운 항목이 선택되었을 때, 배경 컬러입니다.
    ///   - separatorColor: 드롭다운 항목의 구분선 컬러입니다.
    ///   - dimmedBackgroundColor: 드롭다운이 등장할 때, 조절할 수 있는 전체화면의 컬러입니다.
    ///   - width: 드롭다운의 너비로 기본값은 anchorView.bounds.widht - bottomOffset.x 입니다.
    ///   - animationduration: 드롭다운이 등장하거나 사라질 때, 애니메이션의 지속기간입니다.
    ///   - downScaleTransform: 드롭다운의 등장효과를 위해 사용됩니다.
    ///   - customCellType: 드롭다운의 기본 셀을 사용하지 않고, 커스텀 셀을 적용하고 싶을 경우 사용됩니다.
    ///   - customCellConfiguration: 드롭다운의 커스텀 셀을 적용할 경우, 셀을 정의하기 위해 사용됩니다.
    init(
        anchorView: AnchorView,
        bottomOffset: CGPoint = .zero,
        dataSource: [String],
        cellHeight: CGFloat = DropdownConstant.DropdownUI.rowHeight,
        itemTextColor: UIColor = DropdownConstant.DropdownItem.textColor,
        itemTextFont: UIFont = DropdownConstant.DropdownItem.textFont,
        selectedItemTextColor: UIColor = DropdownConstant.DropdownItem.selectedTextColor,
        selectedItemBackgroundColor: UIColor = DropdownConstant.DropdownItem.selectedBackgroundColor,
        separatorColor: UIColor = DropdownConstant.DropdownUI.separatorColor,
        tableViewBackgroundColor: UIColor = .white,
        dimmedBackgroundColor: UIColor = .clear,
        width: CGFloat? = nil,
        backgroundColor: UIColor = DropdownConstant.DropdownUI.backgroundColor,
        cornerRadius: CGFloat = DropdownConstant.DropdownUI.cornerRadius,
        shadowColor: UIColor = DropdownConstant.DropdownUI.shadowColor,
        shadowOffset: CGSize = DropdownConstant.DropdownUI.shadowOffset,
        shadowOpacity: Float = DropdownConstant.DropdownUI.shadowOpacity,
        shadowRadius: CGFloat = DropdownConstant.DropdownUI.shadowRadius,
        animationduration: Double = DropdownConstant.Animation.duration,
        downScaleTransform: CGAffineTransform = DropdownConstant.Animation.downScaleTransform,
        customCellType: UITableViewCell.Type = BaseDropdownCell.self,
        customCellConfiguration: CellConfigurationClosure? = nil
    ) {
        self.anchorView = anchorView
        self.bottomOffset = bottomOffset
        self.dataSource = dataSource
        self.cellHeight = cellHeight
        self.itemTextColor = itemTextColor
        self.itemTextFont = itemTextFont
        self.selectedItemTextColor = selectedItemTextColor
        self.selectedItemBackgroundColor = selectedItemBackgroundColor
        self.separatorColor = separatorColor
        self.tableViewBackgroundColor = tableViewBackgroundColor
        self.dimmedBackgroundColor = dimmedBackgroundColor
        self.width = width
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.shadowOffset = shadowOffset
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius
        self.animationduration = animationduration
        self.downScaleTransform = downScaleTransform
        self.customCellType = customCellType
        self.customCellConfiguration = customCellConfiguration
        
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
    
    override func configureAttributes() {
        print(#function)
        
        DispatchQueue.main.async {
            self.updateConstraintsIfNeeded()
        }
        
        tableView.register(customCellType, forCellReuseIdentifier: BaseDropdownCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = cellHeight
        tableView.backgroundColor = tableViewBackgroundColor
        tableView.separatorColor = separatorColor
        tableView.layer.cornerRadius = cornerRadius
        tableView.clipsToBounds = true
        
        tableViewContainer.layer.masksToBounds = false
        tableViewContainer.layer.cornerRadius = cornerRadius
        tableViewContainer.layer.shadowColor = shadowColor.cgColor
        tableViewContainer.layer.shadowOffset = shadowOffset
        tableViewContainer.layer.shadowOpacity = shadowOpacity
        tableViewContainer.layer.shadowRadius = shadowRadius

        alpha = 0
        isHidden = true
        
        // dismissableView
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hide))
        dismissableView.addGestureRecognizer(gestureRecognizer)
        dismissableView.backgroundColor = dimmedBackgroundColor
    }
}

// MARK: - UI
extension DropDown {
    
    /// 뷰의 제약조건을 업데이트 할 필요가 있을 때 사용되는 메서드.
    override func updateConstraints() {
        print(#function)
        
        // 제약조건이 아직 설정되지 않았다면, 초기 제약 조건을 설정
        if !didSetupConstraints {
            setupConstraints()
        }
        
        didSetupConstraints = true  // 제약조건을 설정했으므로 true
        
        let layout = computeLayout()  // 현재 드롭다운의 레이아웃을 계산(드롭다운의 위치, 크기 등)
        
        // 계산된 레이아웃이 화면에 표시될 수 없는 경우
        if !layout.canBeDisplayed {
            super.updateConstraints()
            hide()  // 드롭다운 숨기기
            
            return
        }
        
        // 계산된 레이아웃 정보를 기반으로 각 제약 조건의 constant를 업데이트
        xConstraint?.constant = layout.x
        yConstraint?.constant = layout.y
        widthConstraint?.constant = layout.width
        heightConstraint?.constant = layout.visibleHeight
        
        // 드롭다운이 화면 밖으로 벗어나는 경우 스크롤이 가능하도록 설정
        tableView.isScrollEnabled = layout.offscreenHeight > 0
        
        // 스크롤 인디케이터를 잠깐 보여줌으로써 사용자가 스크롤할 수 있음을 알려줌
        DispatchQueue.main.async { [weak self] in
            self?.tableView.flashScrollIndicators()
        }
        
        super.updateConstraints()
    }
    
    /// 드롭다운의 서브 뷰들에 대한 레이아웃
    func setupConstraints() {
        print(#function)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        setDismissableViewConstraints()
        
        // Table view container
        addSubview(tableViewContainer)
        tableViewContainer.translatesAutoresizingMaskIntoConstraints = false

        xConstraint = NSLayoutConstraint(
            item: tableViewContainer,  // tableViewContainer에 제약조건을 적용
            attribute: .leading,       // tableViewContainer의 leading 부분에 제약조건을 적용
            relatedBy: .equal,         // tableViewContainer의 leading이 드롭다운 뷰의 leading과 동일하도록
            toItem: self,
            attribute: .leading,       // 드롭다운 뷰의 leading 부분을 참조
            multiplier: 1,             // 제약조건의 스케일을 조절
            constant: 0                // 제약조건에 추가될 상수 값
        )
        addConstraint(xConstraint ?? NSLayoutConstraint())  // 드롭다운 뷰에 해당 제약 조건을 추가

        yConstraint = NSLayoutConstraint(
            item: tableViewContainer,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1,
            constant: 0
        )
        addConstraint(yConstraint ?? NSLayoutConstraint())

        widthConstraint = NSLayoutConstraint(
            item: tableViewContainer,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,                 // width를 다른 뷰의 속성과 연관시키지 않음
            attribute: .notAnAttribute,  // width를 다른 뷰의 속성과 연관시키지 않음
            multiplier: 1,
            constant: 0
        )
        tableViewContainer.addConstraint(widthConstraint ?? NSLayoutConstraint())

        heightConstraint = NSLayoutConstraint(
            item: tableViewContainer,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,                 // height를 다른 뷰의 속성과 연관시키지 않음
            attribute: .notAnAttribute,  // height를 다른 뷰의 속성과 연관시키지 않음
            multiplier: 1,
            constant: 0
        )
        tableViewContainer.addConstraint(heightConstraint ?? NSLayoutConstraint())
        setTableViewConstraints()
    }
    
    func setDismissableViewConstraints() {
        addSubview(dismissableView)
        dismissableView.translatesAutoresizingMaskIntoConstraints = false

        dismissableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        dismissableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        dismissableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        dismissableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func setTableViewConstraints() {
        tableViewContainer.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.leadingAnchor.constraint(equalTo: tableViewContainer.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: tableViewContainer.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: tableViewContainer.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: tableViewContainer.bottomAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        print("layoutSubviews")
        
        let shadowPath = UIBezierPath(roundedRect: tableViewContainer.bounds, cornerRadius: cornerRadius)
        tableViewContainer.layer.shadowPath = shadowPath.cgPath
    }
    
    /// 드롭다운의 레이아웃을 계산
    func computeLayout() -> (
        x: CGFloat,                // 드롭다운의 시작 x위치
        y: CGFloat,                // 드롭다운의 시작 y위치
        width: CGFloat,            // 드롭다운의 width
        offscreenHeight: CGFloat,  // 화면 밖으로 나가는 드롭다운의 높이
        visibleHeight: CGFloat,    // 화면에 보일 수 있는 드롭다운의 높이
        canBeDisplayed: Bool       // 드롭다운이 현재의 레이아웃에서 보여질 수 있는지의 여부
    ) {
        var layout: ComputeLayoutTuple = (0, 0, 0, 0)  // 기본적인 레이아웃의 값
        
        // 현재 화면의 주 윈도우 가져오기.
        guard let window = UIWindow.visibleWindow() else { return (0, 0, 0, 0, 0, false) }

        // 드롭다운이 UIBarButtonItem과 연결된 경우 처리
        if let anchorView = anchorView as? UIBarButtonItem {
            bottomOffset = computeLayoutForBarButtonItem(anchorView: anchorView, window: window)
        }
        
        layout = computeLayoutBottomDisplay(window: window)  // 드롭다운 레이아웃 계산
                
        // 드롭다운의 width가 드롭다운이 차지할 수 있는 최대크기를 계산하여 적절하게 설정.
        constraintWidthToFittingSizeIfNecessary(layout: &layout)
        
        // 드롭다운의 width가 화면의 경계 내에 있도록 설정.(화면을 넘기지 않도록)
        constraintWidthToBoundsIfNecessary(layout: &layout, in: window)
        
        let visibleHeight = tableHeight - layout.offscreenHeight  // 화면에 실제로 보일 수 있는 드롭다운의 높이를 계산
        let canBeDisplayed = visibleHeight >= minHeight           // 드롭다운이 화면에 표시될 수 있는지(셀의 rowHeight)

        return (layout.x, layout.y, layout.width, layout.offscreenHeight, visibleHeight, canBeDisplayed)
    }
    
    /// anchorView가 UIBarButtonItem일 경우, 드롭다운 레이아웃 계산 메서드(bottomOffset을 지정)
    func computeLayoutForBarButtonItem(anchorView: UIBarButtonItem, window: UIWindow) -> CGPoint {
        // UIBarButton이 right 버튼인지 체크
        let anchorViewFrame = anchorView.plainView.convert(anchorView.plainView.bounds, to: window)
        let isRightBarButtonItem = anchorViewFrame.minX > window.frame.midX
        
        // 만약 오른쪽 버튼이 아니라면, CGPoint.zero 반환
        guard isRightBarButtonItem else { return CGPoint.zero }
        
        let width = width ?? fittingWidth()                // 드롭다운의 width를 설정하거나 적절한 width를 계산하여 가져옴
        let anchorViewWidth = anchorView.plainView.frame.width  // anchorView의 width를 가져옴
        
        let x = -(width - anchorViewWidth) - 8

        return CGPoint(x: x, y: -5)
    }
    
    /// 아래 방향으로 표시되는 드롭다운의 x, y, width, offscreenHeight
    func computeLayoutBottomDisplay(window: UIWindow) -> ComputeLayoutTuple {
        var offscreenHeight: CGFloat = 0  // 드롭다운의 일부가 화면 밖에 나가는 높이
        
        // 만약 드롭다운의 width가 설정되어 있다면 그 값을 사용하고,
        // 설정된 값이 없다면 앵커 뷰의 width나 fittingWidth()에서 bottomOffset.x 를 뺀 값이 최종 width
        let width = width ?? (anchorView?.plainView.bounds.width ?? fittingWidth()) - bottomOffset.x
        
        // 앵커뷰의 x와 y 좌표
        let anchorViewX = anchorView?.plainView.windowFrame?.minX ?? window.frame.midX - (width / 2)
        let anchorViewY = anchorView?.plainView.windowFrame?.maxY ?? window.frame.midY - (tableHeight / 2)
        
        // 드롭다운의 x,y 좌표 계산
        let x = anchorViewX + bottomOffset.x
        let y = anchorViewY + bottomOffset.y
        
        // 화면 밖으로 나가는 높이 계산
        let maxY = y + tableHeight
        let windowMaxY = window.bounds.maxY

        if maxY > windowMaxY {
            offscreenHeight = abs(maxY - windowMaxY)
        }
        
        return (x, y, width, offscreenHeight)
    }
    
    /// 드롭다운의 항목 중 width가 가장 높은 아이템의 width를 계산하여 반환
    func fittingWidth() -> CGFloat {
        if templateCell == nil {
            templateCell = tableView.dequeueReusableCell(withIdentifier: BaseDropdownCell.identifier) as? BaseDropdownCell
        }
        
        var maxWidth: CGFloat = 0
        
        for index in 0..<dataSource.count {
            
            if let customCell = templateCell {
                customCell.optionLabel.text = dataSource[index]
                customCell.bounds.size.height = cellHeight
                
                // templateCell과 내부 서브뷰들이 제약조건을 만족하면서 차지할 수 있는 최소한의 크기를 계산
                let width = customCell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width
                
                if width > maxWidth {
                    maxWidth = width
                }
            }else {
                print("templateCell 없음")
            }
        }
        return maxWidth
    }
    
    /// 드롭다운의 width가 화면 밖으로 넘어서지 않도록
    func constraintWidthToBoundsIfNecessary(layout: inout ComputeLayoutTuple, in window: UIWindow) {
        let windowMaxX = window.bounds.maxX  // 화면의 오른쪽 가장자리의 x좌표 값
        let maxX = layout.x + layout.width   // 드롭다운의 오른쪽 가장자리의 x좌표 값
        
        // 드롭다운이 화면 밖으로 나가는지 확인
        if maxX > windowMaxX {
            let delta = maxX - windowMaxX     // 드롭다운이 화면 밖으로 얼마나 나갔는지 계산
            let newOrigin = layout.x - delta  // 밖으로 나간만큼 드롭다운의 x좌표를 왼쪽으로 이동시킴
            
            if newOrigin > 0 {
                layout.x = newOrigin
                
            } else {
                // 드롭다운의 왼쪽 가장자리가 화면 밖으로 나갔을 때 처리
                layout.x = 0
                layout.width += newOrigin  // 화면으로 나가는 만큼 width도 줄여줘야 화면 안에 드롭다운이 완전히 들어오게 된다.
            }
        }
    }
    
    /// 드롭다운의 width가 컨텐츠에 맞게 적합한 width를 가지도록
    func constraintWidthToFittingSizeIfNecessary(layout: inout ComputeLayoutTuple) {
        guard width == nil else { return }  // 이미 width가 설정되어있다면 함수종료
        
        if layout.width < fittingWidth() {
            layout.width = fittingWidth()
        }
    }
}

// MARK: - Actions
extension DropDown {
    /**
    Shows the drop down if enough height.

    - returns: Wether it succeed and how much height is needed to display all cells at once.
    */
    @discardableResult
    func show() -> (canBeDisplayed: Bool, offscreenHeight: CGFloat?) {
        
        willShow.onNext(())

        setNeedsUpdateConstraints()  // 레이아웃 제약조건이 업데이트되도록

        print("show")
        setDropdownConstraints()  // 드롭다운 레이아웃 배치
        
        let layout = computeLayout()

        if !layout.canBeDisplayed {
            hide()
        }

        isHidden = false
        
        tableViewContainer.transform = downScaleTransform
        
        UIView.animate(
            withDuration: animationduration,
            animations: { [weak self] in
                self?.alpha = 1
                self?.tableViewContainer.transform = .identity
            }
        )

        return (layout.canBeDisplayed, layout.offscreenHeight)
    }
    
    func setDropdownConstraints() {
        let visibleWindow = UIWindow.visibleWindow() ?? UIWindow()
        visibleWindow.addSubview(self)
        visibleWindow.bringSubviewToFront(self)  // 드롭다운을 윈도우의 최상단으로 이동.

        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: visibleWindow.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: visibleWindow.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: visibleWindow.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: visibleWindow.bottomAnchor).isActive = true
    }
    
    /// 드롭다운을 숨길 때 사용되는 메서드
    @objc
    func hide() {
        // 현재 드롭다운이 이미 숨겨져 있으면, 메서드 종료
        if isHidden {
            return
        }

        UIView.animate(
            withDuration: animationduration,
            animations: { [weak self] in
                self?.alpha = 0
            },
            completion: { [weak self] _ in
                guard let self else { return }
                
                self.isHidden = true
                self.removeFromSuperview()
                UIAccessibility.post(notification: .screenChanged, argument: nil)
            }
        )
        
        willHide.onNext(())
    }
}

// MARK: - UITableView
extension DropDown {
    /// 모든 셀을 다시 로드하는 메서드로 'dataSource', 'textColor', 'textFont', 'selectionBackgroundColor' and 'cellConfiguration' 에 대한 변경 사항이 있을 때마다 호출된다.
    func reloadAllComponents() {
        DispatchQueue.executeOnMainThread {
            self.tableView.reloadData()
            self.setNeedsUpdateConstraints()
        }
    }
}

// MARK: - UITableViewDataSource
extension DropDown: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: BaseDropdownCell.identifier,
            for: indexPath
        ) as? BaseDropdownCell else { return UITableViewCell() }
        
        cell.optionLabel.text = dataSource[indexPath.row]
        cell.optionLabel.textColor = itemTextColor
        cell.optionLabel.font = itemTextFont
        cell.selectedBackgroundColor = selectedItemBackgroundColor
        cell.configureCell()
        cell.selectionStyle = .none
        
        customCellConfiguration?(indexPath.row, dataSource[indexPath.row], cell)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DropDown: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.isSelected = selectedItemIndexRow == indexPath.row
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedItemIndexRow = indexPath.row
        
        itemSelected.onNext((indexRow: indexPath.row, title: dataSource[indexPath.row]))
        
        // 앵커뷰가 UIBarButton일 때 경우 메뉴처럼 사용되기 때문에 선택된 Cell이 무엇인지 표시 할 필요가 없음.
        if anchorView as? UIBarButtonItem != nil {
            selectedItemIndexRow = nil
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        hide()  // 새로운 항목을 선택했으면 숨기기.
    }
}
