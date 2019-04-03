//
//  ViewController.swift
//  Stamper
//
//  Created by KyungYoung Heo on 04/04/2019.
//  Copyright © 2019 KyungYoung Heo. All rights reserved.
//

import UIKit
import NMapsMap
class MapViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		let mapView = NMFNaverMapView(frame: view.frame)
		view.addSubview(mapView)
	}


}

