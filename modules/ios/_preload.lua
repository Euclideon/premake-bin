--
-- Name:        ios/_preload.lua
-- Purpose:     Define the iOS API's.
-- Author:      Samuel Surtees
--

	local p = premake
	local api = p.api

--
-- Register the iOS extension
--

	p.IOS = "ios"

	api.addAllowed("system", { p.IOS })
	api.addAllowed("architecture", { "armv7", "arm64" })

	local origArch = premake.tools.clang.cflags.architecture -- Will need to change "cflags" to "shared" eventually.
	premake.tools.clang.cflags.architecture = {
		x86 = function(cfg) return iif(cfg.system == p.IOS, "-arch i386", origArch.x86) end,
		x86_64 = function(cfg) return iif(cfg.system == p.IOS, "-arch x86_64", origArch.x86_64) end,
		armv7 = function(cfg) return iif(cfg.system == p.IOS, "-arch armv7", "") end,
		arm64 = function(cfg) return iif(cfg.system == p.IOS, "-arch arm64", "") end,
	}
	
	local origArch = premake.tools.clang.ldflags.architecture
	premake.tools.clang.ldflags.architecture = {
		x86 = function(cfg) return iif(cfg.system == p.IOS, "-arch i386", origArch.x86) end,
		x86_64 = function(cfg) return iif(cfg.system == p.IOS, "-arch x86_64", origArch.x86_64) end,
		armv7 = function(cfg) return iif(cfg.system == p.IOS, "-arch armv7", "") end,
		arm64 = function(cfg) return iif(cfg.system == p.IOS, "-arch arm64", "") end,
	}

--
-- Set global environment for the default iOS platform.
--

	filter { "platforms:armv7" }
		architecture "armv7"
		
	filter { "platforms:arm64" }
		architecture "arm64"

	filter { "system:ios" }
		toolset "clang"
		
	filter { "system:ios", "action:gmake" }
		buildoptions {
			"-miphoneos-version-min=%{iif(cfg.systemversion, cfg.systemversion, '10.3')}",
		}
		linkoptions {
			"-miphoneos-version-min=%{iif(cfg.systemversion, cfg.systemversion, '10.3')}",
		}
	
	filter { "system:ios", "action:gmake", "architecture:armv7 or arm64" }
		buildoptions {
			"-isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk",
		}
		linkoptions {
			"-isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk",
		}
		
	filter { "system:ios", "action:gmake", "architecture:x86 or x64" }
		buildoptions {
			"-isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk",
		}
		linkoptions {
			"-isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk",
		}

--
-- Decide when the full module should be loaded.
--

	return function(cfg)
		return cfg.system == p.IOS
	end
