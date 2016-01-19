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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "symphony")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Present from Edge
    
    @IBAction func showTop(sender: AnyObject) {
        let menuVC = storyboard!.instantiateViewControllerWithIdentifier("menu")
        transition = EasyTransition(attachedViewController: menuVC)
        transition?.transitionDuration = 0.3
        transition?.direction = .Top
        transition?.blurEffectStyle = .Dark
        transition?.margins = UIEdgeInsets(top: 100, left: 20, bottom: 100, right: 20)
        presentViewController(menuVC, animated: true, completion: nil)
    }
    
    @IBAction func showRight(sender: AnyObject) {
        let menuVC = storyboard!.instantiateViewControllerWithIdentifier("menu")
        transition = EasyTransition(attachedViewController: menuVC)
        transition?.transitionDuration = 0.4
        transition?.direction = .Right
        transition?.blurEffectStyle = .Light
        transition?.margins = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 0)
        presentViewController(menuVC, animated: true, completion: nil)
    }
    
    @IBAction func showBottom(sender: AnyObject) {
        let menuVC = storyboard!.instantiateViewControllerWithIdentifier("menu")
        transition = EasyTransition(attachedViewController: menuVC)
        transition?.transitionDuration = 0.5
        transition?.direction = .Bottom
        transition?.margins = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        transition?.sizeMax = CGSize(width: CGFloat.max, height: 200)
        presentViewController(menuVC, animated: true, completion: nil)
    }

    @IBAction func showLeft(sender: AnyObject) {
        let menuVC = storyboard!.instantiateViewControllerWithIdentifier("menu")
        transition = EasyTransition(attachedViewController: menuVC)
        transition?.transitionDuration = 0.4
        transition?.direction = .Left
        transition?.margins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        transition?.sizeMax = CGSize(width: 250, height: CGFloat.max)
        transition?.zTransitionSize = 100
        transition?.backgroundColor = UIColor.clearColor()
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

// Sample target View Controller

class ExampleMenuViewController: UITableViewController {
    
    @IBAction func dismiss(sender: AnyObject?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dismiss(nil)
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

