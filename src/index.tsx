import type { Frame } from 'react-native-vision-camera';


export function frameToBase64(frame: Frame,options: {width:number;height:number;quality:number}={width:500,height:500,quality:100}): string {
  'worklet';
  // @ts-ignore
  return __frameToBase64(frame,options);
}