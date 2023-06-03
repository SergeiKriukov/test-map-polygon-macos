//
//  ContentView.swift
//  test-polygon
//
//  Created by Наталья on 22.04.2023.
//

import SwiftUI
import MapKit

struct MapView: NSViewRepresentable {
    var courts: [Court]
    @Binding var selectedCourt: Court?




    let polygonCoordinates: [[CLLocationCoordinate2D]] = [
        [CLLocationCoordinate2D(latitude: 55.9965389912, longitude: 37.2119915485),
         CLLocationCoordinate2D(latitude: 55.984759145, longitude: 37.2248339653),
         CLLocationCoordinate2D(latitude: 55.9953659683, longitude: 37.2312766314),
         CLLocationCoordinate2D(latitude: 55.9965389912, longitude: 37.2119915485)]
    ]
    

    func makeNSView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator // Установка делегата
        // Добавление распознавателя жестов для клика мышкой
                let clickGesture = NSClickGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleMapClick(_:)))
                mapView.addGestureRecognizer(clickGesture)
        
        return mapView
    }

    func updateNSView(_ mapView: MKMapView, context: Context) {
        // Удаление всех предыдущих аннотаций и оверлеев
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        

        // Создание аннотации для центральной точки полигона
        let centerCoordinate = calculateCenterCoordinate()
        let centerAnnotation = MKPointAnnotation()
        centerAnnotation.coordinate = centerCoordinate
        mapView.addAnnotation(centerAnnotation)
        
        let polygonCoordinates = convertStringToCoordinates(selectedCourt?.polygons ?? "[[[55.9965389912,37.2119915485],[55.984759145,37.2248339653],[55.9953659683,37.2312766314],[55.9965389912,37.2119915485],[55.9965389912,37.2119915485]]]")
        
        print(polygonCoordinates)
             let polygonOverlay = MKPolygon(coordinates: polygonCoordinates, count: polygonCoordinates.count)
             mapView.addOverlay(polygonOverlay)
        
        // Установка региона, чтобы показать весь полигон на экране
        let polygonBoundingRegion = polygonOverlay.boundingMapRect
        let polygonRegion = MKCoordinateRegion(polygonBoundingRegion)
        mapView.setRegion(polygonRegion, animated: true)
        
        

    }
    
    /*  нарисовать сразу все полигоны
     
    func updateNSView(_ mapView: MKMapView, context: Context) {
        // Удаление всех предыдущих аннотаций и оверлеев
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)

        // Создание аннотации для центральной точки полигона
        let centerCoordinate = calculateCenterCoordinate()
        let centerAnnotation = MKPointAnnotation()
        centerAnnotation.coordinate = centerCoordinate
        mapView.addAnnotation(centerAnnotation)

        // Рисование всех полигонов из всех судов на карте
        drawPolygonsOnMap(mapView, courts: courts)
        
        // Установка региона, чтобы показать все полигоны на экране
        let overlays = mapView.overlays
           if !overlays.isEmpty {
               var zoomRect = MKMapRect.null
               for overlay in overlays {
                   zoomRect = zoomRect.union(overlay.boundingMapRect)
               }
               let edgePadding = NSEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
               mapView.setVisibleMapRect(zoomRect, edgePadding: edgePadding, animated: true)
           }
       }
    */
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    // Вычисление среднего значения координат
    private func calculateCenterCoordinate() -> CLLocationCoordinate2D {
        var centerCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        let pointCount = polygonCoordinates[0].count
        for coordinate in polygonCoordinates[0] {
            centerCoordinate.latitude += coordinate.latitude
            centerCoordinate.longitude += coordinate.longitude
        }
        
        centerCoordinate.latitude /= Double(pointCount)
        centerCoordinate.longitude /= Double(pointCount)
        
        return centerCoordinate
    }
    
    // Определение отображения оверлея полигона
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolygon {
            let renderer = MKPolygonRenderer(overlay: overlay)
            renderer.fillColor = NSColor.red.withAlphaComponent(0.5)
            renderer.strokeColor = NSColor.red
            renderer.lineWidth = 2
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
           // Определение отображения оверлея полигона
           func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
               if overlay is MKPolygon {
                   let renderer = MKPolygonRenderer(overlay: overlay)
                   renderer.fillColor = NSColor.red.withAlphaComponent(0.5)
                   renderer.strokeColor = NSColor.red
                   renderer.lineWidth = 2
                   return renderer
               }
               return MKOverlayRenderer(overlay: overlay)
           }
        @objc func handleMapClick(_ gestureRecognizer: NSClickGestureRecognizer) {
                   let mapView = gestureRecognizer.view as! MKMapView
                   let clickPoint = gestureRecognizer.location(in: mapView)
                   let clickCoordinate = mapView.convert(clickPoint, toCoordinateFrom: mapView)
                   
                   // Делегирование координат клика во внешний обработчик
                   // (например, метод в родительском представлении)
                   // Можете использовать @Binding или @State переменную для передачи координат в ContentView
                   print("Clicked coordinate:", clickCoordinate)
               }
       }
    
}


