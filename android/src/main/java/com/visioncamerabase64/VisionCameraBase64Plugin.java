package com.visioncamerabase64;

import android.annotation.SuppressLint;
import android.graphics.Bitmap;
import android.util.Base64;
import androidx.camera.core.ImageProxy;
import com.mrousavy.camera.frameprocessor.FrameProcessorPlugin;
import com.facebook.react.bridge.ReadableNativeMap;
import java.io.ByteArrayOutputStream;

public class VisionCameraBase64Plugin extends FrameProcessorPlugin {

  @Override
  public Object callback(ImageProxy image, Object[] params) {

    ReadableNativeMap config = getConfig(params);

    Bitmap.CompressFormat imageFormat = Bitmap.CompressFormat.PNG;
    int quality = 100;
    int width = 200;
    int height = 200;
    Boolean keepAspectRatio = true;
    if (config.hasKey("quality")) {
      quality = config.getInt("quality");
    }
    if (config.hasKey("width")) {
      width = config.getInt("width");
    }
    if (config.hasKey("height")) {
      height = config.getInt("height");
    }
    if (config.hasKey("keepAspectRatio")) {
      keepAspectRatio = config.getBoolean("keepAspectRatio");
    }
    if (config.hasKey("format")) {
      imageFormat = (config.getString("format") == "png" ? Bitmap.CompressFormat.PNG : Bitmap.CompressFormat.JPEG);
    }

    @SuppressLint("UnsafeOptInUsageError")
    Bitmap bitmap = BitmapUtils.getBitmap(image);
    Bitmap resized = BitmapUtils.resize(bitmap, keepAspectRatio,width, height,quality);
    return bitmapToBase64(resized, imageFormat ,100);
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

  private ReadableNativeMap getConfig(Object[] params) {
    if (params.length > 0) {
      if (params[0] instanceof ReadableNativeMap) {
        ReadableNativeMap config = (ReadableNativeMap) params[0];
        return config;
      }
    }
    return null;
  }
}
