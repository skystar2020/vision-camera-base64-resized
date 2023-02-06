import * as React from 'react';
import { Dimensions, StyleSheet, Text, View } from 'react-native';
import 'react-native-reanimated';
import { runOnJS } from 'react-native-reanimated';
import { Camera, useCameraDevices, useFrameProcessor } from 'react-native-vision-camera';
import { frameToBase64 } from 'vision-camera-base64';

const dimensions = Dimensions.get("screen");
export default function App() {
  const [hasPermission, setHasPermission] = React.useState(false);
  const devices = useCameraDevices();
  const device = devices.front ?? devices.external ?? devices.back ?? devices.unspecified;
  //const device = devices.back ?? devices.external ?? devices.front ?? devices.unspecified;
  console.log(device, devices, hasPermission);
  React.useEffect(() => {
    (async () => {
      const status = await Camera.requestCameraPermission();
      setHasPermission(status === 'authorized');
    })();
  }, []);
  const handleFrame = React.useCallback((base64Str: string) => {
    console.log(base64Str.length)

  }, [])
  const process = useFrameProcessor((frame) => {
    'worklet';

    const base64Image = frameToBase64(frame, { keepAspectRatio: true, width: 200, height: 200, quality: 30 })
    runOnJS(handleFrame)(base64Image);
  }, [])

  return device != null && hasPermission ? (
    <View style={styles.container}>
      <Camera
        style={styles.camera}
        isActive={true}
        device={device}
        frameProcessor={process}
        focusable={true}
        preset={'vga-640x480'}
        frameProcessorFps={13}
        enablePortraitEffectsMatteDelivery={true}
      />
    </View>
  ) : (
    <Text>Camera not found</Text>
  )
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#ececec',
  },
  camera: {
    width: dimensions.width,
    height: dimensions.height,
  },
});
