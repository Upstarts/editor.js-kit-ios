//
//  BaseBlockView.swift
//  EditorJSKit
//
//  Created by Vadim Popov on 27.05.2022.
//

import UIKit

///
public class BaseBlockView<BlockView: UIView>: UIView, EJBlockView where BlockView: ConfigurableBlockView {
    
    let baseView = UIView()
    let blockView = BlockView()
    var blockInsets: UIEdgeInsets?
    private var blockConstraints: [NSLayoutConstraint] = []
    
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
     This is default impleentation. If you wish to apply any custom setup, override this function.
     */
    func setupBlockView() {
        baseView.addSubview(blockView)
        blockView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - ReusableBlockView conformance
    
    public static var reuseId: String {
        // Module-qualified: a bare type name can collide across modules — and with the cells the
        // native blocks register — handing a wrong cell class back from the reuse pool (issue #35).
        String(reflecting: Self.self)
    }
    
    // MARK: - ConfigurableBlockView conformance
    
    public func configure(withItem item: BlockView.BlockContentItem, style: EJBlockStyle?) {
        defer {
            blockView.configure(withItem: item, style: style)
        }
        
        let insets = style?.insets ?? .zero
        if blockInsets != insets {
            let constraints = [
                blockView.leftAnchor.constraint(equalTo: baseView.leftAnchor, constant: insets.left),
                blockView.rightAnchor.constraint(equalTo: baseView.rightAnchor, constant: -insets.right),
                blockView.topAnchor.constraint(equalTo: baseView.topAnchor, constant: insets.top),
                blockView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -insets.bottom)
            ]
            NSLayoutConstraint.deactivate(blockConstraints)
            NSLayoutConstraint.activate(constraints)
            blockConstraints = constraints
            blockInsets = insets
        }
    }
    
    public static func estimatedSize(for item: BlockView.BlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize {
        BlockView.estimatedSize(for: item, style: style, boundingWidth: boundingWidth)
    }
}
