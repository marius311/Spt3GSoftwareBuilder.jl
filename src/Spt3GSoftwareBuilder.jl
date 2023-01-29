module Spt3GSoftwareBuilder

using Python_jll, boost_jll, boostpython_jll, GSL_jll, FFTW_jll, NetCDF_jll, HDF5_jll, FLAC_jll

function cmake_flags_dict()

    # Julia has a separate boostpython_jll package for Boost python
    # bindings, but cmake can only take a single boost lib
    # directory, so copy it into the main boost_jll directory
    libboost_python = joinpath(boost_jll.artifact_dir,  "lib/libboost_python38.so")
    if !isfile(libboost_python)
        symlink(joinpath(boostpython_jll.artifact_dir,  "lib/libboost_python38.so"), libboost_python)
    end

    Dict(

        :Python_EXECUTABLE    => Python_jll.python_path,

        :Boost_INCLUDE_DIR    => joinpath(boost_jll.artifact_dir,  "include"),
        :Boost_LIBRARY_DIR    => joinpath(boost_jll.artifact_dir,  "lib"),
        
        :GSL_INCLUDES         => joinpath(GSL_jll.artifact_dir,    "include"),
        :GSL_LIB              => joinpath(GSL_jll.artifact_dir,    "lib/libgsl.so"),
        :GSL_CBLAS_LIB        => joinpath(GSL_jll.artifact_dir,    "lib/libgslcblas.so"),
        
        :FFTW_INCLUDES        => joinpath(FFTW_jll.artifact_dir,   "include"),
        :FFTW_LIBRARIES       => joinpath(FFTW_jll.artifact_dir,   "lib/libfftw3.so"),
        :FFTW_THREADS_LIBRARY => joinpath(FFTW_jll.artifact_dir,   "lib/libfftw3.so"),
        
        :NETCDF_INCLUDES      => joinpath(NetCDF_jll.artifact_dir, "include"),
        :NETCDF_LIBRARIES     => joinpath(NetCDF_jll.artifact_dir, "lib/libnetcdf.so"),
        
        :HDF5_INCLUDES        => joinpath(HDF5_jll.artifact_dir,   "include"),
        :HDF5_LIBRARIES       => joinpath(HDF5_jll.artifact_dir,   "lib/libhdf5.so"),
        :HDF5_HL_LIBRARIES    => joinpath(HDF5_jll.artifact_dir,   "lib/libhdf5_hl.so"),

        :FLAC_INCLUDE_DIR     => joinpath(FLAC_jll.artifact_dir,   "include"),
        :FLAC_LIBRARIES       => joinpath(FLAC_jll.artifact_dir,   "lib/libFLAC.so"),

        :CMAKE_BUILD_WITH_INSTALL_RPATH => "TRUE",
        :CMAKE_INSTALL_RPATH => "'$(join(Set(vcat(
            boost_jll.LIBPATH_list, 
            GSL_jll.LIBPATH_list, 
            FFTW_jll.LIBPATH_list, 
            NetCDF_jll.LIBPATH_list, 
            HDF5_jll.LIBPATH_list, 
            FLAC_jll.LIBPATH_list)
        ), ";"))'"        
    )

end

function cmake_flags()
    join(map(collect(pairs(cmake_flags_dict()))) do (k, v)
        "-D$(k)=$(v)"
    end, " ")
end

end