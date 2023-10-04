//
//  Dropdown.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/01.
//

import UIKit

typealias Index = Int
typealias Closure = () -> Void

/// 사용자가 드롭다운 항목을 선택했을 때, 호출되는 클로저를 의미. 선택된 항목의 인덱스와 문자열 값을 받음.
typealias SelectionClosure = (Index, String) -> Void

/// 사용자가 여러 드롭다운 항목을 선택했을 때, 호출되는 클로저를 의미.
typealias MultiSelectionClosure = ([Index], [String]) -> Void

/// 각 항목을 구성할 때, 사용되는 클로저로, 항목의 인덱스와 기본 문자열을 받아 수정된 문자열을 반환
typealias ConfigurationClosure = (Index, String) -> String

/// 드롭다운 항목의 셀을 구성할 때 사용되는 클로저.
typealias CellConfigurationClosure = (Index, String, UITableViewCell) -> Void

/// 화면상에서 드롭다운의 레이아웃을 계산할 때, 사용될 것으로 보이는 튜플. x, y좌표와 넓이, 그리고 화면 바깥 영역의 높이 값을 포함.
typealias ComputeLayoutTuple = (x: CGFloat, y: CGFloat, width: CGFloat, offscreenHeight: CGFloat)


protocol AnchorView: AnyObject {

    var plainView: UIView { get }  // 드롭다운의 앵커(고정점)로 사용될 UIView 객체를 반환
}

extension UIView: AnchorView {

    // UIView 인스턴스 자체가 드롭다운의 앵커(고정점)로 사용된다.
    var plainView: UIView {
        return self
    }
}

extension UIBarButtonItem: AnchorView {
    var plainView: UIView {
        return value(forKey: "view") as? UIView ?? UIView()
    }
}

final class DropDown: UIView {
    
    /// 드롭다운이 어떻게 닫힐지 결정하는 모드.
    enum DismissMode {
        
        /// A tap outside the drop down is required to dismiss.
        case onTap
        
        /// No tap is required to dismiss, it will dimiss when interacting with anything else.
        case automatic
        
        /// Not dismissable by the user.
        case manual
    }
    
    /// 드롭다운이 어느 방향으로 나타날지를 결정하는 방향을 정의.
    enum Direction {
        
        /// The drop down will show below the anchor view when possible, otherwise above if there is more place than below.
        case any
        
        /// The drop down will show above the anchor view or will not be showed if not enough space.
        case top
        
        /// The drop down will show below or will not be showed if not enough space.
        case bottom
    }
    
    // MARK: - Properties
    /// 현재 화면에 표시되고 있는 Dropdown 인스턴스를 참조하는 프로퍼티로 현재 활성화된 드롭다운을 추적한다.
    static weak var VisibleDropDown: DropDown?

    
    // MARK: - UI
    
    /// 드롭다운 외부를 탭할 때, 드롭다운을 닫는 기능을 제공할 것으로 추정됨.
    let dismissableView = UIView()
    
    /// 테이블뷰를 포함하게 될 컨테이너 뷰
    let tableViewContainer = UIView()
    
    /// 드롭다운 항목들을 표시하기 위한 UITableView
    let tableView = UITableView()
    
    /// 실제 표시하기 전에 셀의 레이아웃 및 크기를 계산하는 데 사용될 것으로 보임.
    var templateCell: UITableViewCell!
    
