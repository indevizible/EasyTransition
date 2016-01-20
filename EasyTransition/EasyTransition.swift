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

public class EasyTransition: UIPercentDrivenInteractiveTransition {
    
    public var transitionDuration: NSTimeInterval = 0.5
    
     // Percentage for pan dismiss [ 0.0 - 1.0]
    
    public var dismissalPercentCompleteThreshold: CGFloat = 0.2
    
    public var enableInteractiveDismissalTransition: Bool = true
    
    public var enableDismissTouchOutBound: Bool = true
    
    public var isInteractiveDissmalTransition = false
    
    // direction
    // Corner or Edge only
    
    public var direction: UIRectEdge = [.Left]
    
    public var margins = UIEdgeInsetsZero
    
    public var sizeMax = CGSize(width: CGFloat.max, height: CGFloat.max)
    
    public var sizeMin = CGSizeZero

    public var backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
    
    public var zTransitionSize: CGFloat?
    
    public var blurEffectStyle: UIBlurEffectStyle?
    
    private var attachedViewController = UIViewController()
    
    private(set) weak var transitionContext: UIViewControllerContextTransitioning?
    
    private var isPresentation : Bool = false
    
    public init(attachedViewController: UIViewController) {
        super.init()
        
        self.attachedViewController = attachedViewController
        
        attachedViewController.transitioningDelegate = self
        attachedViewController.modalPresentationStyle = .Custom
        

        let presentationPanGesture = UIPanGestureRecognizer()
        presentationPanGesture.addTarget(self, action: "dismissalPanGesture:")
        attachedViewController.view.addGestureRecognizer(presentationPanGesture)

    }
    
    func dismissalPanGesture(recognizer: UIPanGestureRecognizer) {
        if enableInteractiveDismissalTransition {
            isInteractiveDissmalTransition = recognizer.state == .Began || recognizer.state == .Changed
            
            switch recognizer.state {
            case .Began: panGestureBegan(recognizer)
            case .Changed: panGestureChanged(recognizer)
            case .Cancelled, .Ended: panGestureCancelledAndEnded(recognizer)
            default: break
            }
        }
    }
    
    override public func cancelInteractiveTransition() {
        completionSpeed = dismissalPercentCompleteThreshold
        super.cancelInteractiveTransition()
    }
    
    override public func finishInteractiveTransition() {
        completionSpeed = 1.0 - dismissalPercentCompleteThreshold
        super.finishInteractiveTransition()
    }
    
    private func panGestureBegan(recognizer: UIPanGestureRecognizer) {
        attachedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func panGestureChanged(recognizer: UIPanGestureRecognizer) {
        
        let transition = recognizer.translationInView(attachedViewController.view)
        
        let transitionPercentage = CGPoint(x: transition.x / attachedViewController.view.bounds.size.width, y: transition.y / attachedViewController.view.bounds.size.height)
        
        var progress: CGPoint = CGPointZero
        
        if (direction.contains(.Top) && transitionPercentage.y < 0) || (direction.contains(.Bottom) && transitionPercentage.y > 0){
            progress.y = transitionPercentage.y
        }
        
        if (direction.contains(.Left) && transitionPercentage.x < 0) || (direction.contains(.Right) && transitionPercentage.x > 0){
            progress.x = transitionPercentage.x
        }
        
        updateInteractiveTransition(sqrt(pow(progress.x, 2) + pow(progress.y,2))) //
    }
    
    private func panGestureCancelledAndEnded(recognizer: UIPanGestureRecognizer) {
        percentComplete > dismissalPercentCompleteThreshold ? finishInteractiveTransition() : cancelInteractiveTransition()
    }
}

extension EasyTransition : UIViewControllerTransitioningDelegate ,UIViewControllerAnimatedTransitioning {

    // TransitioningDelegate
    
    public func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let presentationController = PresentationController(presentedViewController:presented, presentingViewController:presenting)
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
    
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresentation = true
        return self
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresentation = false
        return self
    }
    
