include("tools.jl")
using MultivariateStats
using GLM, RDatasets

function myPCA(x)
    M = PCA
    pca_ = fit(PCA, x)

    println(">>>>>>>>>>>>>>  ", principalvars(pca_))

    return projection(pca_)
end

function createMatrix(numPersons = 40, numFaces = 10)
    imname =  "img/att_faces/faces_1 (1).pgm"
    x = imgLoad(imname, 1)
    rows, cols = size(x, 1, 2)

    myMatrix = zeros(rows * cols, numPersons * numFaces)

    k = 1
    for i = 2:numPersons
        for j = 1:numFaces
            imname =  "img/att_faces/faces_$i ($j).pgm"
            x = imgLoad(imname, 1)
            myMatrix[:, k] = reshape(x, rows*cols)
            k += 1
        end
    end

    return myMatrix
end

function main()
    # read face and create matrix
    X = createMatrix()

    # Calculate PCs
    X_pca = myPCA(X)

    println("Tamaño de matriz de diseño:", size(X_pca, 1, 2))
    
    # show eigen faces
    for i =[1,100, 300]
        a = reshape(X_pca[:,i], (112, 92))
        imshow(a)
    end

    return

    Y_real = imgLoad("img/me.pgm", 1)
    Y_real = reshape(Y_real, 112 * 92)

    
    # make a regression
    b = inv(X_pca' * X_pca) * (X_pca' * Y_real)

    # estimate real values
    Y_estim = X_pca * b 

    # print std error
    print(std(abs.(Y_real - Y_estim)))


    # show real and estimated image
    a = reshape(Y_estim, (112, 92))
    b = reshape(Y_real, (112, 92))
    imshow(a)
    imshow(b)

end


main()