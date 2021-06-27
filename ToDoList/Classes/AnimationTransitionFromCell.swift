//
//  AnimationTransition.swift
//  ToDoList
//
//  Created by Софья Тимохина on 27.06.2021.
//

import UIKit

class AnimationTransitionForCell: NSObject, UIViewControllerAnimatedTransitioning {
    weak var presentationCell: ToDoCell!
    let isPresenting: Bool!
    init(presentationCell: ToDoCell, isPresenting: Bool) {
        self.presentationCell = presentationCell
        self.isPresenting = isPresenting
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            present(using: transitionContext)
        } else {
            dismiss(using: transitionContext)
        }
    }
    func present(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let presentedViewController = transitionContext.viewController(forKey: .to),
              let presentedView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false); return
        }
        let finalFrame = transitionContext.finalFrame(for: presentedViewController)
        let startFrame = presentationCell.convert(presentationCell.bounds, to: containerView)
        let startFrameCenter = CGPoint(x: startFrame.midX, y: startFrame.midY)
        containerView.addSubview(presentedView)
        presentedView.center = startFrameCenter
        presentedView.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            presentedView.transform = CGAffineTransform(scaleX: 1, y: 1)
            presentedView.frame = finalFrame
        }, completion: { (finished) in
            transitionContext.completeTransition(finished)
        })
    }
    func dismiss(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let dismissView = transitionContext.view(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }
        let startFrame = presentationCell.convert(presentationCell.bounds, to: containerView)
        let startFrameCenter = CGPoint(x: startFrame.midX, y: startFrame.midY)
        dismissView.center = startFrameCenter
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            dismissView.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        }, completion: { (finished) in
            transitionContext.completeTransition(finished)
        })
    }
}
