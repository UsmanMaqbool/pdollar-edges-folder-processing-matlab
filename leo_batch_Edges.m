unction results = leoBatchEdges(im)

%% load pre-trained edge detection model and set opts (see edgesDemo.m)

model=load('models/forest/modelBsds'); model=model.model;
model.opts.multiscale=0; model.opts.sharpen=2; model.opts.nThreads=4;

%% set up opts for edgeBoxes (see edgeBoxes.m)
opts = edgeBoxes;
opts.alpha = .85;     % step size of sliding window search0.65
opts.beta  = .8;     % nms threshold for object proposals0.75
opts.minScore = .01;  % min score of boxes to detect
opts.maxBoxes = 200;  % max number of boxes to detect 1e4

%% Calculate object boxes
[bboxes, E] =edgeBoxes(im,model);


results = uint8(E * 255);
