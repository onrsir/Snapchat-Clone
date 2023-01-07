//
//  SnapVC.swift
//  SnapChatCloneFirebase
//
//  Created by Onur Sir on 30.12.2022.
//

import UIKit
import ImageSlideshow
import ImageSlideshowKingfisher
class SnapVC: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    
    var selectedSnap : Snap?
    var inputArray = [KingfisherSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
    
        
        if let snap = selectedSnap {
            
            
            timeLabel.text = "Time left: \(snap.timeDifferent) hour"
            for urlCekelim in snap.imageUrlArray {
                inputArray.append(KingfisherSource(urlString: urlCekelim)!)
            }
            
            let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95 , height: self.view.frame.height * 0.90))
            
            imageSlideShow.backgroundColor = UIColor.white
            
            imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
            imageSlideShow.setImageInputs(inputArray)
            
            self.view.addSubview(imageSlideShow)
            self.view.bringSubviewToFront(timeLabel) // kalan süreyi fotoğrafın arkasında kalmıştı önüne aldık.
            
        }


    }
    


    
    
    
}
