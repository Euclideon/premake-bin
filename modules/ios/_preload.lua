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

	local archMap = {
		x86 = "-arch i386",
		x86_64 = "-arch x86_64",
		armv7 = "-arch armv7",
		arm64 = "-arch arm64",
	}

	local function mapArchs(cfg, arch, orig)
		if cfg.system == p.IOS then
			return archMap[arch]
		elseif type(orig[arch]) == "function" then
			return orig[arch](cfg)
		else
			return orig[arch]
		end
	end

	local origArch = premake.tools.clang.shared.architecture
	premake.tools.clang.shared.architecture = {
		x86 = function(cfg) return mapArchs(cfg, "x86", origArch) end,
		x86_64 = function(cfg) return mapArchs(cfg, "x86_64", origArch) end,
		armv7 = function(cfg) return mapArchs(cfg, "armv7", origArch) end,
		arm64 = function(cfg) return mapArchs(cfg, "arm64", origArch) end,
	}

	local origArch = premake.tools.clang.ldflags.architecture
	premake.tools.clang.ldflags.architecture = {
		x86 = function(cfg) return mapArchs(cfg, "x86", origArch) end,
		x86_64 = function(cfg) return mapArchs(cfg, "x86_64", origArch) end,
		armv7 = function(cfg) return mapArchs(cfg, "armv7", origArch) end,
		arm64 = function(cfg) return mapArchs(cfg, "arm64", origArch) end,
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
		
	filter { "system:ios", "action:gmake*" }
		buildoptions {
			"-miphoneos-version-min=%{iif(cfg.systemversion, cfg.systemversion, '10.3')}",
		}
		linkoptions {
			"-miphoneos-version-min=%{iif(cfg.systemversion, cfg.systemversion, '10.3')}",
		}
	
	filter { "system:ios", "action:gmake*", "architecture:armv7 or arm64" }
		buildoptions {
			"-isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk",
		}
		linkoptions {
			"-isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk",
		}
		
	filter { "system:ios", "action:gmake*", "architecture:x86 or x64" }
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
