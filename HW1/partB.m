%Bar?? Can - 21501886
hop = imread( 'ct.png');

BW = hop > 128;
erosion(BW, 7);

hop = imread( 'hop.png');
dilation(hop, 13);

hop = imread( 'hop.png');
cc = bwconncomp(hop, 8);
labeled = labelmatrix(cc);
RGB_label = label2rgb(labeled);
figure; imshow(RGB_label);
