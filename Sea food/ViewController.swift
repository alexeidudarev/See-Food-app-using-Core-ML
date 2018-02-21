//
//  ViewController.swift
//  Sea food
//
//  Created by hackeru on 21/02/2018.
//  Copyright © 2018 alexei dudarev. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
       
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image : userPickedImage) else {
                fatalError("Could not convert UIImage into CIImage")
            }
            detect(image: ciimage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func detect(image : CIImage){
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model Failed.")
        }
        let request  = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("Model fail to process image.")
            }
            if let firstResult = results.first{
                if firstResult.identifier.contains("hotdog"){
                    self.navigationItem.title = "Hotdog!!!"
                }else if firstResult.identifier.contains("burger"){
                    self.navigationItem.title = "It's a burger bro!"
                }else{
                    self.navigationItem.title = "Not Hotdog!!!"
                }
            }
        }
        let handler = VNImageRequestHandler(ciImage : image)
        
        do{
            try handler.perform([request])
            
        }catch{
            print (error)
        }
        
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}













