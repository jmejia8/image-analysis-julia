include("transformations.jl")

function procrustes(A, B)
    U, S, V = svd(B * A')  

    return U * V'
end

function transformImg(img, M, b)
    rows, cols = size(img, 1, 2)

    newimg = ones(rows, cols)
    for x = 1:cols
        for y = 1:rows
            xx, yy = round.(Int32,  M * [x, y] + b )
            if !( 0 < xx <= cols) || !( 0 < yy <= rows) 
                continue end

            newimg[y, x] = img[yy, xx]
        end
    end

    return newimg
end

function transforMat(Txy, Sxy, θ)
    θ *= -1
    M = eye(3, 3)
    M[1:2, 3] = Txy

    Φ = [cos(θ) -sin(θ);
         sin(θ)  cos(θ)]
    
    M[1:2, 1:2] = Φ

    M[1,1] *= Sxy[1] 
    M[2,2] *= Sxy[2] 


    return M
end

function center2D(x)
    n = size(x,2)
    # println("X == ", x)
    mmean = [mean(x[1,:]), mean(x[2,:]),]
    mmean = repmat(mmean, 1, n)

    return x - mmean
end

function coorTrans(coors, Txy, Sxy, θ, imcenter)
    n, m = size(coors, 1, 2)
    
    # A = eye(n, 2)
    B = eye(n, 2)

    for i = 1:n
        p = coors[i,1:2]
        # A[i, 1:2] = p

        p = p - imcenter
        
        p = translation(p, -reverse(Txy))
        p = rotate(p, -θ)
        p = myscale(p, (1./ Sxy))
        p = p + imcenter

        B[i,1:2] = p
    end

    return B
end

function main()
    img = imgLoad("img/nao.png", 1)

    rows, cols = size(img, 1, 2)

    Txy = [0,0]#[0.2rows*rand() , 0.2cols*rand()]
    S   = rand()
    θ   = 2π*rand()

    Sxy = [S, S]
    imcenter = [rows, cols] / 2

    imgTrans = mytranform(img, Txy, Sxy, θ)

   coors = [ 320 45;
         266 95;
         378 95;
         148 220;
         440 250;
         320 320;
         230 400;
         300 415;
         330 415;
         410 415;
         215 530;         
         280 530;         
         350 530;         
         420 530;
         270 150;     
         390 150     
    ]

    n, m = size(coors, 1, 2)


    A = coors'

    B = coorTrans(coors, Txy, Sxy, θ, imcenter)
    B = B'

    Ω = procrustes(center2D(B), center2D(A))


    A = A'
    B = B'
    # return  C
    subplot(1, 3, 1)
    imshow(img, cmap=:gray)
    plot(A[3:end,1], A[3:end,2], marker=:o, lw=0, color=:red)
    plot(A[1:2,1], A[1:2,2], marker=:o, lw=0, color=:blue)

    subplot(1, 3, 2)
    imshow(imgTrans, cmap=:gray)
    plot(B[3:end,1], B[3:end,2], marker=:o, lw=0, color=:red)
    plot(B[1:2,1], B[1:2,2], marker=:o, lw=0, color=:blue)




    subplot(1, 3, 3)
    imshow(img, cmap=:gray)
    for i in 1:5
        s = rand()
        B = coorTrans(coors, [0,0], [s,s], 2π*rand(), imcenter)
        C = Ω * B'

        C = center2D(C)

        C /= maximum(C)
        C *= 210
        
        C += repmat(imcenter, 1, n)

        C = C'

        plot(C[3:end,1], C[3:end,2], marker=:o, lw=0, color=:red)
        plot(C[1:2,1], C[1:2,2], marker=:o, lw=0, color=:blue)
    end

    # subplot(2, 2, 4)
    # imshow(img, cmap=:gray)

    return Ω


end

main()