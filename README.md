Used https://github.com/pdollar/edges.git as edge-box shadow detection tool-box

Used https://pdollar.github.io/toolbox/ as pdollar-toolbox


First install the toolbox

```matlab
cd edges-fixed-version/fixed-toolbox
run linux_startup.m
```

Please Compile Mex Files again 

```
cd ../
mex private/edgesDetectMex.cpp -outdir private [OMPPARAMS]
mex private/edgesNmsMex.cpp    -outdir private [OMPPARAMS]
mex private/spDetectMex.cpp    -outdir private [OMPPARAMS]
mex private/edgeBoxesMex.cpp   -outdir private

Linux V1: [OMPPARAMS] = '-DUSEOMP' CFLAGS="\$CFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp"
Linux V2: [OMPPARAMS] = '-DUSEOMP' CXXFLAGS="\$CXXFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp"
```

Afterwards please use the file leo*.m

Cheers