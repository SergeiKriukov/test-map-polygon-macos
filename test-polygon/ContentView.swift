//
//  ContentView.swift
//  test-polygon
//
//  Created by Наталья on 22.04.2023.
//

import SwiftUI
import MapKit


struct PolygonCheckerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


struct MapView: NSViewRepresentable {
    @Binding var pointX: String
    @Binding var pointY: String
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    
    
    
    
    func makeNSView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        return mapView
    }
    
        
    func updateNSView(_ nsView: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(latitude: 56.0080033408, longitude: 37.2108274698)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
  //      nsView.setRegion(region, animated: true) // ЗАкоментировал, т.к. иначе карта после передвижения скачет обратно в эту точку
        
        nsView.delegate = context.coordinator
    }

    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    

    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
                  self.parent = parent
              }

        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            // Handle map click events here
        }
        

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            let currentLocation = mapView.centerCoordinate
            parent.selectedCoordinate = currentLocation
            
              //  Указатель на центр карты
            // получаем центр карты
            let centerCoordinate = mapView.centerCoordinate
            
            // удаляем все аннотации с карты
            mapView.removeAnnotations(mapView.annotations)
            
            // создаем новую аннотацию с указателем
            let annotation = MKPointAnnotation()
            annotation.coordinate = centerCoordinate
            
            // добавляем новую аннотацию на карту
            mapView.addAnnotation(annotation)
            
            
        }
        
        func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
            // Handle annotation view additions
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            mapView.setCenter(userLocation.coordinate, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            // Handle deselection of annotation views
        }
        
        func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
             // Handle location failure errors
         }
        
        func mapView(_ mapView: MKMapView, didUpdate locations: [MKUserLocation]) {
            // Handle location updates
        }
        
        func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
            // Handle user tracking mode changes
        }
        
           
        func mapView(_ mapView: MKMapView, didTapAt coordinate: CLLocationCoordinate2D) {
             parent.pointX = String(coordinate.latitude)
             parent.pointY = String(coordinate.longitude)
            

         }
        

    }
}







struct ContentView: View {
    @State private var coordinate = CLLocationCoordinate2D()
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var pointX = "56.0080033408"
    @State private var pointY = "37.2108274698"
    @State private var userEnteredLongitude: Double = 0.0
    @State private var userEnteredLatitude: Double = 0.0
    
