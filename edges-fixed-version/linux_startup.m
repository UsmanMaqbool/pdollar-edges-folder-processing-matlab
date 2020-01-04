!find . -name '*.mexa64' -exec rm {} \;

mex private/edgesDetectMex.cpp -outdir private '-DUSEOMP' CXXFLAGS="\$CXXFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp"
mex private/edgesNmsMex.cpp    -outdir private '-DUSEOMP' CXXFLAGS="\$CXXFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp"
mex private/spDetectMex.cpp    -outdir private '-DUSEOMP' CXXFLAGS="\$CXXFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp"
mex private/edgeBoxesMex.cpp   -outdir private

addpath(pwd);