    // TODO: - 화살표 이미지는 직접 커스텀이미지를 사용할 예정이라 없어도 될 듯?
    /// 드롭다운 위에 위치하는 화살표를 표시하는 UIImageView
    /// 코드에서는 직접 이미지를 그리는 방식으로 화살표 이미지를 생성하고 있음.
    lazy var arrowIndication: UIImageView = {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 20, height: 10), false, 0)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 10))
        path.addLine(to: CGPoint(x: 20, y: 10))
        path.addLine(to: CGPoint(x: 10, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 10))
        UIColor.black.setFill()
        path.fill()
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let tintImg = img?.withRenderingMode(.alwaysTemplate)
        let imgv = UIImageView(image: tintImg)
        imgv.frame = CGRect(x: 0, y: -10, width: 15, height: 10)
        return imgv
    }()
    
    /// 앞서 설명했던 AnchorView 프로토콜을 채택하는 객체
    /// 드롭다운이 표시될 기준점이 되는 UIView나 UIBarButtonItem을 나타냄.
    /// anchorView의 값이 설정될 때마다 setNeedsUpdateConstraints()을 통해 레이아웃 제약 조건을 업데이트하도록 요청한다.
    weak var anchorView: AnchorView? {
        didSet { setNeedsUpdateConstraints() }
    }

    /// 드롭다운이 표시될 방향을 결정하는데, 초기값을 .any로 설정 (드롭다운이 가능한 경우 아래로, 그렇지 않은 경우 위로 표시되도록)
    var direction = Direction.any

    
    // MARK: - 드롭다운의 정확한 위치를 결정하는 데 사용되는 프로퍼티
    
    /// 드롭다운이 anchorView 위에 표시될 때, 적용되는 상대적인 오프셋을 나타낸다.
    /// 기본적으로 드롭다운은 anchorView의 왼쪽 상단 모서리에 표시되므로, 기본 오프셋은 (0, 0) 이다.
    ///  topOffset의 값이 변경될 때마다, 레이아웃 제약조건을 업데이트하도록 요청한다.
    var topOffset: CGPoint = .zero {
        didSet { setNeedsUpdateConstraints() }
    }

    /// 드롭다운이 anchorView 아래에 표시될 때 적용되는 상대적인 오프셋을 나타낸다.
    var bottomOffset: CGPoint = .zero {
        didSet { setNeedsUpdateConstraints() }
    }

    /// 드롭다운이 anchorView 아래에 표시되고, 키보드가 숨겨져 있을 때, 적용되는 윈도우 하단으로부터의 오프셋을 나타낸다.
    var offsetFromWindowBottom = CGFloat(0) {
        didSet { setNeedsUpdateConstraints() }
    }
    
    /// 드롭다운의 width를 나타낸다.
    /// 기본값은 'anchorView.bounds.width - offset.x' 로 anchorView의 너비에서 x오프셋을 뺀 값.
    /// width의 값이 변경될 때마다 레이아웃의 제약조건을 업데이트하도록 요청한다.
    var width: CGFloat? {
        didSet { setNeedsUpdateConstraints() }
    }

    /// 드롭다운 화살표의 x 위치를 결정한다.
    /// arrowIndicationX 값이 주어진 경우, 'arrowIndication' 이미지뷰가 'tableViewContainer' 에 추가되며,
    /// arrowIndication의 x 위치는 arrowIndicationX 값으로 설정된다.
    var arrowIndicationX: CGFloat? {
        didSet {
            if let arrowIndicationX = arrowIndicationX {
                tableViewContainer.addSubview(arrowIndication)
                arrowIndication.tintColor = tableViewBackgroundColor
                arrowIndication.frame.origin.x = arrowIndicationX
            } else {
                arrowIndication.removeFromSuperview()
            }
        }
    }
    
    // MARK: - 드롭다운의 위치와 크기를 동적으로 결정하고 조절하는 데 사용
    var heightConstraint: NSLayoutConstraint!  // DropDown의 높이(height)를 결정하는 제약 조건을 참조
    var widthConstraint: NSLayoutConstraint!   // DropDown의 너비(width)를 결정하는 제약 조건을 참조
    var xConstraint: NSLayoutConstraint!       // DropDown의 x 위치(수평 위치)를 결정하는 제약 조건을 참조
    var yConstraint: NSLayoutConstraint!       // DropDown의 y 위치(수직 위치)를 결정하는 제약 조건을 참조

    
    // MARK: - Appearance
    
    /// 기본값은 'DPDConstant.UI.RowHeight' 이며, 새 값을 지정하면 해당 값으로 설정되며, 새 값이 설정된 후에 드롭다운의 모든 컴포넌트를 다시 로드.
    @objc dynamic var cellHeight = DropdownConstant.DropdownUI.rowHeight {
        willSet { tableView.rowHeight = newValue }
        didSet { reloadAllComponents() }
    }

    @objc dynamic var tableViewBackgroundColor = DropdownConstant.DropdownUI.backgroundColor {
        willSet {
            tableView.backgroundColor = newValue
            if arrowIndicationX != nil { arrowIndication.tintColor = newValue }
        }
    }

    override var backgroundColor: UIColor? {
        get { return tableViewBackgroundColor }
        set { tableViewBackgroundColor = newValue ?? BridgeColor.primary1 }
    }

    /// 드롭다운 뒤의 어둡게 처리된 배경의 색상을 나타낸다.
    var dimmedBackgroundColor = UIColor.clear {
        willSet { super.backgroundColor = newValue }
    }

    /// 드롭다운 내에서 선택된 셀의 배경색을 나타낸다.
    @objc dynamic var selectionBackgroundColor = DropdownConstant.DropdownItem.selectedBackgroundColor

    /// 드롭다운 내의 셀들 사이의 구분선 색상을 나타낸다.
    @objc dynamic var separatorColor = DropdownConstant.DropdownUI.separatorColor {
        willSet { tableView.separatorColor = newValue }
        didSet { reloadAllComponents() }
    }
    
    
    // MARK: - Radius
    /// 드롭다운의 cornerRadius
    @objc
    dynamic var cornerRadius = DropdownConstant.DropdownUI.cornerRadius {
        willSet {
            tableViewContainer.layer.cornerRadius = newValue
            tableView.layer.cornerRadius = newValue
        }
        didSet { reloadAllComponents() }
    }

    /// cornerRadius 속성 변경 메서드
    @objc
    dynamic func setupCornerRadius(_ radius: CGFloat) {
        tableViewContainer.layer.cornerRadius = radius
        tableView.layer.cornerRadius = radius
        reloadAllComponents()
    }

    /// 원하는 모서리만 둥글게 설정하는 메서드
    @objc
    dynamic func setupMaskedCorners(_ cornerMask: CACornerMask) {
        tableViewContainer.layer.maskedCorners = cornerMask
        tableView.layer.maskedCorners = cornerMask
        reloadAllComponents()
    }
    
    // MARK: - 그림자
    /// 드롭다운의 그림자 색상
    @objc dynamic var shadowColor = DropdownConstant.DropdownUI.shadowColor {
        willSet { tableViewContainer.layer.shadowColor = newValue.cgColor }
        didSet { reloadAllComponents() }
    }

    /// 드롭다운의 그림자가 그려지는 위치의 x와 y 방향의 오프셋을 결정.
    @objc dynamic var shadowOffset = DropdownConstant.DropdownUI.shadowOffset {
        willSet { tableViewContainer.layer.shadowOffset = newValue }
        didSet { reloadAllComponents() }
    }

    /// 그림자의 투명도
    @objc dynamic var shadowOpacity = DropdownConstant.DropdownUI.shadowOpacity {
        willSet { tableViewContainer.layer.shadowOpacity = newValue }
        didSet { reloadAllComponents() }
    }

    /// 그림자의 radius. 그림자가 퍼져나가는 정도를 결정
    @objc dynamic var shadowRadius = DropdownConstant.DropdownUI.shadowRadius {
        willSet { tableViewContainer.layer.shadowRadius = newValue }
        didSet { reloadAllComponents() }
    }
    
    // MARK: - 애니메이션
    /// 드롭다운을 보이거나 숨길 때, 애니메이션의 지속 시간
    @objc dynamic var animationduration = DropdownConstant.Animation.duration

    /// 드롭다운이 나타날 때의 애니메이션 옵션 전역 변수
    static var animationEntranceOptions = DropdownConstant.Animation.entranceOptions
    
    /// 드롭다운이 사라질 때의 애니메이션 옵션 전역 변수
    static var animationExitOptions = DropdownConstant.Animation.exitOptions
    
    var animationEntranceOptions: UIView.AnimationOptions = DropDown.animationEntranceOptions
    var animationExitOptions: UIView.AnimationOptions = DropDown.animationExitOptions
    
    /// 드롭다운이 나타나는 동안 tableViewContainer에 적용되는 변형을 나타낸다.
    /// 예를들어, 드롭다운이 나타나는 동안 테이블 뷰가 원래 크기의 90%로 축소되는 애니메이션 효과를 주고 싶다면 0.9, 0.9가 될 것이다.
    var downScaleTransform = DropdownConstant.Animation.downScaleTransform {
        willSet { tableViewContainer.transform = newValue }
    }

    // MARK: - 텍스트 스타일
    
    /// 드롭다운의 각 셀에 표시되는 텍스트의 색상을 나타낸다.
    @objc dynamic var textColor = DropdownConstant.DropdownItem.textColor {
        didSet { reloadAllComponents() }
    }

    /// 드롭다운의 선택된 셀의 텍스트 색상을 나타낸다.
    @objc dynamic var selectedTextColor = DropdownConstant.DropdownItem.selectedTextColor {
        didSet { reloadAllComponents() }
    }
    
    /// 드롭다운의 각 셀에 표시되는 텍스트의 폰트를 나타낸다.
    @objc dynamic var textFont = DropdownConstant.DropdownItem.textFont {
        didSet { reloadAllComponents() }
    }
    
    /// 셀 설정
    var customCellClass: UITableViewCell.Type? {
        didSet {
            if let cellType = customCellClass {
                tableView.register(cellType, forCellReuseIdentifier: DropdownConstant.ReusableIdentifier.dropDownCell)
                templateCell = nil
                reloadAllComponents()
            }
        }
    }
    
    
    // MARK: - DataSource

    /// 드롭다운에 표시될 데이터 항목들을 포함하고 있음.
    var dataSource = [String]() {
        didSet {
            deselectRows(at: selectedRowIndices)  // 선택 상태 초기화
            reloadAllComponents()
        }
    }

    /// 다국어 지원 버전?
    var localizationKeysDataSource = [String]() {
        didSet {
            dataSource = localizationKeysDataSource.map { NSLocalizedString($0, comment: "") }
        }
    }
    
    /// 만약 드롭다운에서 여러 항목을 선택할 수 있는 경우, 그 선택된 항목들의 인덱스를 추적하기 위해 사용된다.
    var selectedRowIndices = Set<Index>()

    
    // MARK: - 셀의 Configuration
    /// 기본적으로 dataSource의 값을 그대로 사용하지만, 이를 통해 해당 텍스트의 표시 방식을 직접 설정할 수 있음.
    /// 예를들어, dataSource에 ["밥", "피자", "치킨"]이 있으면 ["나는 밥을 좋아해", "나는 피자를 좋아해", "나는 치킨을 좋아해"] 이런식으로 변형할 수 있음.
    var cellConfiguration: ConfigurationClosure? {
        didSet { reloadAllComponents() }
    }
    
    /// 인덱스, String, 그리고 UITableViewCell 객체를 매개변수로 받는데, 이를 통해 셀의 다른 UI 요소들도 구성할 수 있음.
    var customCellConfiguration: CellConfigurationClosure? {
        didSet { reloadAllComponents() }
    }
    
    // MARK: - 셀의 선택액션
    /// 사용자가 드롭다운의 특정항목을 선택했을 때, 실행될 액션을 정의하는 클로저
    var selectionAction: SelectionClosure?
    
    /// 사용자가 드롭다운의 여러 항목을 동시에 선택했을 때, 실행될 액션을 정의하는 클로저
    var multiSelectionAction: MultiSelectionClosure?

    
    // MARK: - 드롭다운이 표시될 때, 숨길 때의 액션
    var willShowAction: Closure?
    var cancelAction: Closure?

    
    // MARK: - 드롭다운이 어떻게 dismiss될 지를 결정
    /// 설정된 dismissMode 값이 .onTap일 경우, 탭 제스처 인식기를 'dismissableView' 에 추가하여 드롭다운 바깥을 탭할 때, dismiss 처리
    /// .onTap이 아니라면 탭 액션 제스처를 제거
    var dismissMode = DismissMode.onTap {
        willSet {
            if newValue == .onTap {
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissableViewTapped))
                dismissableView.addGestureRecognizer(gestureRecognizer)
                
            } else if let gestureRecognizer = dismissableView.gestureRecognizers?.first {
                dismissableView.removeGestureRecognizer(gestureRecognizer)
            }
        }
    }
    
    /// 드롭다운에서 표시될 수 있는 셀의 최소 높이를 제공
    var minHeight: CGFloat {
        return tableView.rowHeight
    }

    /// 드롭다운 뷰의 제약 조건이 설정되었는지 여부를 나타낸다. 중복적인 제약 조건의 추가를 방지하기 위해 플래그를 사용함(default: false)
    var didSetupConstraints = false

    
    // MARK: - 초기화 메서드
    
    deinit {
//        stopListeningToNotifications()  // 더 이상 시스템 알림을 수신하지 않도록
    }

    /// show() 메서드를 호출하기 전에 드롭다운이 작동하기 위한 필수 설정사항 dataSource, anchorView, selectionAction을 설정해야 함.
    convenience init() {
        self.init(frame: .zero)
    }
    
    /// anchorView - 드롭다운이 표시될 기준이 되는 뷰. 드롭다운은 이 뷰의 상단이나 하단에 나타나게 됨.
    /// selectionAction - 사용자가 드롭다운의 셀을 선택할 때, 실행될 액션.
    /// dataSource - 드롭다운에 표시될 텍스트 데이터의 배열
    /// topOffset - anchorView에 상대적인 오프셋으로, 드롭다운이 anchorView의 위쪽에 표시될 때 사용
    /// bottomOffset - anchorView에 상대적인 오프셋으로, 드롭다운이 anchorView의 아래쪽에 표시될 때 사용
    /// cellConfiguration - 셀의 텍스트 형식을 정의하는 클로저
    /// cancelAction - 유저가 드롭다운을 취소하거나 숨길 때, 실행되는 액션
    convenience init(
        anchorView: AnchorView,
        selectionAction: SelectionClosure? = nil,
        dataSource: [String] = [],
        topOffset: CGPoint? = nil,
        bottomOffset: CGPoint? = nil,
        cellConfiguration: ConfigurationClosure? = nil,
        cancelAction: Closure? = nil
    ) {
        self.init(frame: .zero)

        self.anchorView = anchorView
        self.selectionAction = selectionAction
        self.dataSource = dataSource
        self.topOffset = topOffset ?? .zero
        self.bottomOffset = bottomOffset ?? .zero
        self.cellConfiguration = cellConfiguration
        self.cancelAction = cancelAction
    }
    
    /// 주 초기화 메서드(designated init) setup() 을 통해 드롭다운과 관련된 초기 설정을 수행
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    public required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
}

