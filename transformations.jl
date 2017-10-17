include("tools.jl")
include("mybilinear.jl")

function translation(p, Txy)
    return p - Txy
end

function myscale(p, Sxy)
    return p .* 1.0 ./ Sxy
end

function rotate(p, θ)
    M = [cos(θ) -sin(θ);
         sin(θ)  cos(θ)]
    
    return M * p
end


function mytranform(img, Txy, Sxy, θ)
    rows, cols = size(img, 1, 2)

    mycenter = round.(Int32, [cols, rows] / 2)

    newimg = zeros(rows, cols)
    
    for x = 1:cols
        for y = 1:rows
            p = [x, y] - mycenter

            # (start) afine transformations
            # Order is important
            p = translation(p, Txy)
            p = rotate(p, θ)
            p = myscale(p, Sxy)
            # (end) afine transformations

            p = p + mycenter

            xy  = int(p)
            dxy = p - xy

            newimg[y, x] = bilinear(img, reverse(xy), reverse(dxy))
            
        end
    end

    return newimg
    
end

function main()
	img = imgLoad("img/book/Fig3.35(a).jpg", 1)

    S = 0.5

    Txy = [50, 100]
    Sxy = [S, S]
    θ   = 7π /8 

    newimg = mytranform(img, Txy, Sxy, θ)


    newimg2 = mytranform(newimg, -reverse(Txy), 1 ./Sxy, -θ)

    imshow(img)
    imshow(newimg)
    imshow(newimg2)

    println((norm(img - newimg2)))
end

# main()