    @State private var polygonPoints = "56.0083482384,37.2108972073 56.0080033408,37.2108274698 56.007985346,37.2111493349 56.0077664093,37.2114282846 56.0072175625,37.212023735 56.0067766799,37.2119539976 56.0064797561,37.2132468224 56.0063627855,37.21349895 56.0058049209,37.2137725353 56.0054869944,37.2137242556 56.0045601939,37.2127532959 56.0035133924,37.2114497423 56.0034054113,37.2112029791 56.0033754164,37.2110635042 56.003360419,37.2108221054 56.0033544201,37.2105699778 56.0033484211,37.2091162205 56.0033334237,37.2088479996 56.0032164435,37.2083330154 56.00293449,37.2075927258 56.0023225837,37.2083866596 56.0019266392,37.2087192535 56.0015126929,37.2089445591 56.0006007955,37.2045135498 56.0000758448,37.2010159492 56.0003638187,37.2008389235 56.0004208132,37.2010535002 56.0009097632,37.2008281946 56.0012547241,37.2010266781 56.0020556216,37.2006726265 56.0025175549,37.1999377012 56.002286589,37.1986985207 56.0031354571,37.1989613771 56.0031894481,37.1982264519 56.0030724675,37.1981191635 56.0035343887,37.1964401007 56.0041342781,37.1960002184 56.0044612138,37.1949326992 56.0043592342,37.1942782402 56.003810339,37.1928888559 56.0034773987,37.1916764975 56.0028175087,37.1912151575 56.0025355522,37.1903139353 56.0020496224,37.1892678738 56.0021306112,37.1881574392 56.0020076282,37.1878570318 56.002409571,37.1863120794 56.003435406,37.1869826317 56.0038253362,37.1864515543 56.0038583301,37.1852177382 56.0039753083,37.1845847368 56.0052410495,37.1845310926 56.0053760195,37.1841287613 56.0051900607,37.1819669008 56.0051960594,37.1793919802 56.0052980369,37.179107666 56.0066297179,37.1788179874 56.0079493565,37.1785336733 56.0083722312,37.1818381548 56.0105495125,37.1804863214 56.0111822806,37.1801054478 56.011335223,37.1802020073 56.0114341854,37.1804058552 56.0124387894,37.1854323149 56.0130655291,37.1884095669 56.0135093386,37.1904748678 56.0136682692,37.1907645464 56.0149246971,37.192003727 56.0164359549,37.1934735775 56.0185977902,37.1955764294 56.0169996629,37.1995675564 56.0154914257,37.203258276 56.014411701174645,37.20581173893491 56.01498665023998,37.20790922642529 56.015073204898066,37.20868170258586 56.01472468673209,37.209309339490694 56.01439078661718,37.2098082303829 56.01382842962304,37.210114002270274 56.01350853031288,37.209770679508516 56.0130535342,37.2085690498 56.0129695696,37.2076678276 56.0127296699,37.2067022324 56.0123578223,37.2058224678 56.012261861,37.2061228752 56.0117460653,37.2062730789 56.0113262264,37.2062301636 56.0111942761,37.2088909149 56.0108584006,37.2109991312 56.0099617186,37.2108274698 56.0100067031,37.2110527754 56.009766785,37.2115087509 56.0093049383,37.2117233276 56.0091459898,37.2112619877 56.0090380244,37.2113478184 56.0087441171,37.2112780809 56.0083482384,37.2108972073"
    @State private var result = ""
    
    var body: some View {


        VStack {
            MapView(pointX: $pointX, pointY: $pointY, selectedCoordinate: $selectedCoordinate)
                        .edgesIgnoringSafeArea(.all)
            
            if let coordinate = selectedCoordinate {
                Text("Координаты цента карты (при перемещении карты): \(coordinate.latitude), \(coordinate.longitude)")
            }
        
        
            Text("Введите координаты точки:")
                .font(.headline)
            
            HStack {
                TextField("X", text: $pointX)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Y", text: $pointY)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                
                
                
                Button("Применить координаты", action: {
                    //не работает пока применение координат

                    if let latitude = Double(pointX),
                       let longitude = Double(pointY) {
                        selectedCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    } })
            }
            .padding()

            
            Text("Введите координаты вершин полигона через запятую:")
                .font(.headline)
            
            TextField("1,2 3,4 5,6", text: $polygonPoints)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                let point = CGPoint(x: Double(pointX) ?? 0, y: Double(pointY) ?? 0)
                let polygonArray = polygonPoints
                    .split(separator: " ")
                    .map { pointString -> CGPoint in
                        let components = pointString.split(separator: ",")
                        let x = Double(components[0]) ?? 0
                        let y = Double(components[1]) ?? 0
                        return CGPoint(x: x, y: y)
                    }
                
                let isInside = pointInsidePolygon(point: point, polygon: polygonArray)
                result = isInside ? "Точка внутри полигона" : "Точка вне полигона"
            }) {
                Text("Проверить")
            }
            .padding()
            
            Text(result)
                .font(.headline)
        }
        .padding()
    }
    
    func pointInsidePolygon(point: CGPoint, polygon: [CGPoint]) -> Bool {
        var j = polygon.count - 1
        var inside = false
        for i in 0..<polygon.count {
            print(polygon[i].y)
            if polygon[i].y < point.y && polygon[j].y >= point.y || polygon[j].y < point.y && polygon[i].y >= point.y {
                if polygon[i].x + (point.y - polygon[i].y) / (polygon[j].y - polygon[i].y) * (polygon[j].x - polygon[i].x) < point.x {
                    inside = !inside
                }
            }
            j = i
        }
        return inside
    }
}
