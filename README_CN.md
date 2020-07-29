[TOC]

#### 1. VTO2Lib
* ##### 1.1 版本变更日志
    ##### [变更日志](https://github.com/viatom-dev/VTO2Lib/blob/master/ChangeLog.md)
* ##### 1.2 功能描述
   VTO2Lib是为源动健康O2系列产品开发的iOS版本的SDK。主要功能大致分为通信和解析两部分。
   &nbsp;&nbsp; 1. 通信功能。 用于使用Bluetooth的iOS设备与作为外设的O2进行通信。 主要功能分为读取设备信息，下载数据，同步设备参数，恢复出厂和读取实时数据。
   &nbsp;&nbsp; 2. 解析功能。 用于解析通信获取后的各类数据，并返回相应的模型供其他开发者使用。

#### 2. 环境
   &nbsp;&nbsp;&nbsp; iOS 8.0及以上

#### 3. 快速使用
首先，配置`VTO2Communicate`的属性`peripheral`，sdk会进行服务和特征配置，如果回调方法`serviceDeployed:`返回YES，即可以正常通信。
然后，在需要接收返回的地方设置`VTO2Communicate`的`delegate`，即可以正常接收各类请求回调。


- 读取O2相关的信息, 其中包含了可读取的文件列表
```
- (void)beginGetInfo;
```

- 同步O2信息中包含的参数，参数种类根据设备类型动态变化
```
- (void)beginToParamType:(VTParamType)paramType content:(NSString *)paramValue;
```

- 恢复出厂设置，所有参数恢复默认，并移除文件列表
```
- (void)beginFactory;
```

- 读取O2上的文件
```
- (void)beginReadFileWithFileName:(NSString *)fileName;
```

- 监听当前外设的RSSI值
```
- (void)readRSSI;
```

- 获取实时的原始PPG
```objective-c
- (void)beginGetRealPPG;
```

- O2信息参考 `VTO2Lib/VTO2Info.h>`
- O2文件参考 `<VTO2Lib/VTO2Object.h>`
- O2文件中包含的波形参考 `<VTO2Lib/VTO2WaveObject.h>`
- O2实时数据/PPG参考 `<VTO2Lib/VTRealObject.h>`
- O2原始数据解析器参考 `<VTO2Lib/VTO2Parser.h>`

