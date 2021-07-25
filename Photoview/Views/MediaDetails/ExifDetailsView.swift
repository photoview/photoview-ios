//
//  ExifDetailsView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 25/07/2021.
//

import SwiftUI

struct ExifDetailsView: View {
  
  struct ExifValue {
    let label: String
    let value: String
  }
  
  let exif: MediaDetailsQuery.Data.Medium.Exif
  
  var values: [ExifValue] {
    var result: [ExifValue] = []
    
    if let camera = exif.camera { result.append(ExifValue(label: "Camera", value: camera)) }
    if let maker = exif.maker { result.append(ExifValue(label: "Maker", value: maker)) }
    if let lens = exif.lens { result.append(ExifValue(label: "Lens", value: lens)) }
    if let program = exif.exposureProgram { result.append(ExifValue(label: "Program", value: Self.exposureProgram(id: program))) }
    if let dateShot = exif.dateShot { result.append(ExifValue(label: "Lens", value: dateShot)) }
    if let exposure = exif.exposure { result.append(ExifValue(label: "Exposure", value: Self.exposureFraction(value: exposure))) }
    if let aperture = exif.aperture { result.append(ExifValue(label: "Aperture", value: Self.formatAperture(value: aperture))) }
    if let iso = exif.iso { result.append(ExifValue(label: "ISO", value: "\(iso)")) }
    if let focalLength = exif.focalLength { result.append(ExifValue(label: "Focal length", value: Self.formatFocalLength(value: focalLength))) }
    
    return result
  }
  
  static func exposureProgram(id: Int) -> String {
    switch id {
    case 0:
      return "Not defined"
    case 1:
      return "Manual"
    case 2:
      return "Normal program"
    case 3:
      return "Aperture priority"
    case 4:
      return "Shutter priority"
    case 5:
      return "Creative program"
    case 6:
      return "Action program"
    case 7:
      return "Portrait mode"
    case 8:
      return "Landscape mode"
    case 9:
      return "Bulb"
    default:
      return "Unknown"
    }
  }
  
  static func exposureFraction(value: Double) -> String {
    "1/\(Int((1 / value).rounded()))"
  }
  
  static func formatAperture(value: Double) -> String {
    "f/\(value)"
  }
  
  static func formatFocalLength(value: Double) -> String {
    "\(value) mm"
  }
  
  var body: some View {
    HStack {
      VStack(alignment: .trailing) {
        ForEach(values, id: \.label) { value in
            Text(value.label)
              .font(.caption)
              .foregroundColor(.secondary)
              .frame(height: 20)
        }
      }
      VStack(alignment: .leading) {
        ForEach(values, id: \.label) { value in
            Text(value.value)
              .frame(height: 20)
        }
      }
    }
  }
}

//struct ExifDetailsView_Previews: PreviewProvider {
//  static var previews: some View {
//    ExifDetailsView()
//  }
//}
