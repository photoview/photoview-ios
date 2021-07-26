//
//  PlacesImageAnnotationView.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 26/07/2021.
//

import UIKit
import MapKit

class PlacesImageAnnotationView: MKAnnotationView {
  
  private var imageTask: URLSessionTask? = nil
  
  private let imageInset: CGFloat = 4
  private let arrowSize: CGFloat = 10
  private let contentInsets = UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10)
  
  private let blurEffect = UIBlurEffect(style: .systemThickMaterial)
  
  private lazy var backgroundMaterial: UIVisualEffectView = {
    let view = UIVisualEffectView(effect: blurEffect)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView(image: nil)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()
  
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    self.clusteringIdentifier = "PlacesImage"
    
    backgroundColor = UIColor.clear
    addSubview(backgroundMaterial)
    
    backgroundMaterial.contentView.addSubview(imageView)
    
    // Make the background material the size of the annotation view container
    backgroundMaterial.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    backgroundMaterial.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    backgroundMaterial.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    backgroundMaterial.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    
    imageView.leadingAnchor.constraint(equalTo: backgroundMaterial.leadingAnchor, constant: imageInset).isActive = true
    imageView.topAnchor.constraint(equalTo: backgroundMaterial.topAnchor, constant: imageInset).isActive = true
    imageView.trailingAnchor.constraint(equalTo: backgroundMaterial.trailingAnchor, constant: -imageInset).isActive = true
    imageView.bottomAnchor.constraint(equalTo: backgroundMaterial.bottomAnchor, constant: -10 - imageInset).isActive = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
    self.clusteringIdentifier = "PlacesImage"
    
    imageTask?.cancel()
  }
  
  override func prepareForDisplay() {
    super.prepareForDisplay()
    
    let annotation = annotation as! PlacesImageAnnotation
    
    self.imageTask = ProtectedImageCache.shared.fetchImage(url: annotation.marker.properties.thumbnail.url) { image in
      self.imageView.image = image
    }
    
    // Since the image and text sizes may have changed, require the system do a layout pass to update the size of the subviews.
    setNeedsLayout()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    // Use the intrinsic content size to inform the size of the annotation view with all of the subviews.
    let contentSize = intrinsicContentSize
    frame.size = intrinsicContentSize
    
    // The annotation view's center is at the annotation's coordinate. For this annotation view, offset the center so that the
    // drawn arrow point is the annotation's coordinate.
    centerOffset = CGPoint(x: 0, y: -contentSize.height / 2)
    
    let shape = CAShapeLayer()
    let path = CGMutablePath()
    
    // Draw the pointed shape.
    let pointShape = UIBezierPath()
    
    pointShape.move(to: CGPoint(x: self.frame.size.width / 2 + arrowSize, y: self.frame.size.height - arrowSize))
    pointShape.addLine(to: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height))
    pointShape.addLine(to: CGPoint(x: self.frame.size.width / 2 - arrowSize, y: self.frame.size.height - arrowSize))
    path.addPath(pointShape.cgPath)
    
    // Draw the rounded box.
    let box = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height - arrowSize)
    let roundedRect = UIBezierPath(roundedRect: box,
                                   byRoundingCorners: .allCorners,
                                   cornerRadii: CGSize(width: 5, height: 5))
    path.addPath(roundedRect.cgPath)
    
    shape.path = path
    backgroundMaterial.layer.mask = shape
    
    // Rounded rectangle mask for image view
    let imageShape = CAShapeLayer()
    let imagePath = CGMutablePath()
    
    let imageBox = CGRect(x: 0, y: 0, width: self.frame.size.width - 8, height: self.frame.size.height - arrowSize - 8)
    let imageRoundedRect = UIBezierPath(roundedRect: imageBox,
                                   byRoundingCorners: .allCorners,
                                   cornerRadii: CGSize(width: 3, height: 3))
    
    imagePath.addPath(imageRoundedRect.cgPath)
    imageShape.path = imagePath
    
    imageView.layer.mask = imageShape
    
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOpacity = 0.15
    self.layer.shadowOffset = CGSize(width: 0, height: 2)
    self.layer.shadowRadius = 4
  }
  
  override var intrinsicContentSize: CGSize {
    var size = CGSize(width: 50, height: 50)
    size.width += contentInsets.left + contentInsets.right
    size.height += contentInsets.top + contentInsets.bottom
    return size
  }
}
