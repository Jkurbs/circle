//
//  CircleVC.swift
//  Circle
//
//  Created by Kerby Jean on 2/10/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


enum State {
    case collapsed
    case expanded
}


class CircleVC: UIViewController {
    
    // Views
    let contentView = ContentView()
    var settingsView: SettingsView!
    var selectedUserView: SelectedUserView!
    var welcomeView: IntroView!
    let circleInsightView: CircleInsightView = UIView.fromNib()

    var loadingView = LoadingView()
    var circleView = CircleView()
    var circleButton = UIButton()
    
    // Cells
    var selectedIndex: IndexPath?
    var users = [User?]()
    var cell: EmbeddedCollectionViewCell!
    
    var userViewIsShow: Bool = false
    
    var circleId: String?
    
    // Constant
    let commentViewHeight: CGFloat = 64.0
    let animatorDuration: TimeInterval = 1
    
    // Tracks all running aninmators
    var progressWhenInterrupted: CGFloat = 0
    var runningAnimators = [UIViewPropertyAnimator]()
    var state: State = .collapsed
    
    var index: IndexPath!
    var insightCell: CircleInsightCell!
    
    
    let impact = UIImpactFeedbackGenerator()
    let selection = UISelectionFeedbackGenerator()
    let notification = UINotificationFeedbackGenerator()
    
    
    lazy var collectionView: UICollectionView = {
        let layout = CircleLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        contentView.addSubview(view)
        return view
    }()

    private var listener: ListenerRegistration? {
        didSet {
            oldValue?.remove()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
            
            //UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        
        collectionView.register(PendingInviteCell.self, forCellWithReuseIdentifier: "PendingInviteCell")

        collectionView.delegate = self
        collectionView.dataSource = self
        addGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        retrieveCircle()
        retrieveUser()
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        DataService.instance.listener = nil 
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
                
        let height: CGFloat = 280
        
        contentView.frame = CGRect(x: 0, y: 20, width: view.frame.width, height: view.frame.height)
        
        // add settingsView
        settingsView = SettingsView(frame: CGRect(x: 0, y: 0, width: contentView.frame.width, height: 60))
        settingsView.settingbutton.addTarget(self, action: #selector(logOut), for: .touchUpInside)

        contentView.addSubview(settingsView)

        welcomeView = IntroView(frame: CGRect(x: 0, y: 45, width: contentView.frame.width, height: height))
        welcomeView.headline.text = "Welcome to your Circle dashboard"
        welcomeView.subhead.text = "You'll receive an notification when an invitation has been accepted"
        
        
        circleInsightView.frame = CGRect(x: 0, y: view.bounds.height - (self.circleInsightView.frame.height + 5), width: view.frame.width, height: self.circleInsightView.frame.height)
        circleInsightView.circleId = self.circleId
        circleInsightView.vc = self
        self.contentView.addSubview(circleInsightView)
        
        // Add userView
        
        selectedUserView = SelectedUserView(frame: CGRect(x: 0, y: 60, width: contentView.frame.width, height: 200))
        contentView.addSubview(selectedUserView)
        
        
        collectionView.frame = CGRect(x: 0, y: selectedUserView.bounds.height + 100, width: view.frame.width, height: 350)
        
        circleView.frame = CGRect(x: 0, y: selectedUserView.bounds.height + 100, width: view.frame.width - 80, height: 350)
        circleView.center.x = collectionView.center.x
        contentView.insertSubview(circleView, at: 0)
        
        loadingView.frame = collectionView.frame
        loadingView.center.y = collectionView.center.y
    }
    
    func retrieveUser() {
        self.circleId = nil
        self.view.addSubview(loadingView)
        let circleId  = self.circleId ?? UserDefaults.standard.string(forKey: "circleId") ?? ""
                
        DataService.instance.getInsiders(circleId, { (success, error, user) in
            self.users.append(user)
            self.collectionView.insertItems(at: [IndexPath(row: self.users.count - 1, section: 0 )])
        })
    }
    
    func retrieveCircle() {
        let circleId  = self.circleId ?? UserDefaults.standard.string(forKey: "circleId") ?? ""
        DataService.instance.retrieveCircle(circleId){ (success, error, circle) in
            if !success {
                print("ERRROR RETRIVING CIRCLE", error!.localizedDescription)
            } else {
                self.setup()
                let daysPassed = (circle?.daysTotal)! - (circle?.daysLeft)!
                let daysTotal = (circle?.daysTotal)
                self.circleView.maximumValue = CGFloat(daysTotal!)
                self.circleView.endPointValue = CGFloat(daysPassed)
                self.loadingView.removeFromSuperview()
                self.setup()
            }
        }
    }
    
    
    func setup() {
        view.addSubview(contentView)
    }

    
    @objc func logOut() {
        UserDefaults.standard.removeObject(forKey: "userId")
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            DispatchQueue.main.async {
                let controller = LoginVC()
                let nav = UINavigationController(rootViewController: controller)
                self.present(nav, animated: true, completion: nil)
            }
        } catch let signOutError as NSError {
            print("SIGNOUT ERROR:\(signOutError)")
        }
    }
    
    @objc func addUsers() {
        let controller = InviteVC()
        let nav = UINavigationController(rootViewController: controller)
        self.present(nav, animated: true, completion: nil)
    }
}




// MARK: COLLECTIONVIEW DELEGATE, DATASOURCE

extension CircleVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PendingInviteCell", for: indexPath) as! PendingInviteCell
        let user = self.users[indexPath.row]
        cell.configure(user)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let user = self.users[indexPath.row]
        
