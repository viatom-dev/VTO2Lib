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
