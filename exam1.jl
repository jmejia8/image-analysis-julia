include("histogramEqualization.jl")
include("spatialFiltering.jl")
using Plots
using Interpolations
plotlyjs(size = (1280, 500))


function imagen1()
    img = imgLoad("img/Imagen1.png");
    img = Int32.(floor.(img))

    intento1(img) = begin
        # equalizacion global
        new1 = histEqualization(img);

        h  = calcHist(img)
        h2  = calcHist(Int32.(floor.(new1*255)))

        hst1 =  bar(h,  color=:blue,
                        label = "Original")

        # Transformed image histogram
        hst2 =  bar(h2, color=:red,
                        label = "Ecualizada")

        plot(hst1, hst2)
        imshow(new1)
    end

    intento2(img) = begin
        # polinomio
        puntos = [0   0;
                84   174;
                 142 97;
                 198 198;
                 255 255]

        # interpolation values
        vals = [1,2, 4, 6, 8, 10, 12, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35, 
                37, 39, 41, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70, 
                73, 75, 77, 79, 81, 83, 85, 87, 89, 91, 93, 95, 97, 99, 102, 104, 
                106, 108, 110, 112, 114, 116, 118, 120, 122, 124, 126, 128, 131, 
                133, 135, 137, 139, 141, 143, 145, 147, 149, 151, 153, 155, 157, 
                160, 162, 164, 166, 168, 170, 172, 174, 173, 171, 170, 169, 167, 
                166, 165, 163, 162, 161, 159, 158, 157, 155, 154, 153, 151, 150, 
                149, 147, 146, 145, 143, 142, 141, 139, 138, 137, 136, 134, 133, 
                132, 130, 129, 128, 126, 125, 124, 122, 121, 120, 118, 117, 116, 
                114, 113, 112, 110, 109, 108, 106, 105, 104, 102, 101, 100, 98, 
                97, 99, 101, 102, 104, 106, 108, 110, 111, 113, 115, 117, 119, 
                120, 122, 124, 126, 128, 129, 131, 133, 135, 137, 138, 140, 142, 
                144, 146, 148, 149, 151, 153, 155, 157, 158, 160, 162, 164, 166, 
                167, 169, 171, 173, 175, 176, 178, 180, 182, 184, 185, 187, 189, 
                191, 193, 194, 196, 198, 199, 200, 201, 202, 203, 204, 205, 206, 
                207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 
                220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 
                233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 
                246, 247, 248, 249, 250, 251, 252, 253, 254, 255]

        # poly values
        p(x) = vals[x+1]

        # transformed image
        new1 = map(p, img)

        h    = calcHist(new1)
        imshow(new1)
        
        hst1 =  bar(255h/maximum(h),  color=:blue,
                        label = "Original")

        plot!(1:255, p)

    end

    intento2(img)

end

function imagen2()
    img = imgLoad("img/Imagen2.jpg",1);

    w = ones(3,3) / 9
    defuminada =  spatialFilter(img, w)

    w = genKernel()
    bordes = spatialFilter(img, w)
    # Definidiendo la imagen
    new1 = imrepair(2defuminada - bordes)

    equalizada = histEqualization(Int32.(floor.(new1*255)))

    imshow(img)
    imshow(new1)
    imshow(equalizada)
    
end

function imagen3()
    img = imgLoad("img/Imagen3.jpg",1);
    img2 = imgLoad("img/ayuda.jpg",1);

    imshow(img)
    imshow(img - img2)

    
end

function imagen4()
    img = imgLoad("img/Imagen4.png",1);

    rows, cols = size(img, 1, 2)

    new1 = zeros(rows, cols)

    for i = 2:rows - 1
        for j = 2:cols - 1
            x, y = (i-1):i+1, (j-1):j+1
            new1[i, j] = median(img[x, y])
        end
    end

    imshow(img)
    imshow(new1)
end

function imagen5()
    img = imgLoad("img/Imagen5.tif",1);

    F = fftshift(fft(img))
    
    # imshow(img)
    # imshow(log.(1+abs.(F)))


    F[59:63, 60:63] = 0.1F[59:63, 60:63]
    imshow(log.(1+abs.(F)))
    imshow(real(   ifft(ifftshift(F))   ))
end

# test
imagen1()
imagen2()
imagen3()
imagen4()
imagen5()