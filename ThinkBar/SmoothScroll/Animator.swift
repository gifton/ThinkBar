import UIKit

protocol TBAnimatable: AnyObject {
    func update(toAnimationProgress progress: CGFloat)
}

class TBViewAnimator {
    private var animatableViews: NSHashTable<AnyObject> = NSHashTable<AnyObject>.weakObjects()
    
    private var currentProgress: CGFloat = 0.0
    
    func register(animatableView view: TBAnimatable) {
        view.update(toAnimationProgress: currentProgress)
        animatableViews.add(view)
    }
    
    func updateAnimation(toProgress progress: CGFloat) {
        currentProgress = progress
        animatableViews.allObjects.forEach { (view) in
            if let view = view as? TBAnimatable {
                view.update(toAnimationProgress: progress)
            }
        }
    }
}


class TestCell: TBBaseGridCell {
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
}

class HeaderBlock: TBBaseHeader {
    @IBOutlet weak var csTextBottom: NSLayoutConstraint!
    @IBOutlet weak var csImageTop: NSLayoutConstraint!
    
    override func update(toAnimationProgress progress: CGFloat) {
        super.update(toAnimationProgress: progress)
        csTextBottom.constant = 44 + 200 * progress
        csImageTop.constant = -400 * progress * 1.5
        UIView.animate(withDuration: 0.01) {
            self.layoutIfNeeded()
        }
    }
}


class ManuBlock: TBBaseMenu {
    
    override func update(toAnimationProgress progress: CGFloat) {
        super.update(toAnimationProgress: progress)
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
}
