import UIKit

extension UIImage {

  /// Returns a image that fills in newSize
  func resizedImage(newSize: CGSize) -> UIImage {
    // Guard newSize is different
    guard self.size != newSize else { return self }

    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    self.draw(in: CGRectMake(0, 0, newSize.width, newSize.height))
    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
  }

  /// Returns a resized image that fits in rectSize, keeping it's aspect ratio
  /// Note that the new image size is not rectSize, but within it.
  func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
    let widthFactor = size.width / rectSize.width
    let heightFactor = size.height / rectSize.height

    var resizeFactor = widthFactor
    if size.height > size.width {
      resizeFactor = heightFactor
    }

    let newSize = CGSizeMake(size.width / resizeFactor, size.height / resizeFactor)
    let resized = resizedImage(newSize: newSize)
    return resized
  }

}
