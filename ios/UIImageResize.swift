import UIKit
extension UIImage {
  func resizeTo(keepAspectRatio: Int, rectSize: CGSize) -> UIImage {
    if keepAspectRatio > 0 {
      return resizeImageA(rectSize: rectSize)
    }
    return resizeImageB(rectSize: rectSize)
  }
  func resizeImageA(rectSize: CGSize) -> UIImage {
    var maxSize: Double = 0
    if rectSize.width > rectSize.height {
      maxSize = rectSize.width
    } else {
      maxSize = rectSize.height
    }
    var outWidth = rectSize.width
    var outHeight = rectSize.height
    let inWidth = size.width
    let inHeight = size.height

    if inWidth > inHeight {  //when the orginal width is bigger than orginal height (wide image)
      outWidth = maxSize
      outHeight = (inHeight * maxSize) / inWidth
    } else {  //vertical image
      outHeight = maxSize
      outWidth = (inWidth * maxSize) / inHeight
    }

    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    newSize = CGSize(width: outWidth, height: outHeight)
    // if widthRatio > heightRatio {
    //   newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    // } else {
    //   newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
    // }

    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(origin: .zero, size: newSize)

    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    self.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()

    return newImage
  }
  /// Returns a image that fills in newSize
  func resizeImageB(rectSize: CGSize) -> UIImage {
    // Guard rectSize is different
    guard self.size != rectSize else { return self }

    UIGraphicsBeginImageContextWithOptions(rectSize, false, 1.0)
    self.draw(in: CGRectMake(0, 0, rectSize.width, rectSize.height))
    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
  }

  /// Returns a resized image that fits in rectSize, keeping it's aspect ratio
  /// Note that the new image size is not rectSize, but within it.
  // func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
  //   let widthFactor = size.width / rectSize.width
  //   let heightFactor = size.height / rectSize.height

  //   var resizeFactor = widthFactor
  //   if size.height > size.width {
  //     resizeFactor = heightFactor
  //   }

  //   let newSize = CGSizeMake(size.width / resizeFactor, size.height / resizeFactor)
  //   let resized = resizedImage(rectSize: newSize)
  //   print(size, newSize)
  //   return resized
  // }

}