struct ContentView: View {
    @State private var AddressForSearchCourt: String = "г. Москва, пр. Мира, д. 19 56.355325, 41.300396"
    @State private var drawAllPolygons = false // рисовать все полигоны
    @State private var clickCoordinate: CLLocationCoordinate2D?


    @State private var courts: [Court] = []
    @State private var selectedCourt: Court? = nil
    @State private var coordinate = CLLocationCoordinate2D()
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var pointX = "55.9965389912"
    @State private var pointY = "37.2119915485"
    @State private var userEnteredLongitude: Double = 0.0
    @State private var userEnteredLatitude: Double = 0.0
    
    @State private var polygonPoints = "[[[55.9965389912,37.2119915485],[55.984759145,37.2248339653],[55.9953659683,37.2312766314],[55.9965389912,37.2119915485]]]"
    
    @State private var result = ""
    
    let polygonCoordinates: [[CLLocationCoordinate2D]] = [
        [CLLocationCoordinate2D(latitude: 55.9965389912, longitude: 37.2119915485),
         CLLocationCoordinate2D(latitude: 55.984759145, longitude: 37.2248339653),
         CLLocationCoordinate2D(latitude: 55.9953659683, longitude: 37.2312766314),
         CLLocationCoordinate2D(latitude: 55.9965389912, longitude: 37.2119915485)]
    ]
    
