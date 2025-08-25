# VTO2Lib

1. Set the `peripheral` property of `VTO2Communicate`. If the callback method that `serviceDeployed:` returns YES,  NECESSAYR!

2. Set `delegate` for `VTO2Communicate` any where you want get callback.  At this step, you are able to communicate. Parse response by Class VTO2Parser 

- Notify peripheral RSSI.
    > Send: `readRSSI` 
    >
    > Resp: `updatePeripheralRSSI:`

- Get information, it includes file's list.
    > Send: `beginGetInfo`
    >
    > Resp: `getInfoWithResultData:`
    >
    > Parse: `parseO2InfoWithData:`
    
- Get BabyO2 S2 Station information.
    > Send: `beginGetStationInfo` 
    > 
    > Resp: `getStationInfoWithData:`
    > 
    > Parse: `parseStationInfoWithData:`

- Get real-time data. 
    > Send: `beginGetRealData`
    >
    > Resp: `realDataCallBackWithData:` & `realDataCallBackWithData:originalData:`
    >
    > Parse: `parseO2RealObjectWithData:`

- Restore factory.
    > Send: `beginFactory`
    >
    > Resp: `commonResponse: andResult:`

- Get real-time waveform.
    > Send: `beginGetRealWave`
    >
    > Resp: `realWaveCallBackWithData:` & `realWaveCallBackWithData:originalData:`
    >
    > Parse: `parseO2RealWaveWithData:`
    
- Get real-time PPG. 
    > Send: `beginGetRealPPG`
    >
    > Resp: `realPPGCallBackWithData:`
    >
    > Parse: `parseO2RealPPGWithData:`

- Sync params. your can known your device support param types by protocol documents.  
    > Send: `beginToParamType:content:`
    >
    > Resp: `commonResponse: andResult:`

- Read file.
    > Send: `beginReadFileWithFileName:`
    >
    > Resp:   progress - `postCurrentReadProgress:` &  result - `readCompleteWithData:`
    >
    > Parse: `parseO2ObjectWithData:`

##### Note: parameters description.

* VTParamTypeDate,
* `VTParamTypeOxiThr` :  [80, 95] 
* `VTParamTypeMotor`: 
  - Kids02 & Oxylink:  (0-5: MIN;  5-10 : LOW; 10-17 : MID;  17-22 : HIGH ; 22-35 : MAX) 
  - O2Ring : (0-20 : MIN ; 20-40 : LOW ; 40-60 : MID;  60-80 : HIGH ;  80-100 : MAX) 
* `VTParamTypeLightingMode`: 0-Standard, 1-Always off, 2-Always on.
* `VTParamTypeHeartRateSwitch`: 0-off, 1-on
* `VTParamTypeHeartRateLowThr`:
	- O2Ring&Oxylink:  30~70 (step: +5)
	- Others       40~70 (step: +5)
* `VTParamTypeHeartRateHighThr`:
	- O2Ring&Oxylink: 70~200 (step: +5)
	- Oxyfit: 100~200 (step:+10)
	- Others: 90-200 (step: +5)
* `VTParamTypeLightStrength`: 0-Low, 1-Medium, 2-High
* `VTParamTypeOxiSwitch`: 0-off, 1-on
* `VTParamTypeBuzzer`: (0-20 : MIN ; 20-40 : LOW ; 40-60 : MID;  60-80 : HIGH ;  80-100 : MAX) 
* `VTParamTypeMtSw`: 0-off, 1-on
* `VTParamTypeMtThr`: 0~255
* `VTParamTypeIvSw`: 0-off, 1-on
* `VTParamTypeIvThr`: [30, 300]
* `VTParamTypeSpO2Sw`: 0-off, 1-on

