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
    
    var width: CGFloat!
    var red:CGFloat!
    var green:CGFloat!
    var blue:CGFloat!
    var alpha: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        width = 1.0
        red = (255.0/255.0)
        green = (255.0/255.0)
        blue = (255.0/255.0)
        alpha = 1.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            prevPoint1 = touch.previousLocation(in:self.view)
            prevPoint2 = touch.previousLocation(in:self.view)
            lastPoint = touch.location(in:self.view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            prevPoint2 = prevPoint1
            prevPoint1 = touch.previousLocation(in: self.view)
            
            UIGraphicsBeginImageContext(imagePicked.frame.size)
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
            
            context.move(to:prevPoint2)
            context.addQuadCurve(to: prevPoint1, control: prevPoint2)
            context.setLineCap(.butt)
            context.setLineWidth(width)
            context.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
            context.setBlendMode(.normal)
            context.strokePath()
            
            imagePicked.image?.draw(in: CGRect(x: 0, y: 0, width: imagePicked.frame.size.width, height: imagePicked.frame.size.height), blendMode: .overlay, alpha: 1.0)
            imagePicked.image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            lastPoint = currentPoint
        }
    }
    
    @IBAction func openCameraButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func openPhotoLibraryButton(sender: AnyObject) {
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
        let imageData = UIImageJPEGRepresentation(imagePicked.image!, 0.6)
        let compressedJPGImage = UIImage(data: imageData!)
        let image = simpleBlurFilterExample(inputImage: compressedJPGImage!)
        imagePicked.image = image
    }
    
    func simpleBlurFilterExample(inputImage: UIImage) -> UIImage {
        // convert UIImage to CIImage
        let inputCIImage = CIImage(image: inputImage)!
        
        // Create Blur CIFilter, and set the input image
        let blurFilter = CIFilter(name: "CIGaussianBlur")!
        blurFilter.setValue(inputCIImage, forKey: kCIInputImageKey)
        blurFilter.setValue(8, forKey: kCIInputRadiusKey)
        
        // Get the filtered output image and return it
        let outputImage = blurFilter.outputImage!
        return UIImage(ciImage: outputImage)
    }

}