// MARK: - Setup
private extension DropDown {
    
    func setup() {
        tableView.register(CustomDropdownCell.self)
        
        DispatchQueue.main.async {
            // HACK: If not done in dispatch_async on main queue `setupUI` will have no effect
            self.updateConstraintsIfNeeded()  // 제약조건이 업데이트되어야 한다면 updateConstraints() 호출
            self.setupUI()
        }
        
        tableView.rowHeight = cellHeight
        setHiddentState()
        isHidden = true
        
        dismissMode = .onTap
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        startListeningToKeyboard()
        
//        accessibilityIdentifier = "drop_down"
    }
    
    func setupUI() {
        super.backgroundColor = dimmedBackgroundColor

        tableViewContainer.layer.masksToBounds = false
        tableViewContainer.layer.cornerRadius = cornerRadius
        tableViewContainer.layer.shadowColor = shadowColor.cgColor
        tableViewContainer.layer.shadowOffset = shadowOffset
        tableViewContainer.layer.shadowOpacity = shadowOpacity
        tableViewContainer.layer.shadowRadius = shadowRadius

        tableView.backgroundColor = tableViewBackgroundColor
        tableView.separatorColor = separatorColor
        tableView.layer.cornerRadius = cornerRadius
        tableView.layer.masksToBounds = true
    }
    
}

