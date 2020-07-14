%Bar?? Can - 21501886
function binary_image = erosion ( source_image , struct_el )
    imdata = source_image;
    [row, column] = size(imdata);
    new_imdata = zeros(row, column);
    new_imdata = imdata;
    struct = zeros(struct_el, struct_el);
    new_struct = zeros(struct_el, struct_el);
    
    for k = 1:row 
        for t = 1:column 
            if (imdata(k, t) == 1)
                if (ceil(struct_el/2)-1) >= k
                    a = 1;
                elseif (ceil(struct_el/2)-1) < k
                    a = k - (ceil(struct_el/2)-1);
                end
                
                if (ceil(struct_el/2)-1) >= t
                    b = 1;
                elseif (ceil(struct_el/2)-1) < t
                    b = t - (ceil(struct_el/2)-1);
                end
                
                if (a+struct_el-1 > row && b+struct_el-1 > column)
                    struct(1:row-a+1, 1:column-b+1) = imdata(a:row, b:column);
                elseif (a+struct_el-1 < row && b+struct_el-1 > column)
                    struct(1:struct_el, 1:column-b+1) = imdata(a:a+struct_el-1, b:column);
                elseif (a+struct_el-1 > row && b+struct_el-1 < column)
                    struct(1:row-a+1, 1:struct_el) = imdata(a:row, b:b+struct_el-1);
                elseif (a+struct_el-1 <= row && b+struct_el-1 <= column)
                    struct(1:struct_el, 1:struct_el) = imdata(a:a+struct_el-1, b:b+struct_el-1);
                end 
                
                %zero = all(struct, 'all');
                [row1, column1] = size(struct);
                flag=0;
                for k1 = 1:row1
                    for t1 = 1:column1
                        if (struct(k1, t1) == 0)
                            flag = 1;
                        end
                    end
                end
                
                if flag == 1 && (k > ceil(struct_el/2) -1 ) && (k  < row - ceil(struct_el/2)-1) && (t  > ceil(struct_el/2)-1) && (t  < column - ceil(struct_el/2)-1)
                    new_imdata(a:a+struct_el-1, b:b+struct_el-1) = new_struct;
                end
            end
        end
    end
    
    figure; imshow([source_image, new_imdata]);
    xlabel('Erosion Applied')
    imwrite(new_imdata,'hop.png');
end
