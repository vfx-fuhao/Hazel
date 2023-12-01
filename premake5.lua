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


project "Hazel"
    location "Hazel"
    kind "SharedLib"
    language "C++"


    targetdir ("bin/" .. outputdir .. "/Hazel")
    objdir ("bin-int/" .. outputdir .. "/Hazel")

    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }

    includedirs
    {
        "%{prj.name}/vendor/spdlog/include"
    }

    filter "system:windows"
        cppdialect "C++17"
        staticruntime "On"
        systemversion "10.0.19041.0"

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
            systemversion "10.0.19041.0"
    
            defines
            {
                "HZ_PLATFORM_WINDOWS"
            }
    
            -- postbuildcommands
            -- {
            --     ("{COPY} %Hazel/bin/%{cfg.buildcfg}-%{cfg.system}x64/Hazel/Hazel.dll" .. outputdir .. "/Sandbox")
            -- }

        
        filter "configurations:Debug"
            defines "HZ_DEBUG"
            symbols "On"
    
        filter "configurations:Release"
            defines "HZ_RELEASE"
            optimize "On"
    
        filter "configurations:Dist"
            defines "HZ_DIST"
            optimize "On"