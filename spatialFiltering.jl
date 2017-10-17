include("tools.jl")

function spatialFilter(img, w)
    rows, cols = size(img, 1, 2)

    newimg = zeros(rows, cols)

    for i = 2:rows - 1
        for j = 2:cols - 1
            x, y = (i-1):i+1, (j-1):j+1
            newimg[i, j] = sum(img[x, y] .* w)
        end
    end

    return newimg

end

function genKernel(ktype == "laplacian")
    if ktype == "sobel.y"
        return [ 1   2  1;
                 0   0  0;
               - 1  -2  -1.0]
    elseif ktype == "sobel.x"
        return [ 1  0  -1;
                 2  0  -2;
                 1  0  -1.0]
    elseif ktype == "robert"
        return [1 0 ; 0 -1.0]
    else
        # laplacian
        return [0  1  0;
                1 -4  1;
                0  1  0.0]
    end


end

function multiple(imagename)    
    # Load image
    img = imgLoad("img/book/$imagename", 1)

    imagename = replace(imagename,".", "-")





    newimg  = spatialFilter(img, genKernel("sobel.x"))
    newimg2 = spatialFilter(img, genKernel("sobel.y"))

    res = sqrt.(newimg.^2 + newimg2.^2)

    save("tmp/img/$imagename.pdf", setGray(img))
    imshow(img)
    imshow(newimg)
    imshow(newimg2)
    imshow(res)
end

function main()
    fnames = ["Fig3.24.jpg", "Fig3.13.jpg", "Fig3.40(a).jpg", "Fig3.45(a).jpg"]

    for n in fnames
        multiple(n)
    end
end

# main()