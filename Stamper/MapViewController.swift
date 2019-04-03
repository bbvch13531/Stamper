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
	
	var markerWithCaption = NMFMarker()
	let cameraPosition = NMFCameraPosition()
	var nameOfAddress = ""
	
	let queue = DispatchQueue(label: "alamofire", qos: .utility, attributes: [.concurrent])
	
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
		
//		let arrowView = UIImageView(image: UIImage(named:"arrow"))
		
//		self.mapView.addSubview(arrowView)
		self.mapView.addSubview(createMarkerButton)
	}
	
	@objc
	func createMarker(sender: UIButton){
		let cameraPosition = self.mapView.cameraPosition
		
//		print("\(cameraPosition.target.lat), \(cameraPosition.target.lng)")
		let reslat = cameraPosition.target.lat
		let reslng = cameraPosition.target.lng
		
		var strlat = String(format:"%f",reslat)
		var strlng = String(format:"%f",reslng)
		var markerWithCaption = NMFMarker(position: NMGLatLng(lat: reslat, lng: reslng))
		markerWithCaption.iconImage = NMF_MARKER_IMAGE_YELLOW
		markerWithCaption.isFlat = true
		markerWithCaption.captionTextSize = 14
		markerWithCaption.mapView = self.mapView
		
		DispatchQueue.global(qos: .background).sync {
			print(1)
			
			print(self.nameOfAddress)
			print(3)
			DispatchQueue.main.async {
				print(2)
				
				self.nameOfAddress = self.requestAddress(strlat, strlng)
				markerWithCaption.captionText = self.nameOfAddress
//				markerWithCaption.captionText = "hello"
			}
		}
		
		
//		print("\(reslat),\(reslng), \(markerWithCaption)")
	}
	
	func requestAddress(_ lat: String, _ lng: String ) -> String {
		let headers: HTTPHeaders = [
		"X-NCP-APIGW-API-KEY-ID": Bundle.main.object(forInfoDictionaryKey: "API_KEY_ID") as! String,
		"X-NCP-APIGW-API-KEY": Bundle.main.object(forInfoDictionaryKey: "API_KEY") as! String
		]
		var result = ""
		var url = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?coords=\(lng),\(lat)&orders=roadaddr&output=json"
		Alamofire.request(url, headers: headers).responseJSON(
			queue: queue,
			completionHandler: {response in
				if let json = response.result.value as? [String:Any] {
					if let res = json["results"] as? [Any] {
						if let addr = res[0] as? [String:Any] {
							if let land = addr["land"] as? [String:Any],
							let add0 = land["addition0"] as? [String:Any],
							let value = add0["value"] as? String {

								result = value
								print(result)
								self.markerWithCaption.captionText = result
							}
						}
					}
				}
			}
			
		)
		return result
	}
	
}
