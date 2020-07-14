%Bar?? Can 21501886
%16/12/2019
imagefiles = dir('*.jpg'); 
nfiles = length(imagefiles);
for k = 21:21
    %% Get Superpixels
    currentfilename = imagefiles(21).name;
    img = imread(currentfilename);
    [labels, numlabels] = slicomex(img,500);
    
    %% Get Color Mean 
    hop = cell(numlabels,1);
    for section = 0:numlabels
        j = 0;
        section1 = section + 1;
        for row = 1:size(labels,1)
            for column = 1:size(labels,2)
                if(labels(row,column) == section)
                    j = j + 1;
                    Red = img(row,column, 1);
                    Green = img(row,column, 2);
                    Blue = img(row,column, 3);
                    if (j > 1)
                        meanArray = hop{section1, 1};
                        Red1 = meanArray(1);
                        Green1 = meanArray(2);
                        Blue1 = meanArray(3);
                        
                        Red1 = double(Red1);
                        Green1 = double(Green1);
                        Blue1 = double(Blue1);
                       
                        Red1 = Red1 * j;
                        Green1 = Green1 * j;
                        Blue1 = Blue1 * j;
                        
                        Red1 = Red1 + double(Red);
                        Green1 = Green1 + double(Green);
                        Blue1 = Blue1 + double(Blue);
                        
                        Red1 = Red1 / (j+1);
                        Green1 = Green1 / (j+1);
                        Blue1 = Blue1 / (j+1);

                        hop{section1, 1} = [Red1, Green1, Blue1];
                    elseif (j == 1)
                        hop{section1, 1} = [Red, Green, Blue];
                    end
                end
            end
        end
    end
    
    %% Transpose hop and make it array
    inverseHop = zeros(3,numlabels);
    for i = 1:3
        for j = 1:numlabels
            firstEl = hop{j};
            firstEl1 = firstEl(i);
            inverseHop(i,j) = double(firstEl1);
        end
    end
    normalizedHop = normalize(inverseHop,'norm',1);
    
    %% Color Distance
    newLabels = labels;
    for mergeRow = 0:numlabels-1
        newMergeRow = mergeRow + 1;
        firstR = double(normalizedHop(1,newMergeRow));
        firstG = double(normalizedHop(2,newMergeRow));
        firstB = double(normalizedHop(3,newMergeRow));
        
        for mergeColumn = 0:numlabels-1
            newMergeColumn = mergeColumn + 1;
            secondR = double(normalizedHop(1,newMergeColumn));
            secondG = double(normalizedHop(2,newMergeColumn));
            secondB = double(normalizedHop(3,newMergeColumn));
            if(sqrt((firstR-secondR)^2 + (firstG-secondG)^2 + (firstB-secondB)^2) < 0.11)
                for rowFinal = 1:size(labels,1)
                    for columnFinal = 1:size(labels,2)
                        if(labels(rowFinal, columnFinal) == mergeColumn)
                            newLabels(rowFinal, columnFinal) = mergeRow;
                        end
                    end
                end
            end
        end
    end
    
    %% Get Gabor Values 
    I = rgb2gray(img);
    magCell = cell(4,4);
    wavelength(1) = 2;
    wavelength(2) = 3.3;
    wavelength(3) = 4.6;
    wavelength(4) = 6;
    orientation(1) = 45;
    orientation(2) = 90;
    orientation(3) = 135;
    orientation(4) = 180;
    for k = 1:4
        for t = 1:4
            [mag,phase] = imgaborfilt(I,wavelength(k),orientation(t));
            magCell{k,t} = mag;
        end
        arro = cell2mat(magCell(k,1));
        arro1 = cell2mat(magCell(k,2));
        arro2 = cell2mat(magCell(k,3));
        arro3 = cell2mat(magCell(k,4));
       
        figure; 
        h = subplot(2,2,1);
        imshow(arro, []);
        title(['Scale : ', num2str(k), ' Orientation : 1']);
        subplot(2,2,2);
        imshow(arro1, []);
        title(['Scale : ', num2str(k), ' Orientation : 2']);
        subplot(2,2,3);
        imshow(arro2, []);
        title(['Scale : ', num2str(k), ' Orientation : 3']);
        subplot(2,2,4);
        imshow(arro3, []);
        title(['Scale : ', num2str(k), ' Orientation : 4']);
        
    end
    
    %% Get Gabor Mean
    hop2 = cell(numlabels,4);
    for gaborRow = 1:4
        for section = 0:numlabels
            j = 0;
            section1 = section + 1;
            arro1 = cell2mat(magCell(gaborRow, 1));
            arro2 = cell2mat(magCell(gaborRow, 2));
            arro3 = cell2mat(magCell(gaborRow, 3));
            arro4 = cell2mat(magCell(gaborRow, 4));
            for row = 1:size(labels,1)
                for column = 1:size(labels,2)
                    if(labels(row,column) == section)
                        j = j + 1;
                        gaborValue1 = arro1(row,column);
                        gaborValue2 = arro2(row,column);
                        gaborValue3 = arro3(row,column);
                        gaborValue4 = arro4(row,column);
                        
                        if (j > 1)
                            meanArray = hop2{section1, gaborRow};

                            newGaborValue1 = meanArray(1);
                            newGaborValue2 = meanArray(2);
                            newGaborValue3 = meanArray(3);
                            newGaborValue4 = meanArray(4);

                            newGaborValue1 = double(newGaborValue1);
                            newGaborValue2 = double(newGaborValue2);
                            newGaborValue3 = double(newGaborValue3);
                            newGaborValue4 = double(newGaborValue4);

                            newGaborValue1 = newGaborValue1 * j;
                            newGaborValue2 = newGaborValue2 * j;
                            newGaborValue3 = newGaborValue3 * j;
                            newGaborValue4 = newGaborValue4 * j;

                            newGaborValue1 = newGaborValue1 + double(gaborValue1);
                            newGaborValue2 = newGaborValue2 + double(gaborValue2);
                            newGaborValue3 = newGaborValue3 + double(gaborValue3);
                            newGaborValue4 = newGaborValue4 + double(gaborValue4);

                            newGaborValue1 = newGaborValue1 / (j+1);
                            newGaborValue2 = newGaborValue2 / (j+1);
                            newGaborValue3 = newGaborValue3 / (j+1);
                            newGaborValue4 = newGaborValue4 / (j+1);

                            hop2{section1, gaborRow} = [newGaborValue1, newGaborValue2, newGaborValue3, newGaborValue4];
                            
                        elseif (j == 1)
                            hop2{section1, gaborRow} = [gaborValue1, gaborValue2, gaborValue3, gaborValue4];
                        end
                    end
                end
            end
        end
    end

    %% Transpose hop and make it array
    inverseHop2 = zeros(16,numlabels);
    temp = 1;
    for i = 1:4
        for j = 1:numlabels
            firstEl = hop2{j,i};
            firstEl1 = firstEl(1);
            firstEl2 = firstEl(2);
            firstEl3 = firstEl(3);
            firstEl4 = firstEl(4);
            
            inverseHop2(temp,j) = firstEl1;
            inverseHop2(temp+1,j) = firstEl2;
            inverseHop2(temp+2,j) = firstEl3;
            inverseHop2(temp+3,j) = firstEl4;
        end
        temp = temp + 4;
    end
    normalizedHop2 = normalize(inverseHop2,'norm',1);
    
    %% Gabor Distance
    firstGabor = zeros(1,16);
    secondGabor = zeros(1,16);
    newLabelsGabor = labels;
    for mergeRow = 0:numlabels-1
        mergeRowUse = mergeRow +1;
        for counter = 1:16
            firstGabor(counter) = double(normalizedHop2(counter,mergeRowUse));
        end
        for mergeColumn = 0:numlabels-1
            mergeColumnUse = mergeColumn + 1;
            for counter = 1:16
                secondGabor(counter) = double(normalizedHop2(counter,mergeColumnUse));
            end
            if(sqrt((firstGabor(1)-secondGabor(1))^2 + (firstGabor(2)-secondGabor(2))^2 +(firstGabor(3)-secondGabor(3))^2 +(firstGabor(4)-secondGabor(4))^2 ...
                +(firstGabor(5)-secondGabor(5))^2 +(firstGabor(6)-secondGabor(6))^2 +(firstGabor(7)-secondGabor(7))^2 +(firstGabor(8)-secondGabor(8))^2 ...
                +(firstGabor(9)-secondGabor(9))^2 +(firstGabor(10)-secondGabor(10))^2 +(firstGabor(11)-secondGabor(11))^2 +(firstGabor(12)-secondGabor(12))^2 ...
                +(firstGabor(13)-secondGabor(13))^2 +(firstGabor(14)-secondGabor(14))^2 +(firstGabor(15)-secondGabor(15))^2 +(firstGabor(16)-secondGabor(16))^2) < 0.25)
                for rowFinalGabor = 1:size(labels,1)
                    for columnFinalGabor = 1:size(labels,2)
                        if(labels(rowFinalGabor, columnFinalGabor) == mergeColumn)
                            newLabelsGabor(rowFinalGabor, columnFinalGabor) = mergeRow;
                        end
                    end
                end
            end
        end
    end
    
    %% Color-Texture Distance
    color_texture = zeros(19,numlabels);
    for i =1:19
        if i < 17
            color_texture(i,:) = normalizedHop2(i,:);
        else
            color_texture(i,:) = normalizedHop(i-16,:);
        end
    end
    firstTexture = zeros(1,19);
    secondTexture = zeros(1,19);
    newLabelsMerge = labels;
    
    for mergeRow = 0:numlabels-1
        mergeRowUse = mergeRow +1;
        for counter = 1:19
            firstTexture(counter) = double(color_texture(counter,mergeRowUse));
        end
        for mergeColumn = 0:numlabels-1
            mergeColumnUse = mergeColumn + 1;
            for counter = 1:19
                secondTexture(counter) = double(color_texture(counter,mergeColumnUse));
            end
            if(sqrt((firstTexture(1)-secondTexture(1))^2 + (firstTexture(2)-secondTexture(2))^2 +(firstTexture(3)-secondTexture(3))^2 +(firstTexture(4)-secondTexture(4))^2 ...
                +(firstTexture(5)-secondTexture(5))^2 +(firstTexture(6)-secondTexture(6))^2 +(firstTexture(7)-secondTexture(7))^2 +(firstTexture(8)-secondTexture(8))^2 ...
                +(firstTexture(9)-secondTexture(9))^2 +(firstTexture(10)-secondTexture(10))^2 +(firstTexture(11)-secondTexture(11))^2 +(firstTexture(12)-secondTexture(12))^2 ...
                +(firstTexture(13)-secondTexture(13))^2 +(firstTexture(14)-secondTexture(14))^2 +(firstTexture(15)-secondTexture(15))^2 +(firstTexture(16)-secondTexture(16))^2) ...
                + (firstTexture(17)-secondTexture(17))^2 + (firstTexture(18)-secondTexture(18))^2 + (firstTexture(19)-secondTexture(19))^2 < 0.27)
                for rowFinalMerge = 1:size(labels,1)
                    for columnFinalMerge = 1:size(labels,2)
                        if(labels(rowFinalMerge, columnFinalMerge) == mergeColumn)
                            newLabelsMerge(rowFinalMerge, columnFinalMerge) = mergeRow;
                        end
                    end
                end
            end
        end
    end
    
    %% Mask for Color
    
    mask = boundarymask(newLabels);
    maskedImg1 = labeloverlay(img,mask,'Transparency',0);
    
    %% Mask for Gabor
    mask = boundarymask(newLabelsGabor);
    maskedImg2 = labeloverlay(img,mask,'Transparency',0);
    
    %% Mask for Color-Texture
    mask = boundarymask(newLabelsMerge);
    maskedImg3 = labeloverlay(img,mask,'Transparency',0);
    
    %% End
    figure; 
    subplot(1,3,1);
    imshow(maskedImg1, []);
    title('Color Features');
    subplot(1,3,2);
    imshow(maskedImg2, []);
    title('Texture Features');
    subplot(1,3,3);
    imshow(maskedImg3, []);
    title('Color-Texture Features');
end