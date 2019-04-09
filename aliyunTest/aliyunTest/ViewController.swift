//
//  ViewController.swift
//  aliyunTest
//
//  Created by Lucky on 2019/4/9.
//  Copyright © 2019 Lucky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addBtn = UIButton.init(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        addBtn.setTitle("上传", for: UIControl.State.normal)
        self.view.addSubview(addBtn)
        addBtn.backgroundColor = UIColor.gray
        addBtn.addTarget(self, action: #selector(addFile), for: UIControl.Event.touchUpInside)
        
        
        let addViewBtn = UIButton.init(frame: CGRect(x: 100, y: 200, width: 100, height: 100))
        addViewBtn.setTitle("上传界面", for: UIControl.State.normal)
        addViewBtn.backgroundColor = UIColor.blue
        self.view.addSubview(addViewBtn)
        addViewBtn.addTarget(self, action: #selector(goToTestVC), for: UIControl.Event.touchUpInside)
        
        
    }

    
    @objc func addFile() {
        
        let filePath:String = Bundle.main.path(forResource: "testVideo", ofType: "mp4")!
//        let filePath:String = Bundle.main.path(forResource: "default_pictureIconhhhh", ofType: "png")
        
        let vodInfo:VodInfo = VodInfo();
        vodInfo.cateId = 19;
        
        GLVODUpload.sharedInstance().uploadFile(withFilePath: filePath, videoInfo:  vodInfo)
        GLVODUpload.sharedInstance().start()
        
    }
    
    @objc func goToTestVC() {
        let test:TestViewController = TestViewController.init()
        self.present(test, animated: true, completion: nil)
    }
}

