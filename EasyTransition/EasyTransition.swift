//  The MIT License (MIT)
//
//  Copyright (c) 2016 - present Nattawut Singhchai
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

open class EasyTransition: UIPercentDrivenInteractiveTransition {
    
    open var transitionDuration: TimeInterval = 0.5
    
     // Percentage for pan dismiss [ 0.0 - 1.0]
    
    open var dismissalPercentCompleteThreshold: CGFloat = 0.2
    
    open var enableInteractiveDismissalTransition: Bool = true
    
    open var enableDismissTouchOutBound: Bool = true
    
    open var isInteractiveDissmalTransition = false
    
    // direction
    // Corner or Edge only
    
    open var direction: UIRectEdge = [.left]
    
    open var margins = UIEdgeInsets.zero
    
    open var sizeMax = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    
    open var sizeMin = CGSize.zero

    open var backgroundColor = UIColor.black.withAlphaComponent(0.5)
    
    open var zTransitionSize: CGFloat?
    
    open var blurEffectStyle: UIBlurEffectStyle?
    
    fileprivate var attachedViewController = UIViewController()
    
    fileprivate(set) weak var transitionContext: UIViewControllerContextTransitioning?
    
    fileprivate var isPresentation : Bool = false
    
    public init(attachedViewController: UIViewController) {
        super.init()
        
        self.attachedViewController = attachedViewController
        
        attachedViewController.transitioningDelegate = self
        attachedViewController.modalPresentationStyle = .custom
        

        let presentationPanGesture = UIPanGestureRecognizer()
        presentationPanGesture.addTarget(self, action: #selector(EasyTransition.dismissalPanGesture(_:)))
        attachedViewController.view.addGestureRecognizer(presentationPanGesture)

    }
    
    func dismissalPanGesture(_ recognizer: UIPanGestureRecognizer) {
        if enableInteractiveDismissalTransition {
            isInteractiveDissmalTransition = recognizer.state == .began || recognizer.state == .changed
            
            switch recognizer.state {
            case .began: panGestureBegan(recognizer)
            case .changed: panGestureChanged(recognizer)
            case .cancelled, .ended: panGestureCancelledAndEnded(recognizer)
            default: break
            }
        }
    }
    
    override open func cancel() {
        completionSpeed = dismissalPercentCompleteThreshold
        super.cancel()
    }
    
    override open func finish() {
        completionSpeed = 1.0 - dismissalPercentCompleteThreshold
        super.finish()
    }
    
    fileprivate func panGestureBegan(_ recognizer: UIPanGestureRecognizer) {
        attachedViewController.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func panGestureChanged(_ recognizer: UIPanGestureRecognizer) {
        
        let transition = recognizer.translation(in: attachedViewController.view)
        
        let transitionPercentage = CGPoint(x: transition.x / attachedViewController.view.bounds.size.width, y: transition.y / attachedViewController.view.bounds.size.height)
        
        var progress: CGPoint = CGPoint.zero
        
        if (direction.contains(.top) && transitionPercentage.y < 0) || (direction.contains(.bottom) && transitionPercentage.y > 0){
            progress.y = transitionPercentage.y
        }
        
        if (direction.contains(.left) && transitionPercentage.x < 0) || (direction.contains(.right) && transitionPercentage.x > 0){
            progress.x = transitionPercentage.x
        }
        
        update(sqrt(pow(progress.x, 2) + pow(progress.y,2))) //
    }
    
    fileprivate func panGestureCancelledAndEnded(_ recognizer: UIPanGestureRecognizer) {
        percentComplete > dismissalPercentCompleteThreshold ? finish() : cancel()
    }
}

extension EasyTransition : UIViewControllerTransitioningDelegate ,UIViewControllerAnimatedTransitioning {

    // TransitioningDelegate
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = PresentationController(presentedViewController:presented, presenting:presenting)
        presentationController.direction = direction
        presentationController.backgroundColor = backgroundColor
        presentationController.margins = margins
        presentationController.sizeMin = sizeMin
        presentationController.sizeMax = sizeMax
        presentationController.enableDismissTouchOutBound = enableDismissTouchOutBound
        presentationController.zTransitionSize = zTransitionSize
        presentationController.blurEffectStyle = blurEffectStyle
        return presentationController
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresentation = true
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresentation = false
        return self
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isInteractiveDissmalTransition ? self : nil
    }
    
    // Animate Transitioning
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitionContext = transitionContext
        let containerView = transitionContext.containerView
        
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else {
                return
        }
        
        
        let fromView = fromVC.view
        let toView = toVC.view
        
        if toVC.isBeingPresented {
            // Presentation
            containerView.addSubview(toView!)
        }
        
        let animatingVC = isPresentation ? toVC : fromVC
        let animatingView = animatingVC.view
        
        let finalFrameForVC = transitionContext.finalFrame(for: animatingVC)
        var initialFrameForVC = finalFrameForVC
        
        if direction.contains(.right) {
            initialFrameForVC.origin.x += (initialFrameForVC.size.width + margins.right)
        }else if direction.contains(.left) {
            initialFrameForVC.origin.x -= (initialFrameForVC.size.width + margins.left)
        }
        
        if direction.contains(.bottom) {
            initialFrameForVC.origin.y += (initialFrameForVC.size.height + margins.bottom)
        }else if direction.contains(.top) {
            initialFrameForVC.origin.y -= (initialFrameForVC.size.height + margins.top)
        }
        
        let initialFrame = isPresentation ? initialFrameForVC : finalFrameForVC
        let finalFrame = isPresentation ? finalFrameForVC : initialFrameForVC
        
        animatingView?.frame = initialFrame
        
        let animations : ((Void)->Void) = {
            animatingView?.frame = finalFrame
        }
        
        let completion = { (completed:Bool) in
            if !self.isPresentation && !transitionContext.transitionWasCancelled {
                fromView?.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        if transitionContext.isInteractive {
            UIView.animate(withDuration: transitionDuration(using: transitionContext),
                animations: animations,
                completion: completion)
        }else{
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay:0, usingSpringWithDamping:500.0, initialSpringVelocity:2,
                options:UIViewAnimationOptions.allowUserInteraction,
                animations:animations,
                completion:completion)
            
            
        }
    }
    
}

internal class PresentationController: UIPresentationController, UIAdaptivePresentationControllerDelegate {
    
