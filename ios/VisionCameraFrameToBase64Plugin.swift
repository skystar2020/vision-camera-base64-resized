import Foundation

@objc(VisionCameraFrameToBase64Plugin)
public class VisionCameraFrameToBase64Plugin: NSObject, FrameProcessorPluginBase {
  private static let context = CIContext(options: nil)
  @objc
  public static func callback(_ frame: Frame!, withArgs args: [Any]!) -> Any! {
    let config = getConfig(withArgs: args)
    // if let options = args[0] as? NSDictionary {
    let width = (config?["width"] ?? 300) as Int
    let height = (config?["height"] ?? 300) as Int
    let quality = (config?["quality"] ?? 100) as Int
    let keepAspectRatio = (config?["keepAspectRatio"] ?? 1) as Int
    let targetSize = CGSize(width: width, height: height)
    let q: CGFloat = CGFloat(quality)
    guard let imageBuffer = CMSampleBufferGetImageBuffer(frame.buffer) else {
      print("Failed to get CVPixelBuffer!")
      return nil
    }
    let ciImage = CIImage(cvPixelBuffer: imageBuffer)

    guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
      print("Failed to create CGImage!")
      return nil
    }
    let image = UIImage(cgImage: cgImage)

    let resizedImg = image.resizeTo(keepAspectRatio: keepAspectRatio, rectSize: targetSize)

    let imageData = resizedImg.jpegData(compressionQuality: q)

    return imageData?.base64EncodedString() ?? ""

  }
  static func getConfig(withArgs args: [Any]!) -> [String: Int]! {
    if args.count > 0 {
      let config = args[0] as? [String: Int]
      return config
    }
    return nil
  }
  // static func resizeImage(image: UIImage, newWidth: CGFloat, newHeight: CGFloat) -> UIImage {
  //   let targetSize = CGSize(width: newWidth, height: newHeight)

  //   // Compute the scaling ratio for the width and height separately
  //   let widthScaleRatio = targetSize.width / image.size.width
  //   let heightScaleRatio = targetSize.height / image.size.height

  //   // To keep the aspect ratio, scale by the smaller scaling ratio
  //   let scaleFactor = min(widthScaleRatio, heightScaleRatio)

  //   // Multiply the original image’s dimensions by the scale factor
  //   // to determine the scaled image size that preserves aspect ratio
  //   let scaledImageSize = CGSize(
  //     width: image.size.width * scaleFactor,
  //     height: image.size.height * scaleFactor
  //   )
  //   let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
  //   let scaledImage = renderer.image { _ in
  //     image.draw(in: CGRect(origin: .zero, size: scaledImageSize))
  //   }
  //   return scaledImage
  //   // let scale = newWidth / image.size.width
  //   // let newHeight = image.size.height * scale
  //   // UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
  //   // image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
  //   // let newImage = UIGraphicsGetImageFromCurrentImageContext()
  //   // UIGraphicsEndImageContext()

  //   // return newImage
  // }
}
