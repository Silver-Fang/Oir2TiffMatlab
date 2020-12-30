# Oir2TiffMatlab

批量转换Oir到Tiff格式的MATLAB项目

将Olympus显微镜拍摄的Oir图像转换为更通用的Tiff格式，大批量，并行快速。相比于其自带转换程序，速度更快，Z stacks自动分层，且支持超过4㎇的超大文件

本工具将Olympus系列显微镜拍摄的Oir格式图像转换成更通用可读的Tiff格式。虽然Olympus也提供了转码程序，但性能低下，且不能转码超过4㎇的大文件，十分不方便使用。本工具克服了这个问题，提供并行转码支持，性能更高，且无文件大小限制。

如果你的内存不足，请在Parallel Preferences中手动降低并行池的尺寸。降低并行数可以有效减少内存占用，但也会显著增加时间消耗。如果你的内存不足以支持多线程，也可以使用单线程模式的Oir2TiffSingle。

首次启动可能会报错，因为本程序需要添加静态Java路径。但是添加过程是自动的，添加后重启MATLAB即可。