    var backgroundColor: UIColor!
    
    var margins = UIEdgeInsets.zero
    
    var sizeMax = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    
    var sizeMin = CGSize.zero
    
    var direction: UIRectEdge!
    
    var zTransitionSize: CGFloat?
    
    var blurEffectStyle: UIBlurEffectStyle?
    
    fileprivate var installedConstraint: [NSLayoutConstraint]?
    
    fileprivate var dimmingView: UIView! {
        didSet {
            dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PresentationController.dimmingViewTapped(_:))))
        }
    }
    
    fileprivate var backView: UIView?
    
    fileprivate var snapshotView: UIView?
    
    fileprivate var perspectiveTransform: CATransform3D?
    
    var enableDismissTouchOutBound:Bool = true
    
    func dimmingViewTapped(_ gesture: UIGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.ended  && enableDismissTouchOutBound {
            presentingViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    internal override var frameOfPresentedViewInContainerView : CGRect {
        var presentedViewFrame = CGRect.zero
        if let containerBounds = containerView?.bounds {
            presentedViewFrame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerBounds.size)
            presentedViewFrame.origin = CGPoint(x: margins.left, y: margins.top)
            if direction.contains(.bottom) {
                presentedViewFrame.origin.y += (containerBounds.height - (margins.top + margins.bottom)) - presentedViewFrame.height
            }
            if direction.contains(.right) {
                presentedViewFrame.origin.x += (containerBounds.width - (margins.left + margins.right)) - presentedViewFrame.width
            }
        }
        return presentedViewFrame
    }
    
    internal override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(
            width:  max(min(parentSize.width - (margins.left + margins.right)   ,sizeMax.width),sizeMin.width),
            height: max(min(parentSize.height - (margins.top + margins.bottom)  ,sizeMax.height),sizeMin.height)
        )
    }
    
    internal override func presentationTransitionWillBegin() {
        guard let containerView = containerView else {return}
        
        if let _ = blurEffectStyle {
            dimmingView = UIVisualEffectView(frame: containerView.bounds)
        }else{
            dimmingView = UIView(frame: containerView.bounds)
            dimmingView.backgroundColor = backgroundColor
            dimmingView.alpha = 0.0
        }
        
        containerView.insertSubview(dimmingView, at:1)
        
        if let zTransitionSize = zTransitionSize {
            let backView = UIView()
            backView.frame = containerView.bounds
            
            presentingViewController.view.clipsToBounds = true
            if let superView = presentingViewController.view.superview {
                presentingViewController.view.makeEdgesEqualTo(superView)
            }

            self.snapshotView = presentingViewController.view
            
            containerView.insertSubview(backView, belowSubview:  dimmingView)
            self.backView = backView
            
            perspectiveTransform = CATransform3DIdentity
            perspectiveTransform?.m34 = 1.0/(-1000)
            perspectiveTransform = CATransform3DTranslate(perspectiveTransform!, 0, 0, -zTransitionSize)
        }
        
        
        
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: {
                (context:UIViewControllerTransitionCoordinatorContext) -> Void in
                if let blurView = self.dimmingView as? UIVisualEffectView , let blurEffect = self.blurEffectStyle {
                    blurView.effect = UIBlurEffect(style: blurEffect)
                }else{
                    self.dimmingView.alpha = 1.0
                }
                if let perspectiveTransform = self.perspectiveTransform {
                    self.snapshotView?.layer.transform = perspectiveTransform
                }
            }, completion:nil)
        } else {
            dimmingView.alpha = 1.0
            if let perspectiveTransform = perspectiveTransform {
                snapshotView?.layer.transform = perspectiveTransform
            }
        }
    }
    
    internal override func dismissalTransitionWillBegin() {
        
        if let coordinator = presentedViewController.transitionCoordinator {
            if let snapshotView = snapshotView {
                coordinator.animateAlongsideTransition(in: snapshotView, animation: {transitionContext in
                    self.snapshotView?.layer.transform = CATransform3DIdentity
                    }, completion: { transitionContext in
                        if transitionContext.isCancelled {
                            if let perspectiveTransform = self.perspectiveTransform {
                                self.snapshotView?.layer.transform = perspectiveTransform
                            }
                        }else{
                            self.presentingViewController.view.removeInstalledConstraints()
                            self.presentingViewController.view.translatesAutoresizingMaskIntoConstraints = true
                        }
                })
            }
            
            coordinator.animate(alongsideTransition: {
                (context:UIViewControllerTransitionCoordinatorContext) -> Void in
                if let blurView = self.dimmingView as? UIVisualEffectView {
                    blurView.effect = nil
                }else{
                    self.dimmingView.alpha = 0.0
                }
            }, completion: { context in
                    if context.isCancelled, let blurEffect = self.blurEffectStyle,
                        let blurView = self.dimmingView as? UIVisualEffectView {
                            blurView.effect = UIBlurEffect(style: blurEffect)
                    }
            })
        } else {
            dimmingView.alpha = 0.0
            snapshotView?.layer.transform = CATransform3DIdentity
        }
    }
    
    internal override func containerViewWillLayoutSubviews() {
        guard let containerView = containerView else {return}
        dimmingView.frame = containerView.bounds
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    internal override var shouldPresentInFullscreen : Bool {
        return true
    }
    
    internal override var adaptivePresentationStyle : UIModalPresentationStyle {
        return UIModalPresentationStyle.fullScreen
    }
}

