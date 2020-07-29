#### 1. VTO2Lib - Viatom O2 SERIES iOS lib

* ##### 1.1 Changelog

    ##### [Changelog](https://github.com/viatom-dev/VTO2Lib/blob/master/ChangeLog.md)

* ##### 1.2 Functions

VTO2Lib is iOS lib for Viatom O2 SERIES. There are two part in this lib: Communicate function and Data analysis function.

   1. Communicate function. Using this function, you can connect and download data from O2, and get real-time data from O2.
   2. Data analysis function. Get measurements values form the files downloaded.

#### 2. Environment

iOS 8.0 or later.

#### 3. Quick Start
1. Config the `peripheral` property of `VTO2Communicate`.If the callback method
that `serviceDeployed:` returns YES,  NECESSAYR!

2. Set `delegate` for `VTO2Communicate` any where you want get callback. At this step, you are able to communicate.

- get O2 info.    Note: the list of all files from O2 information

```objective-c
- (void)beginGetInfo;
```

- sync parameters
```objective-c
- (void)beginToParamType:(VTParamType)paramType content:(NSString *)paramValue;
```

- restore factory
```objective-c
- (void)beginFactory;
```

- read file from the peripheral 
```objective-c
- (void)beginReadFileWithFileName:(NSString *)fileName;
```
- monitor peripheral RSSI
```objective-c
- (void)readRSSI;
```
- get real ppg data from the peripheral
```objective-c
- (void)beginGetRealPPG;
```

- information object `VTO2Lib/VTO2Info.h>`
- O2 file object `<VTO2Lib/VTO2Object.h>`
- O2 wave object `<VTO2Lib/VTO2WaveObject.h>`
- O2 real-time or real-ppg object `<VTO2Lib/VTRealObject.h>`
- oringinal data parser `<VTO2Lib/VTO2Parser.h>`


