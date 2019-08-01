-- clear global state
filter {}
configuration {}

-- common stuff that we want to be common among all projects
warnings "Extra"
targetname "%{prj.name}"
flags { "NoMinimalRebuild", "NoPCH" }
exceptionhandling "Off"
rtti "Off"

objdir "%{wks.location}/Output/intermediate/%{prj.name}/%{cfg.buildcfg}_%{cfg.platform}"
filter { "kind:SharedLib or StaticLib" }
	targetdir "%{wks.location}/Output/lib/%{cfg.buildcfg}_%{cfg.platform}"
filter { "kind:ConsoleApp or WindowedApp" }
	targetdir "%{wks.location}/Output/bin/%{cfg.buildcfg}_%{cfg.platform}"

-- configurations
filter { "configurations:Debug*" }
	defines { "_DEBUG" }
	optimize "Off"
	symbols "On"

filter { "configurations:DebugOpt*" }
	defines { "_DEBUG" }
	optimize "Debug"
	symbols "On"

filter { "configurations:Release*" }
	defines { "NDEBUG" }
	optimize "Full"
	symbols "Off"
	flags { "NoFramePointer", "NoBufferSecurityCheck" }

-- platform config
filter { "system:windows" }
	flags { "NoIncrementalLink" }

filter { "system:windows", "kind:*App" }
	defines { "WIN32", "_WINDOWS" }
	links { "kernel32.lib", "user32.lib", "gdi32.lib", "winspool.lib", "comdlg32.lib", "advapi32.lib", "shell32.lib", "ole32.lib", "oleaut32.lib", "uuid.lib", "odbc32.lib", "odbccp32.lib" }

filter { "system:linux" }
	links { "pthread" }
	links { "rt" }

filter {}
