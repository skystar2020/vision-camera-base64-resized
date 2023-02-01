package com.visioncamerabase64;

import android.annotation.SuppressLint;
import android.graphics.Bitmap;
import android.util.Base64;
import androidx.camera.core.ImageProxy;
import com.mrousavy.camera.frameprocessor.FrameProcessorPlugin;
import java.io.ByteArrayOutputStream;

public class VisionCameraBase64Plugin extends FrameProcessorPlugin {

  @Override
  public Object callback(ImageProxy image, Object[] params) {
    int quality = 100;
    int width = 640;
    int height = 480;
    Bitmap.CompressFormat imageFormat = Bitmap.CompressFormat.JPEG;
    
    ReadableNativeMap config = getConfig(params);
    if(config.hasKey("quality")){
      quality = config.getInt("quality");
    }
    if(config.hasKey("width")){
      width = config.getInt("width");
    }
    if(config.hasKey("height")){
      width = config.getInt("height");
    }
    if(config.hasKey("format")){
      imageFormat = (config.getString("format")=="png" ? Bitmap.CompressFormat.PNG: Bitmap.CompressFormat.JPEG);
    }

    @SuppressLint("UnsafeOptInUsageError")
    Bitmap bitmap = BitmapUtils.getBitmap(image);
    Bitmap resizedBmp = Bitmap.createScaledBitmap(bitmap, width, height, false);
    return bitmapToBase64(resizedBmp, imageFormat, quality);
  }

  /** Converts a bitmap to base64 format string */
  public static String bitmapToBase64(Bitmap bitmap, Bitmap.CompressFormat format, int quality) {
    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
    bitmap.compress(format, quality, outputStream);

    return Base64.encodeToString(outputStream.toByteArray(), Base64.DEFAULT);
  }

  VisionCameraBase64Plugin() {
    super("frameToBase64");
  }
}
