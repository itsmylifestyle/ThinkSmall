//
//  SnapVC.swift
//  SnapchatClone
//
//  Created by Айбек on 04.10.2023.
//

import UIKit
import ImageSlideshow

class SnapVC: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    
    var selectedSnap : snapCellStruct?
    var selectedTime : Int?
    var inputArray = [AlamofireSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        timeLabel.text = "Time Left: "
        
        
        if let snap = selectedSnap {
            for img in snap.imgUrlArr {
                inputArray.append(AlamofireSource(urlString: img)!)
            }
        }
        
        let imgSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.9))
        imgSlideShow.backgroundColor = UIColor.white
        
        imgSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
        imgSlideShow.setImageInputs(inputArray)
        
        self.view.addSubview(imgSlideShow)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
