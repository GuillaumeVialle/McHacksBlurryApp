//
//  ViewController.swift
//  BlurryApp
//
//  Created by Guillaume Vialle on 2018-02-04.
//  Copyright © 2018 Guillaume Vialle. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    @IBOutlet weak var imagePicked: UIImageView!
    var prevPoint1: CGPoint!
    var prevPoint2: CGPoint!
    var lastPoint:CGPoint!
    
    var blurring: Bool = false
    
    var width: CGFloat!
    var red:CGFloat!
    var green:CGFloat!
    var blue:CGFloat!
    var alpha: CGFloat!
    
    var radius : Int = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        width = 1.0
        red = (255.0/255.0)
        green = (255.0/255.0)
        blue = (255.0/255.0)
        alpha = 1.0

    }
    

    @IBAction func slider(_ sender: UISlider) {
        sender.maximumValue = 300
        sender.minimumValue = 10
        var currentValue = Int(sender.value)
        print (currentValue)
        radius = currentValue
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if (blurring) {
                let position = touch.location(in: view)
                //var copyImage: UIImage = imageView.image!
                
                addBlurArea(x: Int(position.x), y: Int(position.y))
                
                //imageView.image = copyImage
            }
            
        }
    }
    
    @IBAction func openCameraButton(sender: AnyObject) {
        ResetButton((Any).self)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func openPhotoLibraryButton(sender: AnyObject) {
        ResetButton((Any).self)
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePicked.image = image
        dismiss(animated:true, completion: nil)
    }
    
    @IBAction func saveButt(sender: AnyObject) {
        
        
        let imageData = UIImageJPEGRepresentation(imagePicked.image!, 0.6)
        let compressedJPGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        
        let alert = UIAlertView(title: "Done",
                                message: "Your image has been saved to Photo Library!",
                                delegate: nil,
                                cancelButtonTitle: "Ok")
        alert.show()
    }
    
    @IBAction func btn(_ sender: Any) {
        blurring = true
    }
    

    
    func addBlurArea(x: Int, y: Int) {
        
        
        //var blur: UIView! = view
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = imagePicked.frame
        
        blurEffectView.alpha = 0.1
        blurEffectView.isUserInteractionEnabled = false
        imagePicked.addSubview(blurEffectView)
        
        let circleSize: CGFloat = CGFloat(radius)
        
        let path = UIBezierPath (
            roundedRect: blurEffectView.frame,
            cornerRadius: 0)
        
        let circle = UIBezierPath (
            roundedRect: CGRect (origin: CGPoint (x: x - Int(circleSize/2), y: y-Int(circleSize/2)),
                                 size: CGSize (width: circleSize, height: circleSize)), cornerRadius: circleSize/2)
        
        
        path.append(circle)
        path.usesEvenOddFillRule = false
        
        let maskLayer = CAShapeLayer ()
        maskLayer.path = path.cgPath
        maskLayer.fillRule = kCAFillRuleEvenOdd
        
        blurEffectView.layer.mask = maskLayer
        
    
        
    }

    @IBAction func ResetButton(_ sender: Any) {
        for subview in imagePicked.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
}