    public func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    public func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isInteractiveDissmalTransition ? self : nil
    }
    
    // Animate Transitioning
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return transitionDuration
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitionContext = transitionContext
        
        guard let containerView = transitionContext.containerView(),
            fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
            else {
                return
        }
        
        
        let fromView = fromVC.view
        let toView = toVC.view
        
        if toVC.isBeingPresented() {
            // Presentation
            containerView.addSubview(toView!)
        }
        
        let animatingVC = isPresentation ? toVC : fromVC
        let animatingView = animatingVC.view
        
        let finalFrameForVC = transitionContext.finalFrameForViewController(animatingVC)
        var initialFrameForVC = finalFrameForVC
        
        if direction.contains(.Right) {
            initialFrameForVC.origin.x += (initialFrameForVC.size.width + margins.right)
        }else if direction.contains(.Left) {
            initialFrameForVC.origin.x -= (initialFrameForVC.size.width + margins.left)
        }
        
        if direction.contains(.Bottom) {
            initialFrameForVC.origin.y += (initialFrameForVC.size.height + margins.bottom)
        }else if direction.contains(.Top) {
            initialFrameForVC.origin.y -= (initialFrameForVC.size.height + margins.top)
        }
        
        let initialFrame = isPresentation ? initialFrameForVC : finalFrameForVC
        let finalFrame = isPresentation ? finalFrameForVC : initialFrameForVC
        
        animatingView?.frame = initialFrame
        
        let animations : (Void->Void) = {
            animatingView?.frame = finalFrame
        }
        
        let completion = { (completed:Bool) in
            if !self.isPresentation && !transitionContext.transitionWasCancelled() {
                fromView?.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
        
        if transitionContext.isInteractive() {
            UIView.animateWithDuration(transitionDuration(transitionContext),
                animations: animations,
                completion: completion)
        }else{
            UIView.animateWithDuration(transitionDuration(transitionContext), delay:0, usingSpringWithDamping:500.0, initialSpringVelocity:2,
                options:UIViewAnimationOptions.AllowUserInteraction,
                animations:animations,
                completion:completion)
            
            
        }
    }
    
}

internal class PresentationController: UIPresentationController, UIAdaptivePresentationControllerDelegate {
    
    var backgroundColor: UIColor!
    
    var margins = UIEdgeInsetsZero
    
    var sizeMax = CGSize(width: CGFloat.max, height: CGFloat.max)
    
    var sizeMin = CGSizeZero
    
    var direction: UIRectEdge!
    
    var zTransitionSize: CGFloat?
    
    var blurEffectStyle: UIBlurEffectStyle?
    
    private var dimmingView: UIView! {
        didSet {
            dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dimmingViewTapped:"))
        }
    }
    
    private var backView: UIView?
    
    private var snapshotView: UIView?
    
    var enableDismissTouchOutBound:Bool = true
    
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController:presentedViewController, presentingViewController:presentingViewController)
        
    }
    
    
    func dimmingViewTapped(gesture: UIGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.Ended  && enableDismissTouchOutBound {
            presentingViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    internal override func frameOfPresentedViewInContainerView() -> CGRect {
        var presentedViewFrame = CGRectZero
        if let containerBounds = containerView?.bounds {
            presentedViewFrame.size = sizeForChildContentContainer(presentedViewController, withParentContainerSize: containerBounds.size)
            presentedViewFrame.origin = CGPoint(x: margins.left, y: margins.top)
            if direction.contains(.Bottom) {
                presentedViewFrame.origin.y += (containerBounds.height - (margins.top + margins.bottom)) - presentedViewFrame.height
            }
            if direction.contains(.Right) {
                presentedViewFrame.origin.x += (containerBounds.width - (margins.left + margins.right)) - presentedViewFrame.width
            }
        }
        return presentedViewFrame
    }
    
    internal override func sizeForChildContentContainer(container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
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
        
        containerView.insertSubview(dimmingView, atIndex:1)
        
        var perspectiveTransform: CATransform3D?
        
        if let zTransitionSize = zTransitionSize {
            let backView = UIView()
            backView.backgroundColor = UIColor.blackColor()
            backView.frame = containerView.bounds
            
            let snapshotView = presentingViewController.view.snapshotViewAfterScreenUpdates(false)
            backView.addSubview(snapshotView)
            self.snapshotView = snapshotView
            
            containerView.insertSubview(backView, belowSubview:  dimmingView)
            self.backView = backView
            
            perspectiveTransform = CATransform3DIdentity
            perspectiveTransform?.m34 = 1.0/(-1000)
            perspectiveTransform = CATransform3DTranslate(perspectiveTransform!, 0, 0, -zTransitionSize)
        }
        
        
        
        if let coordinator = presentedViewController.transitionCoordinator() {
            coordinator.animateAlongsideTransition({
                (context:UIViewControllerTransitionCoordinatorContext) -> Void in
                if let blurView = self.dimmingView as? UIVisualEffectView , blurEffect = self.blurEffectStyle {
                    blurView.effect = UIBlurEffect(style: blurEffect)
                }else{
                    self.dimmingView.alpha = 1.0
                }
                if let perspectiveTransform = perspectiveTransform {
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
        
        if let coordinator = presentedViewController.transitionCoordinator() {
            coordinator.animateAlongsideTransition({
                (context:UIViewControllerTransitionCoordinatorContext) -> Void in
                if let blurView = self.dimmingView as? UIVisualEffectView {
                    blurView.effect = nil
                }else{
                    self.dimmingView.alpha = 0.0
                }
                self.snapshotView?.layer.transform = CATransform3DIdentity
                }, completion: { context in
                    if context.isCancelled() ,
                        let blurEffect = self.blurEffectStyle,
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
        presentedView()?.frame = frameOfPresentedViewInContainerView()
    }
    
    internal override func shouldPresentInFullscreen() -> Bool {
        return true
    }
    
    internal override func adaptivePresentationStyle() -> UIModalPresentationStyle {
        return UIModalPresentationStyle.FullScreen
    }
}

