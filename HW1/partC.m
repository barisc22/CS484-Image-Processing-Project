%Bar?? Can - 21501886
hop1 = imread( 'in000470.jpg');
hop2 = imread( 'in000550.jpg');
hop3 = imread( 'in000750.jpg');
hop4 = imread( 'in000850.jpg');
difference1 = hop1 - hop2;
difference2 = hop1 - hop3;
difference3 = hop1 - hop4;
figure; imshow([difference1, difference2, difference3]);
xlabel('Difference of 1-2, 1-3, 1-4')

red = difference1( :, :, 1 );    % first (red) band
green = difference1( :, :, 2 );  % second (green) band
blue = difference1( :, :, 3 );   % third (blue) band
gray1 = ((red+green+blue)/3);

red = difference2( :, :, 1 );    % first (red) band
green = difference2( :, :, 2 );  % second (green) band
blue = difference2( :, :, 3 );   % third (blue) band
gray2 = ((red+green+blue)/3);

red = difference3( :, :, 1 );    % first (red) band
green = difference3( :, :, 2 );  % second (green) band
blue = difference3( :, :, 3 );   % third (blue) band
gray3 = ((red+green+blue)/3);
normalizedImage1 = uint8(255*mat2gray(gray1));
normalizedImage2 = uint8(255*mat2gray(gray2));
normalizedImage3 = uint8(255*mat2gray(gray3));
figure; imshow([normalizedImage1, normalizedImage2, normalizedImage3]);
xlabel('Grayscales of 1-2, 1-3, 1-4')

BW1 = gray1 > 33;
BW2 = gray2 > 30;
BW3 = gray3 > 58;
figure; imshow([BW1, BW2, BW3]);
xlabel('Binaries of 1-2, 1-3, 1-4')
erosion(BW1, 2);
hop = imread( 'hop.png');
dilation(hop, 6);

erosion(BW2, 2);
hop = imread( 'hop.png');
dilation(hop, 7);

erosion(BW3, 2);
hop = imread( 'hop.png');
dilation(hop, 15);

