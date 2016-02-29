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

import EasyTransition

class ViewController: UIViewController {
    
    var transition: EasyTransition?

    @IBOutlet var bottomTransition: EasyTransition!
    
    @IBOutlet var actionButtons: [UIButton]!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var projectNameLabel: UILabel!
    
    var setImageWithAnimate: (UIImage->Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        backgroundImage.registerMotionEffectWithDept(5)
        projectNameLabel.registerMotionEffectWithDept(30)
        
        for button in actionButtons {
            button.registerMotionEffectWithDept(10)
        }
        
        setImageWithAnimate = {
            self.backgroundImage.image = $0
            let transition = CATransition()
            transition.duration = 0.2
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade
            self.backgroundImage.layer.addAnimation(transition, forKey: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Present from Edge
    
    @IBAction func showTop(sender: AnyObject) {
        let menuVC = storyboard!.instantiateViewControllerWithIdentifier("menu") as! UINavigationController
        transition = EasyTransition(attachedViewController: menuVC)
        transition?.transitionDuration = 0.3
        transition?.direction = .Top
        transition?.blurEffectStyle = .Dark
        transition?.margins = UIEdgeInsets(top: 100, left: 20, bottom: 100, right: 20)
        if let firstVC = menuVC.viewControllers.first as? ExampleMenuViewController {
            firstVC.imageDidSelected = setImageWithAnimate
        }
        presentViewController(menuVC, animated: true, completion: nil)
    }
    
    @IBAction func showRight(sender: AnyObject) {
        let menuVC = storyboard!.instantiateViewControllerWithIdentifier("menu") as! UINavigationController
        transition = EasyTransition(attachedViewController: menuVC)
        transition?.transitionDuration = 0.4
        transition?.direction = .Right
        transition?.blurEffectStyle = .Light
        transition?.margins = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 0)
        if let firstVC = menuVC.viewControllers.first as? ExampleMenuViewController {
            firstVC.imageDidSelected = setImageWithAnimate
        }
        presentViewController(menuVC, animated: true, completion: nil)
    }
    
    @IBAction func showBottom(sender: AnyObject) {
        let menuVC = storyboard!.instantiateViewControllerWithIdentifier("menu") as! UINavigationController
        bottomTransition?.attachedViewController = menuVC
        bottomTransition?.direction = .Bottom
        bottomTransition?.margins = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        bottomTransition?.sizeMax = CGSize(width: CGFloat.max, height: 320)
        if let firstVC = menuVC.viewControllers.first as? ExampleMenuViewController {
            firstVC.imageDidSelected = setImageWithAnimate
        }
        presentViewController(menuVC, animated: true, completion: nil)
    }

    @IBAction func showLeft(sender: AnyObject) {
        let menuVC = storyboard!.instantiateViewControllerWithIdentifier("menu") as! UINavigationController
        transition = EasyTransition(attachedViewController: menuVC)
        transition?.transitionDuration = 0.4
        transition?.direction = .Left
        transition?.margins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        transition?.sizeMax = CGSize(width: 250, height: CGFloat.max)
        transition?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        if let firstVC = menuVC.viewControllers.first as? ExampleMenuViewController {
            firstVC.imageDidSelected = setImageWithAnimate
        }
        presentViewController(menuVC, animated: true, completion: nil)
    }
    
    // Present from Corner
    
    @IBAction func showTopRight(sender: AnyObject) {
        let menuVC = storyboard!.instantiateViewControllerWithIdentifier("close")
        transition = EasyTransition(attachedViewController: menuVC)
        transition?.transitionDuration = 0.6
        transition?.direction = [.Top,.Right]
        transition?.margins = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 20)
        transition?.sizeMax = CGSize(width: 200, height: 200)
        transition?.backgroundColor = UIColor(patternImage: UIImage(named: "pink_rice")!)
        presentViewController(menuVC, animated: true, completion: nil)
    }

    @IBAction func showBottomRight(sender: AnyObject) {
        let menuVC = storyboard!.instantiateViewControllerWithIdentifier("close")
        transition = EasyTransition(attachedViewController: menuVC)
        transition?.transitionDuration = 0.4
        transition?.direction = [.Bottom,.Right]
        transition?.margins = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 20)
        transition?.sizeMax = CGSize(width: 200, height: 200)
        transition?.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5)
        presentViewController(menuVC, animated: true, completion: nil)
    }
    
    @IBAction func showBottomLeft(sender: AnyObject) {
        let menuVC = storyboard!.instantiateViewControllerWithIdentifier("close")
        transition = EasyTransition(attachedViewController: menuVC)
        transition?.transitionDuration = 0.5
        transition?.direction = [.Bottom,.Left]
        transition?.margins = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 0)
        transition?.sizeMax = CGSize(width: 200, height: 200)
        transition?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
        presentViewController(menuVC, animated: true, completion: nil)
    }
    
    @IBAction func showTopLeft(sender: AnyObject) {
        let menuVC = storyboard!.instantiateViewControllerWithIdentifier("close")
        transition = EasyTransition(attachedViewController: menuVC)
        transition?.transitionDuration = 1
        transition?.direction = [.Top,.Left]
        transition?.margins = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 0)
        transition?.sizeMax = CGSize(width: 200, height: 200)
        transition?.backgroundColor = UIColor.purpleColor().colorWithAlphaComponent(0.4)
        presentViewController(menuVC, animated: true, completion: nil)
    }

}

extension UIView {
    func registerMotionEffectWithDept(dept:CGFloat) {
        let effectX = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        let effectY = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        effectX.maximumRelativeValue = dept
        effectX.minimumRelativeValue = -dept
        effectY.maximumRelativeValue = dept
        effectY.minimumRelativeValue = -dept
        
        self.addMotionEffect(effectX)
        self.addMotionEffect(effectY)
    }
}

// Sample target View Controller

class ExampleMenuViewController: UITableViewController {
    
    var imageDidSelected: (UIImage->Void)?
    
    @IBAction func dismiss(sender: AnyObject?) {
        guard let imageDidSelected = imageDidSelected,sender = sender as? UITableViewCell else {
            dismissViewControllerAnimated(true, completion: nil)
            return
        }
        guard let indexPath = tableView.indexPathForCell(sender) else {
            dismissViewControllerAnimated(true, completion: nil)
            return
        }
            
        let imageIndex = (indexPath.section * 4) + indexPath.row + 1
        
        dismissViewControllerAnimated(true) { () -> Void in
            imageDidSelected(UIImage(named: "bg\(imageIndex)")!)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dismiss(tableView.cellForRowAtIndexPath(indexPath))
    }
}

class ExampleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 100
        view.layer.masksToBounds = true
    }
    
    @IBAction func dismiss(sender: AnyObject?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

