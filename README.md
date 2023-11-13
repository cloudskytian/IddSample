# What Is This #

This project is based on [Microsoft Indirect Display Driver Sample](https://github.com/Microsoft/Windows-driver-samples/tree/main/video/IndirectDisplay).
I add a registry support for it to use `HKEY_CURRENT_USER\SOFTWARE\IddSampleDriver` custom display resolution and refresh rate.

# How To Use #
First, run `IddSampleInstallCer.bat` to install the signature, then run` IddSampleInstallDriver.bat` to install the driver. There is a default config that use 1920*1080 60Hz in `IddSampleInstallDriver.bat`, and you can edit it yourself.
Just run `IddSampleApp.exe` when you need to start the virtual display.

# 这是个什么东西？ #
该项目基于[微软 Indirect Display 驱动示例](https://github.com/Microsoft/Windows-driver-samples/tree/main/video/IndirectDisplay)。
我给他加了个通过 `HKEY_CURRENT_USER\SOFTWARE\IddSampleDriver` 注册表来自定义分辨率和刷新率的功能。

# 咋用 #
先运行 `IddSampleInstallCer.bat` 装一下签名，再运行 `IddSampleInstallDriver.bat` 安装驱动。`IddSampleInstallDriver.bat` 文件中有一个 1920*1080 60Hz 的默认配置，你可以手动修改它。
当你需要启动虚拟显示器时只需要运行 `IddSampleApp.exe` 即可。

---

# Indirect Display Driver Sample #

This is a sample driver that shows how to create a Windows Indirect Display Driver using IddCx (Indirect Display Driver Class eXtension).

## Background reading ##

Start at the [Indirect Display Driver Model Overview](https://msdn.microsoft.com/en-us/library/windows/hardware/mt761968(v=vs.85).aspx) on MSDN.

## Customizing the sample ##

The sample driver code is very simplistic and does nothing more than enumerate a single monitor when its device enters the D0/started power state. Throughout the code, there are `TODO` blocks with important information on implementing functionality in a production driver.

### Code structure ###

* `Direct3DDevice` class
    * Contains logic for enumerating the correct render GPU from DXGI and creating a D3D device.
    * Manages the lifetime of a DXGI factory and a D3D device created for the render GPU the system is using to render frames for your indirect display device's swap-chain.
* `SwapChainProcessor` class
    * Processes frames for a swap-chain assigned to the monitor object on a dedicated thread.
    * The sample code does nothing with the frames, but demonstrates a correct processing loop with error handling and notifying the OS of frame completion.
* `IndirectDeviceContext` class
    * Processes device callbacks from IddCx.
    * Manages the creation and arrival of the sample monitor.
    * Handles swap-chain arrival and departure by creating a `Direct3DDevice` and handing it off to a `SwapChainProcessor`.

### First steps ###

Consider the capabilities of your device. If the device supports multiple monitors being hotplugged and removed at runtime, you may want to abstract the monitors further from the `IndirectDeviceContext` class.

The INF file included in the sample needs updating for production use. One field, `DeviceGroupId`, controls how the UMDF driver gets pooled with other UMDF drivers in the same process. Since indirect display drivers tend to be more complicated than other driver classes, it's highly recommended that you pick a unique string for this field which will cause instances of your device driver to pool in a dedicated process. This will improve system reliability in case your driver encounters a problem since other drivers will not be affected.

Ensure the device information reported to `IddCxAdapterInitAsync` is accurate. This information determines how the device is reported to the OS and what static features (like support for gamma tables) the device will have available. If some information cannot be known immediately in the `EvtDeviceD0Entry` callback, IddCx allows the driver to call `IddCxAdapterInitAsync` at any point after D0 entry, before D0 exit.

Careful attention should be paid to the frame processing loop. This will directly impact the performance of the user's system, so making use of the [Multimedia Class Scheduler Service](https://msdn.microsoft.com/en-us/library/windows/desktop/ms684247(v=vs.85).aspx) and DXGI's support for [GPU prioritization](https://msdn.microsoft.com/en-us/library/windows/desktop/bb174534(v=vs.85).aspx) should be considered. Any significant work should be performed outside the main processing loop, such as by queuing work in a thread pool. See `SwapChainProcessor::RunCore` for more information.