// MARK: - UI
extension DropDown {
    
    /// 뷰의 제약조건을 업데이트할 필요가 있을 때 사용되는 메서드.
    override func updateConstraints() {
        // 제약조건이 아직 설정되지 않았다면, 초기 제약 조건을 설정
        if !didSetupConstraints {
            setupConstraints()
        }
        
        didSetupConstraints = true  // 제약조건을 설정했으므로 true
        
        let layout = computeLayout()  // 현재 드롭다운의 레이아웃을 계산(드롭다운의 위치, 크기 등)
        
        // 계산된 레이아웃이 화면에 표시될 수 없는 경우
        if !layout.canBeDisplayed {
            super.updateConstraints()  // 기본적인 updateConstraints() 메서드 호출
            hide()                     // 드롭다운 숨기기
            
            return
        }
        
        // 계산된 레이아웃 정보를 기반으로 각 제약 조건의 constant를 업데이트
        xConstraint.constant = layout.x
        yConstraint.constant = layout.y
        widthConstraint.constant = layout.width
        heightConstraint.constant = layout.visibleHeight
        
        // 드롭다운이 화면 밖으로 벗어나는 경우 스크롤이 가능하도록 설정
        tableView.isScrollEnabled = layout.offscreenHeight > 0
        
        // 스크롤 인디케이터를 잠깐 보여줌으로써 사용자가 스크롤할 수 있음을 알려줌
        DispatchQueue.main.async { [weak self] in
            self?.tableView.flashScrollIndicators()
        }
        
        // 기본 제약 조건 업데이트 동작
        super.updateConstraints()
    }
    
