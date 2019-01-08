if (ENABLE_VIDEO OR ENABLE_WEB_AUDIO)
    set(GSTREAMER_COMPONENTS app pbutils)
    SET_AND_EXPOSE_TO_BUILD(USE_GSTREAMER TRUE)
    if (ENABLE_VIDEO)
        list(APPEND GSTREAMER_COMPONENTS video mpegts tag gl)
    endif ()

    if (ENABLE_WEB_AUDIO)
        list(APPEND GSTREAMER_COMPONENTS audio fft)
        SET_AND_EXPOSE_TO_BUILD(USE_WEBAUDIO_GSTREAMER TRUE)
    endif ()

    find_package(GStreamer 1.8.3 REQUIRED COMPONENTS ${GSTREAMER_COMPONENTS})

    if (ENABLE_WEB_AUDIO)
        if (NOT PC_GSTREAMER_AUDIO_FOUND OR NOT PC_GSTREAMER_FFT_FOUND)
            message(FATAL_ERROR "WebAudio requires the audio and fft GStreamer libraries. Please check your gst-plugins-base installation.")
        else ()
            SET_AND_EXPOSE_TO_BUILD(USE_WEBAUDIO_GSTREAMER TRUE)
        endif ()
    endif ()

    if (ENABLE_VIDEO)
        if (NOT PC_GSTREAMER_APP_FOUND OR NOT PC_GSTREAMER_PBUTILS_FOUND OR NOT PC_GSTREAMER_TAG_FOUND OR NOT PC_GSTREAMER_VIDEO_FOUND)
            message(FATAL_ERROR "Video playback requires the following GStreamer libraries: app, pbutils, tag, video. Please check your gst-plugins-base installation.")
        endif ()
    endif ()

    if (USE_GSTREAMER_MPEGTS)
        if (NOT PC_GSTREAMER_MPEGTS_FOUND)
            message(FATAL_ERROR "GStreamer MPEG-TS is needed for USE_GSTREAMER_MPEGTS.")
        endif ()
    endif ()

    if (USE_GSTREAMER_GL)
        if (PC_GSTREAMER_VERSION VERSION_LESS "1.10")
            message(FATAL_ERROR "GStreamer 1.10 is needed for USE_GSTREAMER_GL.")
        else ()
            if (NOT PC_GSTREAMER_GL_FOUND)
                message(FATAL_ERROR "GStreamerGL is needed for USE_GSTREAMER_GL.")
            endif ()
        endif ()
    endif ()

    SET_AND_EXPOSE_TO_BUILD(USE_GSTREAMER TRUE)
endif ()

if (ENABLE_MEDIA_SOURCE)
    if (PC_GSTREAMER_VERSION VERSION_LESS "1.14")
        message(FATAL_ERROR "GStreamer 1.14 is needed for ENABLE_MEDIA_SOURCE.")
    endif ()
endif ()

if (ENABLE_MEDIA_STREAM OR ENABLE_WEB_RTC)
    if (PC_GSTREAMER_VERSION VERSION_LESS "1.10")
        SET_AND_EXPOSE_TO_BUILD(USE_LIBWEBRTC FALSE)
        SET_AND_EXPOSE_TO_BUILD(WEBRTC_WEBKIT_BUILD FALSE)
    else ()
        SET_AND_EXPOSE_TO_BUILD(USE_LIBWEBRTC TRUE)
        SET_AND_EXPOSE_TO_BUILD(WEBRTC_WEBKIT_BUILD TRUE)
    endif ()
else ()
    SET_AND_EXPOSE_TO_BUILD(USE_LIBWEBRTC FALSE)
    SET_AND_EXPOSE_TO_BUILD(WEBRTC_WEBKIT_BUILD FALSE)
endif ()
