function view_tag(E,

e8u_norml_values = norml_values(E,1);

e8u_c1 = e8u_norml_values;
e8u_c1(e8u_c1>.33)  = 0;
e8u_c1 = norml_values(e8u_c1,1);

BW_c1 = im2bw(e8u_c1,0.5);

e8u_c2 = e8u_norml_values;
e8u_c2(e8u_c2<.33)  = 0;
e8u_c2(e8u_c2>.66)  = 0;
e8u_c2 = norml_values(e8u_c2,1);

BW_c2 = im2bw(e8u_c2,0.5);

e8u_c3 = e8u_norml_values;
e8u_c1(e8u_c1<.66)  = 0;
e8u_c3 = norml_values(e8u_c3,1);

BW_c3 = im2bw(e8u_c3,0.5);


sparse_edges_c1 = sparse(BW_c1);
sparse_edges_c2 = sparse(BW_c2);
sparse_edges_c3 = sparse(BW_c3);


%Saving method
save('sparse_edges.mat','sparse_edges_c1','sparse_edges_c2','sparse_edges_c3');
% sparse_e8ue = cat(3,sparse_edges_c1,sparse_edges_c2,sparse_edges_c3);
load_sparse_edges = load('sparse_edges.mat');
load_sparse_edges_c1 = load_sparse_edges.sparse_edges_c1;
load_sparse_edges_c2 = load_sparse_edges.sparse_edges_c2;
load_sparse_edges_c3 = load_sparse_edges.sparse_edges_c3;

c1_mat = full(load_sparse_edges_c1);
c2_mat = full(load_sparse_edges_c2);
c3_mat = full(load_sparse_edges_c3);

c1_mat_255 = uint8(c1_mat)* 85;
c2_mat_255 = uint8(c2_mat)* 170;
c3_mat_255 = uint8(c3_mat)* 255;


mat_255 = c1_mat_255+c2_mat_255+c3_mat_255;
figure; imshow(mat_255)
imwrite(mat_255,'apg.jpg')
end
    function y = norml_values(xx,max_value)
    
    min1=min(xx(:));
    max1=max(xx(:));
    y=((xx-min1).*max_value)./(max1-min1);

end

%figure, imshow(BW)
%figure, imshow(sparse_edges)



%test_enc = encode_edges(e8u);

%save_edge('save_edge.txt', e8u);
