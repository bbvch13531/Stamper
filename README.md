# Stamper-naver-map-SDK
Stamper iOS app using Naver map SDK

## 현재 카메라의 좌표에 마커를 생성하고 Reverse Geocoding API로 해당 좌표의 주소를 caption으로 만드는 Naver map SDK예제

```
// 현재 카메라의 좌표를 가져옴
let cameraPosition = self.mapView.cameraPosition

// 경도, 위도를 인자로 해당 좌표의 주소를 요청
// Reverse Geocoding API의 gc를 사용.
self.nameOfAddress = self.requestAddress(strlat, strlng)

let headers: HTTPHeaders = [
		"X-NCP-APIGW-API-KEY-ID": "API_KEY_ID",
		"X-NCP-APIGW-API-KEY": "API_KEY"
		]
let url = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?coords=\(strlng),\(strlat)&orders=roadaddr&output=json"
Alamofire.request(url, headers: headers).responseJSON
response를 파싱하여 최종 주소를 리턴.


// MARK : 좌표와 주소 이름으로 NMFMarker 생성
var mark  = NMFMarker(position: NMGLatLng(lat: reslat, lng: reslng))
		mark.iconImage = NMF_MARKER_IMAGE_YELLOW
		mark.isFlat = true
		mark.captionTextSize = 14
        mark.captionText= self.nameOfAddress
		mark.mapView = self.mapView

```



Demo
![](./Images/naver-ios-sdk.gif)