    /// 드롭다운의 서브 뷰들에 대한 레이아웃 배치
    func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false

        // Dismissable view
        addSubview(dismissableView)
        dismissableView.translatesAutoresizingMaskIntoConstraints = false

        // dismissableView가 드롭다운 뷰의 양쪽 가장자리에 맞춰지도록
        addUniversalConstraints(format: "|[dismissableView]|", views: ["dismissableView": dismissableView])

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
        addConstraint(xConstraint)  // 드롭다운 뷰에 해당 제약 조건을 추가

        yConstraint = NSLayoutConstraint(
            item: tableViewContainer,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1,
            constant: 0
        )
        addConstraint(yConstraint)

        widthConstraint = NSLayoutConstraint(
            item: tableViewContainer,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,                 // width를 다른 뷰의 속성과 연관시키지 않음
            attribute: .notAnAttribute,  // width를 다른 뷰의 속성과 연관시키지 않음
            multiplier: 1,
            constant: 0
        )
        tableViewContainer.addConstraint(widthConstraint)

        heightConstraint = NSLayoutConstraint(
            item: tableViewContainer,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,                 // height를 다른 뷰의 속성과 연관시키지 않음
            attribute: .notAnAttribute,  // height를 다른 뷰의 속성과 연관시키지 않음
            multiplier: 1,
            constant: 0
        )
        tableViewContainer.addConstraint(heightConstraint)

