# test-map-polygon-macos
 Test of the program for finding occurrences of coordinates in polygons on swiftui for macos.

**Тест вхождения координат в полигоны** для macOS, написанная на SwiftUI, демонстрирующая работу с mapkit (наложение на карту полигонов, динамическое перемещение и изменения маштаба карты при отображении полигона), алгортим поиска вхождения координат в полигон. Демонстрация производится на базе судов г. Москвы (полигоны имеются у судебных участках мировых судей г. Москвы), база доступна в проекте в формате JSON, актуальность базы – 2022 год. Обновленные данные доступны на allcourts.ru. 

Функции из данного тестового проекта доступны в проекте для юристов «ЮристГоспошлина для macOS» и в «LawMatic B2 для macOS». 

Проект реализует возможность пользователю найти суд по адресу ответчика (территориальная подсудность). В демоверсии находится база только судов Москвы и по состоянию на 2022 год.  

В JSON базы судов с полигонами данные о полигонах хранятся так:
```
"[[[55.9965389912,37.2119915485],[55.984759145,37.2248339653],[55.9953659683,37.2312766314],[55.9965389912,37.2119915485]]]".
```

В SwiftUI работа с этими данными ведется в формате CLLocationCoordinate2D:
```
[
        [CLLocationCoordinate2D(latitude: 55.9965389912, longitude: 37.2119915485),
         CLLocationCoordinate2D(latitude: 55.984759145, longitude: 37.2248339653),
         CLLocationCoordinate2D(latitude: 55.9953659683, longitude: 37.2312766314),
         CLLocationCoordinate2D(latitude: 55.9965389912, longitude: 37.2119915485)]
 ]
 ```
<img src="https://github.com/SergeiKriukov/test-map-polygon-macos/blob/main/screenshots/screenshot-test-polygon-3.png">
<img src="https://github.com/SergeiKriukov/test-map-polygon-macos/blob/main/screenshots/screenshot-test-polygon-2.png">
<img src="https://github.com/SergeiKriukov/test-map-polygon-macos/blob/main/screenshots/screenshot-test-polygon-1.png">

