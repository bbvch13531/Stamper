//
//  ViewController.swift
//  Stamper
//
//  Created by KyungYoung Heo on 04/04/2019.
//  Copyright © 2019 KyungYoung Heo. All rights reserved.
//

import UIKit
import NMapsMap
import Alamofire

class MapViewController: UIViewController {
	lazy var mapView: NMFMapView = {
		return NMFMapView(frame: self.view.frame)
	}()
	let cameraPosition = NMFCameraPosition()
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		setup()
		view.addSubview(self.mapView)
	}
	func setup(){
		let createMarkerButton = UIButton(frame: CGRect(x: 100, y: 700, width: 130, height: 50))
		createMarkerButton.addTarget(self, action: #selector(self.createMarker), for: .touchUpInside)
		createMarkerButton.setTitle("Create", for: .normal)
		createMarkerButton.backgroundColor = UIColor.black
		createMarkerButton.layer.cornerRadius = 15
		self.mapView.addSubview(createMarkerButton)
	}
	
	@objc
	func createMarker(sender: UIButton){
		
		let cameraPosition = self.mapView.cameraPosition
		print("\(cameraPosition.target.lat), \(cameraPosition.target.lng)")
		var strlat = String(format:"%f",cameraPosition.target.lat)
		var strlng = String(format:"%f",cameraPosition.target.lng)
		
		var res = requestAddress(strlat, strlng)
	}
	
	func requestAddress(_ lat: String, _ lng: String ) -> String {
		let headers: HTTPHeaders = [
		"X-NCP-APIGW-API-KEY-ID": "soxouwjilk",
		"X-NCP-APIGW-API-KEY": "Q9oV7NJp1RZD7negfm7A3xwmlkDN3KWvMwYlnpoO"
		]
		var result:String
		var url = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?coords=127.106338,37.362092&orders=roadaddr&output=json"
		Alamofire.request(url, headers: headers).responseJSON {
			response in
//			if let json = response.result as? [Any] {
//					print(json)
//			}
				print(response)
		}
		
		return ""
	}
}