        // Table view
        tableViewContainer.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableViewContainer.addUniversalConstraints(format: "|[tableView]|", views: ["tableView": tableView])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        // 방향이 변경되면 layoutSubviews가 호출됩니다
        // 위치를 업데이트하기 위해 제약 조건을 업데이트합니다
        setNeedsUpdateConstraints()

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
        canBeDisplayed: Bool,      // 드롭다운이 현재의 레이아웃에서 보여질 수 있는지의 여부
        Direction: Direction       // 드롭다운의 표시 위치
    ) {
        var layout: ComputeLayoutTuple = (0, 0, 0, 0)  // 기본적인 레이아웃의 값
        var direction = self.direction

        // 현재 화면의 주 윈도우 가져오기.
        guard let window = UIWindow.visibleWindow() else { return (0, 0, 0, 0, 0, false, direction) }

        // 드롭다운이 UIBarButtonItem과 연결된 경우 처리
        barButtonItemCondition: if let anchorView = anchorView as? UIBarButtonItem {
            
            // anchorView의 시작위치가 윈도우의 중앙보다 오른쪽에 있는지 확인(오른쪽 버튼인지 확인)
            let isRightBarButtonItem = anchorView.plainView.frame.minX > window.frame.midX

            // 만약 오른쪽 버튼이 아니라면, 나머지 부분을 건너뜀
            guard isRightBarButtonItem else { break barButtonItemCondition }

            let width = self.width ?? fittingWidth()                // 드롭다운의 width를 설정하거나 적절한 width를 계산하여 가져옴
            let anchorViewWidth = anchorView.plainView.frame.width  // anchorView의 width를 가져옴
            
            // 드롭다운의 시작 x위치를 드롭다운의 width와 버튼의 width 차이로 설정함으로써 정확히 정렬됨
            let x = -(width - anchorViewWidth)

            bottomOffset = CGPoint(x: x, y: 0)
        }
        
        // anchorView가 설정되지 않았다면, 기본적으로 드롭다운은 화면 하단에 표시
        if anchorView == nil {
            layout = computeLayoutBottomDisplay(window: window)
            direction = .any
            
        } else {
            // anchorView가 설정되었을 경우
            switch direction {
            case .any:
                layout = computeLayoutBottomDisplay(window: window)  // 아래 방향으로 표시될 드롭다운의 레이아웃을 계산
                direction = .bottom
                
                // 드롭다운이 화면 바깥으로 벗어나는지 확인.
                // 만약 벗어난다면 윗 방향으로 표시될 레이아웃을 계산
                if layout.offscreenHeight > 0 {
                    let topLayout = computeLayoutForTopDisplay(window: window)
                    
                    // 아래 방향과 윗 방향을 비교하여 어떤 방향이 더 적은 공간을 화면 바깥으로 벗어나게 하는지 체크
                    if topLayout.offscreenHeight < layout.offscreenHeight {
                        layout = topLayout
                        direction = .top
                    }
                }
                
            case .bottom:
                layout = computeLayoutBottomDisplay(window: window)
                direction = .bottom
                
            case .top:
                layout = computeLayoutForTopDisplay(window: window)
                direction = .top
            }
        }
        
        // 드롭다운의 width가 드롭다운이 차지할 수 있는 최대크기를 계산하여 적절하게 설정.
        constraintWidthToFittingSizeIfNecessary(layout: &layout)
        
        // 드롭다운의 width가 화면의 경계 내에 있도록 설정.(화면을 넘기지 않도록)
        constraintWidthToBoundsIfNecessary(layout: &layout, in: window)
        
        let visibleHeight = tableHeight - layout.offscreenHeight  // 화면에 실제로 보이는 드롭다운의 높이를 계산
        let canBeDisplayed = visibleHeight >= minHeight           // 드롭다운이 화면에 표시될 수 있는지(셀의 rowHeight)

        return (layout.x, layout.y, layout.width, layout.offscreenHeight, visibleHeight, canBeDisplayed, direction)
    }
    
    /// 아래 방향으로 표시되는 드롭다운의 x, y, width, offscreenHeight
    func computeLayoutBottomDisplay(window: UIWindow) -> ComputeLayoutTuple {
        var offscreenHeight: CGFloat = 0  // 드롭다운의 일부가 화면 밖에 나가는 높이
        
        // 만약 드롭다운의 width가 설정되어 있다면 그 값을 사용하고,
        // 설정된 값이 없다면 앵커 뷰의 width나 fittingWidth()에서 bottomOffset.x 를 뺀 값이 최종 width
        let width = self.width ?? (anchorView?.plainView.bounds.width ?? fittingWidth()) - bottomOffset.x
        
        // 앵커뷰의 x와 y 좌표
        let anchorViewX = anchorView?.plainView.windowFrame?.minX ?? window.frame.midX - (width / 2)
        let anchorViewY = anchorView?.plainView.windowFrame?.maxY ?? window.frame.midY - (tableHeight / 2)
        
        // 드롭다운의 x,y 좌표 계산
        let x = anchorViewX + bottomOffset.x
        let y = anchorViewY + bottomOffset.y
        
//        // 드롭다운의 최대 y좌표 계산
//        let maxY = y + tableHeight
//        let windowMaxY = window.bounds.maxY - DPDConstant.UI.HeightPadding - offsetFromWindowBottom
//
//        let keyboardListener = KeyboardListener.sharedInstance
//        let keyboardMinY = keyboardListener.keyboardFrame.minY - DPDConstant.UI.HeightPadding
//
//        if keyboardListener.isVisible && maxY > keyboardMinY {
//            offscreenHeight = abs(maxY - keyboardMinY)
//        } else if maxY > windowMaxY {
//            offscreenHeight = abs(maxY - windowMaxY)
//        }
        
        return (x, y, width, offscreenHeight)
    }
    
    /// 위 방향으로 표시되는 드롭다운의 x, y, width, offscreenHeight
    func computeLayoutForTopDisplay(window: UIWindow) -> ComputeLayoutTuple {
        var offscreenHeight: CGFloat = 0

        let anchorViewX = anchorView?.plainView.windowFrame?.minX ?? 0
        let anchorViewMaxY = anchorView?.plainView.windowFrame?.maxY ?? 0

        let x = anchorViewX + topOffset.x
        var y = (anchorViewMaxY + topOffset.y) - tableHeight

        let windowY = window.bounds.minY + DropdownConstant.DropdownUI.heightPadding

        if y < windowY {
            offscreenHeight = abs(y - windowY)
            y = windowY
        }
        
        let width = self.width ?? (anchorView?.plainView.bounds.width ?? fittingWidth()) - topOffset.x
        
        return (x, y, width, offscreenHeight)
    }
    
    /// 드롭다운의 항목 중 width가 가장 높은 아이템의 width를 계산하여 반환
    func fittingWidth() -> CGFloat {
        if templateCell == nil {
            templateCell = tableView.dequeueReusableCell(withIdentifier: "CustomDropdownCell") as? CustomDropdownCell
        }
        
        var maxWidth: CGFloat = 0
        
        for index in 0..<dataSource.count {
            
            if let customCell = templateCell as? CustomDropdownCell {
                configureCell(customCell, at: index)
                templateCell.bounds.size.height = cellHeight
                
                // templateCell과 내부 서브뷰들이 제약조건을 만족하면서 차지할 수 있는 최소한의 크기를 계산
                let width = templateCell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width
                
                if width > maxWidth {
                    maxWidth = width
                }
            }else {
                print("CustomDropdownCell로 캐스팅 불가")
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
    
    /// Swift의 튜플은 옵젝씨와 호환되지 않기 때문에, 튜플 대신에 NSDictionary를 반환하도록
    @objc(show)
    public func objc_show() -> NSDictionary {
        let (canBeDisplayed, offScreenHeight) = show()
        
        var info = [AnyHashable: Any]()
        info["canBeDisplayed"] = canBeDisplayed
        
        if let offScreenHeight = offScreenHeight {
            info["offScreenHeight"] = offScreenHeight
        }
        
        return NSDictionary(dictionary: info)
    }
    
    /**
    Shows the drop down if enough height.

    - returns: Wether it succeed and how much height is needed to display all cells at once.
    */
    @discardableResult
    func show(
        onTopOf window: UIWindow? = nil,
        beforeTransform transform: CGAffineTransform? = nil,
        anchorPoint: CGPoint? = nil
    ) -> (canBeDisplayed: Bool, offscreenHeight: CGFloat?) {
        
        // 현재 드롭다운이 화면에 표시되는 드롭다운과 동일한지, 드롭다운이 hidden 상태는 아닌지 체크한다.
        if self == DropDown.VisibleDropDown && DropDown.VisibleDropDown?.isHidden == false {
            // added condition - DropDown.VisibleDropDown?.isHidden == false -> to resolve forever hiding dropdown issue when continuous taping on button - Kartik Patel - 2016-12-29
            return (true, 0)
        }

        // 화면에 드롭다운이 이미 표시되고 있다면 해당 드롭다운을 취소
        if let visibleDropDown = DropDown.VisibleDropDown {
            visibleDropDown.cancel()
        }

        willShowAction?()  // 드롭다운이 표시되기 전에 호출되어야 하는 클로저

        DropDown.VisibleDropDown = self  // 현재 드롭다운을 현재 화면에 표시되는 드롭다운으로 설정한다.

        setNeedsUpdateConstraints()  // 레이아웃 제약조건이 업데이트되도록

        let visibleWindow = window != nil ? window : UIWindow.visibleWindow()
        visibleWindow?.addSubview(self)
        visibleWindow?.bringSubviewToFront(self)  // 드롭다운을 윈도우의 최상단으로 이동.

        self.translatesAutoresizingMaskIntoConstraints = false
        visibleWindow?.addUniversalConstraints(format: "|[dropDown]|", views: ["dropDown": self])

        let layout = computeLayout()

        if !layout.canBeDisplayed {
            hide()
            return (layout.canBeDisplayed, layout.offscreenHeight)
        }

        isHidden = false
        
        if let anchor = anchorPoint {
            tableViewContainer.layer.anchorPoint = anchor
        }
        
        if let transformation = transform {
            tableViewContainer.transform = transformation
        } else {
            tableViewContainer.transform = downScaleTransform
        }

        layoutIfNeeded()  // 레이아웃 업데이트

        UIView.animate(
            withDuration: animationduration,
            delay: 0,
            options: animationEntranceOptions,
            animations: { [weak self] in
                self?.setShowedState()
            },
            completion: nil)

        accessibilityViewIsModal = true  // VoiceOver 사용자가 드롭다운 외부의 다른 UI요소로 이동하지 못하도록
        UIAccessibility.post(notification: .screenChanged, argument: self)  // VoiceOver에 화면에 변화가 생겼다는 것을 알림

        // deselectRows(at: selectedRowIndices)
        selectRows(at: selectedRowIndices)  // selectedRowIndices에 저장되어있는 선택된 항목들을 선택 상태로 만듬.

        return (layout.canBeDisplayed, layout.offscreenHeight)
    }
    
    /// VoiceOver 사용자가 두 손가락 "Z" 제스처를 수행했을 때 호출되는 메서드
    override func accessibilityPerformEscape() -> Bool {
        switch dismissMode {
        case .automatic, .onTap:
            cancel()
            return true
            
        case .manual:  // 메뉴얼 모드일 때는 드롭다운이 수동으로만 닫힐 수 있음
            return false
        }
    }
    
    /// 드롭다운을 숨길 때 사용되는 메서드
    func hide() {
        
        // 현재 드롭다운이 화면에 보이는 드롭다운과 동일한지 체크
        // 화면에 보이는 드롭다운이 hide되고, 다른 드롭다운을 표시하려 할 때, 어떤 드롭다운이 화면에 보여져야 하는지 정확하게 체크하기 위해.
        if self == DropDown.VisibleDropDown {
            /*
            If one drop down is showed and another one is not
            but we call `hide()` on the hidden one:
            we don't want it to set the `VisibleDropDown` to nil.
            */
            DropDown.VisibleDropDown = nil
        }

        // 현재 드롭다운이 이미 숨겨져 있으면, 메서드 종료
        if isHidden {
            return
        }

        UIView.animate(
            withDuration: animationduration,
            delay: 0,
            options: animationExitOptions,
            animations: { [weak self] in
                self?.setHiddentState()
            },
            completion: { [weak self] _ in
                guard let self else { return }
                
                self.isHidden = true
                self.removeFromSuperview()
                UIAccessibility.post(notification: .screenChanged, argument: nil)
            }
        )
    }
    
    /// 드롭다운을 숨기는 hide()와 cancelAction을 호출.
    func cancel() {
        hide()
        cancelAction?()
    }

    /// 드롭다운의 alpha값을 0으로 만듬
    func setHiddentState() {
        alpha = 0
    }

    /// 드롭다운의 alpha값을 1로 설정하고, tableViewContainer의 transform을 .identity로 원상복귀
    func setShowedState() {
        alpha = 1
        tableViewContainer.transform = .identity
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
    
    /// 해당 인덱스에 대해 선택처리 후, selectedRowIndices에 추가한다.
    /// 반면에 선택된 인덱스가 없다면, 선택된 모든 행들에 선택해제 처리 후, 선택된 인덱스 요소 모두 제거
    func selectRow(at index: Index?, scrollPosition: UITableView.ScrollPosition = .none) {
        if let index = index {
            // 해당 인덱스에 있는 Cell을 선택
            tableView.selectRow(
                at: IndexPath(row: index, section: 0), animated: true, scrollPosition: scrollPosition
            )
            
            selectedRowIndices.insert(index)  // 선택한 행의 인덱스를 추가
            
        } else {
            deselectRows(at: selectedRowIndices)  // 선택된 모든 셀들에 대해 선택해제
            selectedRowIndices.removeAll()        // 선택된 index 요소 모두 제거
        }
    }
    
    /// 선택된 모든 index에 대해 선택처리
    func selectRows(at indices: Set<Index>?) {
        indices?.forEach {
            selectRow(at: $0)
        }
        
        // if we are in multi selection mode then reload data so that all selections are shown
        if multiSelectionAction != nil {
            tableView.reloadData()
        }
    }
    
    /// 해당 인덱스에 대해 선택 해제 처리
    func deselectRow(at index: Index?) {
        guard let index = index, index >= 0 else { return }
        
        // remove from indices
        if let selectedRowIndex = selectedRowIndices.firstIndex(where: { $0 == index }) {
            selectedRowIndices.remove(at: selectedRowIndex)
        }

        tableView.deselectRow(at: IndexPath(row: index, section: 0), animated: true)
    }
    
    /// 전달받은 indices에 저장된 모든 인덱스에 대해 선택해제 처리
    func deselectRows(at indices: Set<Index>?) {
        indices?.forEach {
            deselectRow(at: $0)
        }
    }
    
    /// 현재 tableView에서 선택된 Cell의 인덱스를 반환
    var indexForSelectedRow: Index? {
        return tableView.indexPathForSelectedRow?.row
    }
    
    /// 현재 선택된 항목의 값을 반환
    var selectedItem: String? {
        guard let row = tableView.indexPathForSelectedRow?.row else { return nil }

        return dataSource[row]
    }
    
    /// dataSource에 있는 모든 아이템들을 보여주기 위한 TableView의 높이
    var tableHeight: CGFloat {
        return tableView.rowHeight * CGFloat(dataSource.count)
    }
}

// MARK: - UITableViewDataSource
extension DropDown: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(CustomDropdownCell.self, for: indexPath) else {
            return UITableViewCell()
        }
        
        configureCell(cell, at: indexPath.row)
        return cell
    }
    
    func configureCell(_ cell: CustomDropdownCell, at index: Int) {
        
        // cell의 accessibilityIdentifier 설정으로 UI 테스트를 수행할 때, 해당 셀을 식벽하기 위한 값으로 사용될 수 있음.
        if index >= 0 && index < localizationKeysDataSource.count {
            cell.accessibilityIdentifier = localizationKeysDataSource[index]
        }
        
//        cell.titleLabel.textColor = textColor
//        cell.titleLabel.font = textFont
//        cell.selectedBackgroundColor = selectionBackgroundColor
//        cell.highlightTextColor = selectedTextColor
//        cell.normalTextColor = textColor
//
        if let cellConfiguration = cellConfiguration {
            cell.titleLabel.text = cellConfiguration(index, dataSource[index])
        } else {
            cell.titleLabel.text = dataSource[index]
        }
        
        customCellConfiguration?(index, dataSource[index], cell)
    }
}

// MARK: - UITableViewDelegate
extension DropDown: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.isSelected = selectedRowIndices.contains(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRowIndex = indexPath.row
        
        // 다중 선택모드인지 확인
        if let multiSelectionCallback = multiSelectionAction {
            
            // 이미 선택된 Cell을 중복선택했다면 선택 해제.
            if selectedRowIndices.first(where: { $0 == selectedRowIndex }) != nil {
                deselectRow(at: selectedRowIndex)

                // 선택된 모든 행의 인덱스를 포함하는 Set을 배열로 변환
                let selectedRowIndicesArray = Array(selectedRowIndices)
                
                // 선택된 인덱스에 맞는 항목들을 가져와 배열로 저장.
                let selectedRows = selectedRowIndicesArray.map { dataSource[$0] }
                
                // 클로저 호출.
                multiSelectionCallback(selectedRowIndicesArray, selectedRows)
                return
                
            } else {
                selectedRowIndices.insert(selectedRowIndex)  // 선택 인덱스 추가

                let selectedRowIndicesArray = Array(selectedRowIndices)
                let selectedRows = selectedRowIndicesArray.map { dataSource[$0] }
                
                selectionAction?(selectedRowIndex, dataSource[selectedRowIndex])
                multiSelectionCallback(selectedRowIndicesArray, selectedRows)
                
                tableView.reloadData()
                return
            }
        }
        
        // 멀티 선택이 불가한 경우 처리
        selectedRowIndices.removeAll()
        selectedRowIndices.insert(selectedRowIndex)
        selectionAction?(selectedRowIndex, dataSource[selectedRowIndex])
        
        // 앵커뷰가 UIBarButton일 때 경우 메뉴처럼 사용되기 때문에 선택된 Cell이 무엇인지 표시 할 필요가 없음.
        if let _ = anchorView as? UIBarButtonItem {
            // DropDown's from UIBarButtonItem are menus so we deselect the selected menu right after selection
            deselectRow(at: selectedRowIndex)
        }
        
        hide()  // 새로운 항목을 선택했으면 숨기기.
    }
}

// MARK: - Auto dismiss
extension DropDown {

    /// 주어진 포인트에서 터치 이벤트를 처리할 가장 적절한 서브뷰를 반환하는 메서드
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)  // 터치된 위치에 해당하는 뷰를 가져옴

        // 터치된 뷰가 dismissableView이며, dismisMode가 .automatic인지 체크
        if dismissMode == .automatic && view === dismissableView {
            cancel()
            return nil
            
        } else {
            return view
        }
    }

    @objc
    func dismissableViewTapped() {
        cancel()
    }

}
