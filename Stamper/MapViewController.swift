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
	
	var markers = [NMFMarker]()
	var mark = NMFMarker()
	let cameraPosition = NMFCameraPosition()
	var nameOfAddress = ""
	
	let queue = DispatchQueue(label: "alamofire", qos: .utility, attributes: [.concurrent])
	var infoWindow = NMFInfoWindow()
	var defaultInfoWindowImage = NMFInfoWindowDefaultTextSource.data()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		setup()
		
		DispatchQueue.main.async {
			
			self.mark.captionText = self.nameOfAddress
		}
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
		
//		print("\(cameraPosition.target.lat), \(cameraPosition.target.lng)")
		let reslat = cameraPosition.target.lat
		let reslng = cameraPosition.target.lng
		
		var strlat = String(format:"%f",reslat)
		var strlng = String(format:"%f",reslng)
		
		self.nameOfAddress = self.requestAddress(strlat, strlng)
		var mark  = NMFMarker(position: NMGLatLng(lat: reslat, lng: reslng))
		mark.iconImage = NMF_MARKER_IMAGE_YELLOW
		mark.isFlat = true
		mark.captionTextSize = 14
		
		mark.mapView = self.mapView
		markers.append(mark)
	}
	
	func requestAddress(_ lat: String, _ lng: String ) -> String {
		let headers: HTTPHeaders = [
		"X-NCP-APIGW-API-KEY-ID": Bundle.main.object(forInfoDictionaryKey: "API_KEY_ID") as! String,
		"X-NCP-APIGW-API-KEY": Bundle.main.object(forInfoDictionaryKey: "API_KEY") as! String
		]
		var result = ""
		let url = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?coords=\(lng),\(lat)&orders=roadaddr&output=json"
		Alamofire.request(url, headers: headers).responseJSON{
			response in
				if let json = response.result.value as? [String:Any] {
					if let res = json["results"] as? [Any] {
						if let addr = res[0] as? [String:Any] {
							if let land = addr["land"] as? [String:Any],
							let add0 = land["addition0"] as? [String:Any],
							let value = add0["value"] as? String {

								result = value
								print(result)
							}
						}
					}
				}
			
			}
			
	
		return result
	}
	
	
}