    var body: some View {
       
        TabView {
            
            VStack (alignment: .leading){
                
                Text("1. Введите адрес (сводобная форма адреса):")
                    .font(.headline)
                
            
                    TextField("Адрес", text: $AddressForSearchCourt)
                        .padding(.horizontal)
                let result2 = parseAddressAndCoordinates(input: AddressForSearchCourt)
            //    Text("Введён адрес: " + result.address! + ", введены координаты:" + result.coordinates!)
                
                Text("2. Найдите координаты этого адреса на яндекс.картах или гугл.картах:")
                    .font(.headline)
                HStack{
                    Text("Нажмите на одну из ссылок и карта откроется по введенному адресу, скопируйте координаты:")
                    if let url = URL(string: "https://maps.yandex.ru/?text=" + encodeCourtName(result2.address ?? "Москва")) {
                            Link("maps.yandex.ru", destination: url)
                            
                        } else {
                            //
                        }
                        if let url = URL(string: "https://google.com/maps/place/" + encodeCourtName(result2.address ?? "Москва")) {
                            Link("maps.google.ru", destination: url)
                            
                        } else {
                          //
                        }
                }
                Text("3. Полученные координаты (или введите координаты точки):")
                    .font(.headline)
                
                HStack {
                    TextField("X", text: $pointX)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Y", text: $pointY)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                /*
                Button(action: {
                 //   let polygonCoordinates = convertStringToCoordinates(selectedCourt?.polygons ?? "[[[55.9965389912,37.2119915485],[55.984759145,37.2248339653],[55.9953659683,37.2312766314],[55.9965389912,37.2119915485],[55.9965389912,37.2119915485]]]")
                    
                    let polygonCoordinates = convertStringToCoordinates(selectedCourt?.polygons ?? "[[[55.9802514894,37.2259873152],[56.0028864977,37.2255206108],[55.9679052661,37.2529274225],[55.9793931146,37.2305041552],[55.9802514894,37.2259873152]]]")
                    
                    
                    print(polygonCoordinates)
                    
                                let latitude = Double(pointX) ?? 0.0
                                let longitude = Double(pointY) ?? 0.0
                                let point = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    
               
                        let isInsidePolygon = pointInsidePolygon(point, polygonCoordinates: [polygonCoordinates])
                        // let isInsidePolygon = pointInsidePolygon2(point, polygonCoordinates: polygonCoordinates)
                    
                                result = isInsidePolygon ? "Point is inside the polygon" : "Point is outside the polygon"
                    
                            }) {
                                Text("Check Point")
                            }
                            .padding()
                            Text(result)
                                .font(.headline)
                                .padding()
                
                */
              
                Button(action: {
                    if let courtName = findCourtForCoordinates(courts: courts, pointX: Double(pointX) ?? 0.0, pointY: Double(pointY) ?? 0.0) {
                        result = "Court: \(courtName)"
                    } else {
                        result = "Не найден суд (у суда не прописаны полигоны или не загружена база судов)"
                    }
                    
                }) {
                    Text("Найти суд по этим координатам")
                }
                .padding()
                      
                Text(result)
                    .font(.headline)
                    .padding()
                MapView(courts: courts, selectedCourt: $selectedCourt)
            }
            .padding()
            
                .tabItem {
                    Label("Поиск суда по адресу ответчика", systemImage: "star")
                }
            VStack {
                MapView(courts: courts, selectedCourt: $selectedCourt)
                VStack {
                                Text("Выберите суд для показа на карте относящегося к нему полигона координат")
                                    .font(.headline)
                                
                    List(courts, id: \.id) { court in
                        HStack{
                            
                            VStack{
                                Text(court.name)
                                        .font(.headline)
                                Text(court.address)
                                Text(court.code)
                                    // Text(court.website)
                                
                            }
                        
                        Text(court.polygons)
                                .frame(maxHeight: 40)
                        }
                            .padding()
                            .background(selectedCourt == court ? Color.blue : Color.clear)
                            .onTapGesture {
                                selectedCourt = court
                            }
                    }
                            }
                
                if let coordinate = selectedCoordinate {
                    Text("Координаты цента карты (при перемещении карты): \(coordinate.latitude), \(coordinate.longitude)")
                }
    
              

                
    
            }
            .onAppear {
                        // Загрузите данные из файла smallMoscow.json
                        if let url = Bundle.main.url(forResource: "smallMoscow", withExtension: "json"),
                           let data = try? Data(contentsOf: url) {
                            do {
                                // Распарсите JSON-данные и заполните массив courts
                                courts = try JSONDecoder().decode([Court].self, from: data)
                            } catch {
                                print("Ошибка при чтении файла: \(error)")
                            }
                        }
                    }
                .tabItem {
                    Label("Полигоны на карте", systemImage: "star")
                }
            
            VStack{
                Text("Введите координаты полигона:")
                Text("Введите координаты точки:")
                HStack {
                    Text("Введите координаты точки:")
                        .font(.headline)
                    TextField("X", text: $pointX)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Y", text: $pointY)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                }
                Button("Проверить вхождение точки в полигон"){
                    //
                }
            }
                .tabItem {
                    Label("Тест вхождения координат в полигон", systemImage: "star")
                }
            VStack{
                List(courts, id: \.id) { court in
                    VStack(alignment: .leading) {
                        Text(court.name)
                            .font(.headline)
                        Text(court.address)
                            .font(.subheadline)
                        Text(court.polygons)
                            .font(.subheadline)
                            // Добавьте другие поля суда, если необходимо
                    }
                    .onTapGesture {
                            selectedCourt = court
                        }
                }
                
                
                .onAppear {
                    // Загрузите данные из файла smallMoscow.json
                    if let url = Bundle.main.url(forResource: "smallMoscow", withExtension: "json"),
                       let data = try? Data(contentsOf: url) {
                        do {
                            // Распарсите JSON-данные и заполните массив courts
                            courts = try JSONDecoder().decode([Court].self, from: data)
                        } catch {
                            print("Ошибка при чтении файла: \(error)")
                        }
                    }
                }
            }
                .tabItem {
                    Label("База судов с полигонами", systemImage: "star")
                }
        }
        .padding()
        
       
    
    }
    
    
}

// Функция для поиска вхождения координат в полигон, где вход point - координаты, polygon - полигон
func convertPolygonFormat(polygonString: String) -> [CGPoint]? {
    // Удаляем квадратные скобки и разделяем строку по запятым и закрывающей скобке
    let points = polygonString
        .replacingOccurrences(of: "[[", with: "")
        .replacingOccurrences(of: "]]", with: "")
        .components(separatedBy: "],[")

    var polygonPoints: [CGPoint] = []

    for pointString in points {
        // Разделяем строку координат по запятой
        let coordinates = pointString
            .replacingOccurrences(of: "[", with: "")
            .replacingOccurrences(of: "]", with: "")
            .components(separatedBy: ",")

        // Преобразуем строки координат в числа
        if let x = Double(coordinates[0]), let y = Double(coordinates[1]) {
            let point = CGPoint(x: x, y: y)
            polygonPoints.append(point)
        }
    }

    return polygonPoints.isEmpty ? nil : polygonPoints
}

func pointInsidePolygon(_ point: CLLocationCoordinate2D, polygonCoordinates: [[CLLocationCoordinate2D]]) -> Bool {
    if polygonCoordinates.isEmpty {
        return false
    }
    
    let polygon = MKPolygon(coordinates: polygonCoordinates[0], count: polygonCoordinates[0].count)
    let pointInPolygon = MKMapPoint(point)
    let polygonRenderer = MKPolygonRenderer(polygon: polygon)
    let mapPoint = pointInPolygon
    let polygonViewPoint = polygonRenderer.point(for: mapPoint)
    return polygonRenderer.path.contains(polygonViewPoint)
    
    
}



// преобразование строки polygonPoints в формате JSON в массив координат CLLocationCoordinate2D
public func convertStringToCoordinates(_ polygonPoints: String) -> [CLLocationCoordinate2D] {
      let jsonDecoder = JSONDecoder()
      if let data = polygonPoints.data(using: .utf8),
         let coordinatesArray = try? jsonDecoder.decode([[[Double]]].self, from: data) {
          var coordinates: [CLLocationCoordinate2D] = []
          for coordinateArray in coordinatesArray {
              for coordinate in coordinateArray {
                  if coordinate.count >= 2 {
                      let latitude = coordinate[0]
                      let longitude = coordinate[1]
                      let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                      coordinates.append(coordinate)
                  }
              }
          }
          print("000-000")
          print(coordinates)
          print("000-111")
          return coordinates
          
      }
      return []
  }


// Перебрать суды и найти в полигон какого суда входит точка
func findCourtForCoordinates(courts: [Court], pointX: Double, pointY: Double) -> String? {
    let point = CLLocationCoordinate2D(latitude: pointX, longitude: pointY)
    
    for court in courts {
        let polygonsString = court.polygons
        if !polygonsString.isEmpty {
            let polygonCoordinates = convertStringToCoordinates(polygonsString)
            print("Court: \(court.name)")
            print("Polygon Coordinates: \(polygonCoordinates)")
            let isInsidePolygon = pointInsidePolygon(point, polygonCoordinates: [polygonCoordinates])
            
            if isInsidePolygon {
                return court.name
            }
        }
    }
    
    return nil
}

// Нарисовать все полигоны из базы судов
func drawPolygonsOnMap(_ mapView: MKMapView, courts: [Court]) {
    for court in courts {
        let polygonsString = court.polygons
        if !polygonsString.isEmpty {
            let polygonCoordinates = convertStringToCoordinates(polygonsString)
            let polygonOverlay = MKPolygon(coordinates: polygonCoordinates, count: polygonCoordinates.count)
            mapView.addOverlay(polygonOverlay)
        }
    }
}





// функция для экранирования символов - нельзя просто русские буквы отправлять в интернет)))

func encodeCourtName(_ WantCourtSearch: String) -> String {
    // Создание набора символов, которые не нужно экранировать
    let allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~ ")
    // Экранирование русских букв и символов, которые не входят в allowedCharacterSet
    if let encodedString = WantCourtSearch.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet.inverted) {
        return encodedString
    } else {
        return WantCourtSearch
    }
}

func parseAddressAndCoordinates(input: String) -> (address: String?, coordinates: String?) {
    // Регулярное выражение для поиска координат
    let coordinatesPattern = "\\s*(-?\\d+(\\.\\d+)?),\\s*(-?\\d+(\\.\\d+)?)" // 55.778036, 37.632143
    let coordinatesRegex = try? NSRegularExpression(pattern: coordinatesPattern, options: [])

    // Поиск координат во входной строке
    var coordinates: String?
    if let match = coordinatesRegex?.firstMatch(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count)) {
        coordinates = (input as NSString).substring(with: match.range)
    }

    // Удаление найденных координат из входной строки и использование оставшейся части в качестве адреса
    var address: String? = input
    if let coordinates = coordinates {
        address = input.replacingOccurrences(of: coordinates, with: "").trimmingCharacters(in: .whitespaces)
    }

    return (address: address, coordinates: coordinates)
}
