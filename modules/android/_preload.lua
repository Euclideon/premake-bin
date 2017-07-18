--
-- Name:        android/_preload.lua
-- Purpose:     Define the Android API's.
-- Author:      Samuel Surtees
--

	local p = premake
	local api = p.api

--
-- Register the Android extension
--

	p.ANDROID = "android"

	api.addAllowed("system", { p.ANDROID })
	api.addAllowed("architecture", { "armv7", "arm64" })
	
	api.register {
		name = "toolchainversion",
		scope = "config",
		kind = "string",
	}

	local origArch = premake.tools.gcc.cflags.architecture -- Will need to change "cflags" to "shared" eventually.
	premake.tools.gcc.cflags.architecture = {
		x86 = function(cfg) return iif(cfg.system == p.ANDROID, "-march=i686", origArch.x86) end,
		x86_64 = function(cfg) return iif(cfg.system == p.ANDROID, "-march=x86-64", origArch.x86_64) end,
		armv7 = function(cfg) return iif(cfg.system == p.ANDROID, "-march=armv7-a", "") end,
		arm64 = function(cfg) return iif(cfg.system == p.ANDROID, "-march=armv8-a", "") end,
	}
	
	local origArch = premake.tools.gcc.ldflags.architecture
	premake.tools.gcc.ldflags.architecture = {
		x86 = function(cfg) return iif(cfg.system == p.ANDROID, "", origArch.x86) end,
		x86_64 = function(cfg) return iif(cfg.system == p.ANDROID, "", origArch.x86_64) end,
		armv7 = function(cfg) return "" end,
		arm64 = function(cfg) return "" end,
	}
	
	local origArch = premake.tools.gcc.libraryDirectories.architecture
	premake.tools.gcc.libraryDirectories.architecture = {
		x86 = function(cfg) return iif(cfg.system == p.ANDROID, "", origArch.x86) end,
		x86_64 = function(cfg) return iif(cfg.system == p.ANDROID, "", origArch.x86_64) end,
		armv7 = function(cfg) return "" end,
		arm64 = function(cfg) return "" end,
	}

--
-- Set global environment for the default Android platform.
--

	filter { "platforms:armv7" }
		architecture "armv7"
		
	filter { "platforms:arm64" }
		architecture "arm64"

	filter { "system:android" }
		toolchainversion "4.9"
		systemversion "21"
		
	filter { "system:android", "action:gmake", "architecture:armv7" }
		includedirs {
			"$(NDKROOT)/platforms/android-%{cfg.systemversion}/arch-arm/usr/include",
			"$(NDKROOT)/sources/cxx-stl/gnu-libstdc++/%{cfg.toolchainversion}/include",
			"$(NDKROOT)/sources/cxx-stl/gnu-libstdc++/%{cfg.toolchainversion}/libs/armeabi-v7a/include",
			"$(NDKROOT)/toolchains/arm-linux-androideabi-%{cfg.toolchainversion}/prebuilt/linux-x86_64/lib/gcc/arm-linux-androideabi/%{cfg.toolchainversion}/include",
		}
		gccprefix "$(NDKROOT)/toolchains/arm-linux-androideabi-%{cfg.toolchainversion}/prebuilt/linux-x86_64/bin/arm-linux-androideabi-"

	filter { "system:android", "action:gmake", "architecture:arm64" }
		includedirs {
			"$(NDKROOT)/platforms/android-%{cfg.systemversion}/arch-arm64/usr/include",
			"$(NDKROOT)/sources/cxx-stl/gnu-libstdc++/%{cfg.toolchainversion}/include",
			"$(NDKROOT)/sources/cxx-stl/gnu-libstdc++/%{cfg.toolchainversion}/libs/arm64-v8a/include",
			"$(NDKROOT)/toolchains/aarch64-linux-android-%{cfg.toolchainversion}/prebuilt/linux-x86_64/lib/gcc/aarch64-linux-android/%{cfg.toolchainversion}/include",
		}
		gccprefix "$(NDKROOT)/toolchains/aarch64-linux-android-%{cfg.toolchainversion}/prebuilt/linux-x86_64/bin/aarch64-linux-android-"
		
	filter { "system:android", "action:gmake", "architecture:x86" }
		includedirs {
			"$(NDKROOT)/platforms/android-%{cfg.systemversion}/arch-x86/usr/include",
			"$(NDKROOT)/sources/cxx-stl/gnu-libstdc++/%{cfg.toolchainversion}/include",
			"$(NDKROOT)/sources/cxx-stl/gnu-libstdc++/%{cfg.toolchainversion}/libs/x86/include",
			"$(NDKROOT)/toolchains/x86-%{cfg.toolchainversion}/prebuilt/linux-x86_64/lib/gcc/i686-linux-android/%{cfg.toolchainversion}/include",
		}
		gccprefix "$(NDKROOT)/toolchains/x86-%{cfg.toolchainversion}/prebuilt/linux-x86_64/bin/i686-linux-android-"

	filter { "system:android", "action:gmake", "architecture:x64" }
		includedirs {
			"$(NDKROOT)/platforms/android-%{cfg.systemversion}/arch-x86_64/usr/include",
			"$(NDKROOT)/sources/cxx-stl/gnu-libstdc++/%{cfg.toolchainversion}/include",
			"$(NDKROOT)/sources/cxx-stl/gnu-libstdc++/%{cfg.toolchainversion}/libs/x86_64/include",
			"$(NDKROOT)/toolchains/x86_64-%{cfg.toolchainversion}/prebuilt/linux-x86_64/lib/gcc/x86_64-linux-android/%{cfg.toolchainversion}/include",
		}
		gccprefix "$(NDKROOT)/toolchains/x86_64-%{cfg.toolchainversion}/prebuilt/linux-x86_64/bin/x86_64-linux-android-"

--
-- Decide when the full module should be loaded.
--

	return function(cfg)
		return cfg.system == p.ANDROID
	end