        if(selectedIndex != indexPath) {
            var indicesArray = [IndexPath]()
            if(selectedIndex != nil) {
                let cell = collectionView.cellForItem(at: selectedIndex!) as! PendingInviteCell
                UIView.animate(withDuration: 0.3, animations: {
                    cell.layer.borderColor = UIColor(white: 0.8, alpha: 1.0).cgColor
                    cell.transform = CGAffineTransform.identity
                }, completion: { (completion) in
                })
                indicesArray.append(selectedIndex!)
            }
            
            impact.impactOccurred()
            
            selectedIndex = indexPath
            let cell = collectionView.cellForItem(at: indexPath) as! PendingInviteCell
            let image = cell.imageView.image
                UIView.animate(withDuration: 0.3, animations: {
                    cell.layer.borderColor = UIColor(red: 232.0/255.0, green:  126.0/255.0, blue:  4.0/255.0, alpha: 1.0).cgColor
                    cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }, completion: { (completion) in
                    self.selectedUserView.configure(image: image, user: user!)
                    self.settingsView.configure(user!.firstName!)
                })
            indicesArray.append(indexPath)
        }
    }
    
    func hideViews(hideView: UIView, showView: UIView) {
        hideView.alpha = 0.0
        hideView.isHidden = true
        showView.alpha = 1.0
        showView.isHidden = false
    }
}


