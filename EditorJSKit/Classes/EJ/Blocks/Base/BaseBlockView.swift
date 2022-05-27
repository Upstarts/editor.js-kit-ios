//
//  BaseBlockView.swift
//  EditorJSKit
//
//  Created by Vadim Popov on 27.05.2022.
//

import Foundation

///
public class BaseBlockView<BlockView: UIView>: UIView, EJBlockView where BlockView: EJBlockStyleApplicable & ConfigurableBlockView {
    
    let baseView = UIView()
    let blockView = BlockView()
    var blockType: EJAbstractBlockType { EJNativeBlockType.raw }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Overriden functions must call `super.setupSubviews()`
     */
    func setupViews() {
        addSubview(baseView)
        
        baseView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            baseView.leftAnchor.constraint(equalTo: leftAnchor),
            baseView.rightAnchor.constraint(equalTo: rightAnchor),
            baseView.topAnchor.constraint(equalTo: topAnchor),
            baseView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        setupBlockView()
    }
    
    /**
     This is default impleentation. If you wish to apply any custom setup (e.g. insets), override this functions.
     If overriding constraints, do not call super.
     */
    func setupBlockView() {
        let insets = EJKit.shared.style.getStyle(forBlockType: blockType)?.insets ?? .zero
        
        baseView.addSubview(blockView)
        blockView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blockView.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: insets.left),
            blockView.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: -insets.right),
            blockView.topAnchor.constraint(equalTo: baseView.topAnchor, constant: insets.top),
            blockView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -insets.bottom)
            ])
    }
    
    // MARK: - ReusableBlockView conformance
    
    public static var reuseId: String {
        String(describing: BlockView.self)
    }
    
    // MARK: - ConfigurableBlockView conformance
    
    public func configure(withItem item: BlockView.BlockContentItem) {
        blockView.configure(withItem: item)
    }
    
    public static func estimatedSize(for item: BlockView.BlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize {
        BlockView.estimatedSize(for: item, style: style, boundingWidth: boundingWidth)
    }
    
    // MARK: - EJBlockStyleApplicable conformance
    
    public func apply(style: EJBlockStyle) {
        blockView.apply(style: style)
    }
}
