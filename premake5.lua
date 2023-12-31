workspace "Hazel"
    architecture "x64"
    startproject "Sandbox"

    configurations
    {
        "Debug",
        "Release",
        "Dist"
    }

outputdir = "%{cfg.buildcfg}-%{cfg.system}x64"

-- Include directories relative to root folder (solution directory)
IncludeDir = {}
IncludeDir["GLFW"] = "Hazel/vendor/GLFW/include"

include "Hazel/vendor/GLFW"


project "Hazel"
    location "Hazel"
    kind "SharedLib"
    language "C++"
    -- staticruntime "off"
    -- runtime "Debug"


    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")


    pchheader "hzpch.h"
    pchsource "Hazel/src/hzpch.cpp"

    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }

    includedirs
    {
        "%{prj.name}/src",
        "%{prj.name}/vendor/spdlog/include",
        "%{IncludeDir.GLFW}"
    }


    links
    {
        "GLFW",
        "opengl32.lib",
        "dwmapi.lib"
    }

    filter "system:windows"
        cppdialect "C++17"
        staticruntime "On"
        systemversion "latest"

        defines
        {
            "HZ_PLATFORM_WINDOWS",
            "HZ_BUILD_DLL"
        }

        postbuildcommands
        {
            ("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox")
        }

    
    filter "configurations:Debug"
        defines "HZ_DEBUG"
        symbols "On"

    filter "configurations:Release"
        defines "HZ_RELEASE"
        optimize "On"

    filter "configurations:Dist"
        defines "HZ_DIST"
        optimize "On"



project "Sandbox"
        location "Sandbox"
        kind "ConsoleApp"
        language "C++"
        -- staticruntime "On"


        targetdir ("bin/" .. outputdir .. "/Sandbox")
        objdir ("bin-int/" .. outputdir .. "/Sandbox")


        files
        {
            "%{prj.name}/src/**.h",
            "%{prj.name}/src/**.cpp"
        }
    
        includedirs
        {
            "Hazel/vendor/spdlog/include",
            "Hazel/src"
        }


        links
        {
            "Hazel"
        }
    
        filter "system:windows"
            cppdialect "C++17"
            staticruntime "On"
            systemversion "latest"
    
            defines
            {
                "HZ_PLATFORM_WINDOWS"
            }
    


        
        filter "configurations:Debug"
            defines "HZ_DEBUG"
            symbols "On"
    
        filter "configurations:Release"
            defines "HZ_RELEASE"
            optimize "On"
    
        filter "configurations:Dist"
            defines "HZ_DIST"
            optimize "On"