extension CircleVC {
    private func addGestures() {
        // Tap gesture
        circleInsightView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(_:))))
        
        // Pan gesutre
        circleInsightView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(_:))))
    }
    
    // MARK: Util
    private func expandedFrame() -> CGRect {
        return CGRect(
            x: 0,
            y: 0,
            width: self.view.frame.width,
            height: self.view.frame.height - 0
        )
    }
    
    private func collapsedFrame() -> CGRect {
        return CGRect(
            x: 0,
            y: self.circleInsightView.frame.height - 90,
            width: self.view.frame.width,
            height: self.circleInsightView.frame.height)
    }
    
    private func fractionComplete(state: State, translation: CGPoint) -> CGFloat {
        let translationY = state == .expanded ? -translation.y : translation.y
        return translationY / (self.view.frame.height - commentViewHeight - 0) + progressWhenInterrupted
    }
    
    private func nextState() -> State {
        switch self.state {
        case .collapsed:
            return .expanded
        case .expanded:
            return .collapsed
        }
    }
    
    // MARK: Gesture
    @objc private func handleTapGesture(_ recognizer: UITapGestureRecognizer) {
        self.animateOrReverseRunningTransition(state: self.nextState(), duration: animatorDuration)
    }
    
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        
        switch recognizer.state {
        case .began:
            self.startInteractiveTransition(state: self.nextState(), duration: animatorDuration)
        case .changed:
            self.updateInteractiveTransition(fractionComplete: self.fractionComplete(state: self.nextState(), translation: translation))
        case .ended:
            self.continueInteractiveTransition(fractionComplete: self.fractionComplete(state: self.nextState(), translation: translation))
        default:
            break
        }
    }
    
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        if self.state == .expanded {
            self.animateOrReverseRunningTransition(state: self.nextState(), duration: animatorDuration)
        }
    }
    // MARK: Animation
    // Frame Animation
    private func addFrameAnimator(state: State, duration: TimeInterval) {
        // Frame Animation
        let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
            switch state {
            case .expanded:
                self.circleInsightView.frame = self.expandedFrame()
            case .collapsed:
                self.circleInsightView.frame = self.collapsedFrame()
            }
        }
        frameAnimator.addCompletion({ (position) in
            switch position {
            case .start:
                // Fix blur animator bug don't know why
                switch self.state {
                case .expanded:
                    print("Expanded")
                 //self.blurEffectView.effect = UIBlurEffect(style: .dark)
                case .collapsed:
                    print("Collapse")
                 //self.blurEffectView.effect = nil
                }
            case .end:
                self.state = self.nextState()
            default:
                break
            }
            self.runningAnimators.removeAll()
        })
        runningAnimators.append(frameAnimator)
    }
    
    // Blur Animation
    private func addBlurAnimator(state: State, duration: TimeInterval) {
        var timing: UITimingCurveProvider
        switch state {
        case .expanded:
            timing = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.75, y: 0.1), controlPoint2: CGPoint(x: 0.9, y: 0.25))
        case .collapsed:
            timing = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.1, y: 0.75), controlPoint2: CGPoint(x: 0.25, y: 0.9))
        }
        let blurAnimator = UIViewPropertyAnimator(duration: duration, timingParameters: timing)
        if #available(iOS 11, *) {
            blurAnimator.scrubsLinearly = false
        }
        blurAnimator.addAnimations {
            switch state {
            case .expanded:
                print("Expanded")
            // self.blurEffectView.effect = UIBlurEffect(style: .dark)
            case .collapsed:
                print("Collapse")
                // self.blurEffectView.effect = nil
            }
        }
        runningAnimators.append(blurAnimator)
    }
    
    // Label Scale Animation
    private func addLabelScaleAnimator(state: State, duration: TimeInterval) {
        
        let scaleAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
            switch state {
            case .expanded:
                self.selectedUserView.alpha = 0.0
                self.circleInsightView.collectionView.isScrollEnabled = true
                //self.insightCell.endTimeLabel.enlarge()
                //self.insightCell.nextPayoutLabel.enlarge()
            case .collapsed:
                self.selectedUserView.alpha = 1.0
                self.circleInsightView.collectionView.isScrollEnabled = false
//                self.insightCell.endTimeLabel.shrink()
//                self.insightCell.nextPayoutLabel.shrink()
            }
        }
        runningAnimators.append(scaleAnimator)
    }
    
    // CornerRadius Animation
    //    private func addCornerRadiusAnimator(state: State, duration: TimeInterval) {
    //        commentView.clipsToBounds = true
    //        // Corner mask
    //        if #available(iOS 11, *) {
    //            commentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    //        }
    //        let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
    //            switch state {
    //            case .expanded:
    //                self.commentView.layer.cornerRadius = 12
    //            case .collapsed:
    //                self.commentView.layer.cornerRadius = 0
    //            }
    //        }
    //        runningAnimators.append(cornerRadiusAnimator)
    //    }
    
    // KeyFrame Animation
    private func addKeyFrameAnimator(state: State, duration: TimeInterval) {
        let keyFrameAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
            UIView.animateKeyframes(withDuration: 0, delay: 0, options: [], animations: {
                switch state {
                case .expanded:
                    UIView.addKeyframe(withRelativeStartTime: duration / 2, relativeDuration: duration / 2, animations: {
                        //self.commentHeaderView.alpha = 1
                        //self.backButton.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
                        //self.closeButton.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
                    })
                case .collapsed:
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration / 2, animations: {
                        // self.commentHeaderView.alpha = 0
                        // self.backButton.transform = CGAffineTransform.identity
                        // self.closeButton.transform = CGAffineTransform.identity
                    })
                }
            }, completion: nil)
        }
        runningAnimators.append(keyFrameAnimator)
    }
    
    // Perform all animations with animators if not already running
    func animateTransitionIfNeeded(state: State, duration: TimeInterval) {
        if runningAnimators.isEmpty {
            self.addFrameAnimator(state: state, duration: duration)
            self.addBlurAnimator(state: state, duration: duration)
            self.addLabelScaleAnimator(state: state, duration: duration)
            // self.addCornerRadiusAnimator(state: state, duration: duration)
            self.addKeyFrameAnimator(state: state, duration: duration)
        }
    }
    
    // Starts transition if necessary or reverse it on tap
    func animateOrReverseRunningTransition(state: State, duration: TimeInterval) {
        if runningAnimators.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
            runningAnimators.forEach({ $0.startAnimation() })
        } else {
            runningAnimators.forEach({ $0.isReversed = !$0.isReversed })
        }
    }
    
    // Starts transition if necessary and pauses on pan .began
    func startInteractiveTransition(state: State, duration: TimeInterval) {
        self.animateTransitionIfNeeded(state: state, duration: duration)
        runningAnimators.forEach({ $0.pauseAnimation() })
        progressWhenInterrupted = runningAnimators.first?.fractionComplete ?? 0
    }
    
    // Scrubs transition on pan .changed
    func updateInteractiveTransition(fractionComplete: CGFloat) {
        runningAnimators.forEach({ $0.fractionComplete = fractionComplete })
    }
    
    // Continues or reverse transition on pan .ended
    func continueInteractiveTransition(fractionComplete: CGFloat) {
        let cancel: Bool = fractionComplete < 0.2
        
        if cancel {
            runningAnimators.forEach({
                $0.isReversed = !$0.isReversed
                $0.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            })
            return
        }
        let timing = UICubicTimingParameters(animationCurve: .easeOut)
        runningAnimators.forEach({ $0.continueAnimation(withTimingParameters: timing, durationFactor: 0) })
    }


}










