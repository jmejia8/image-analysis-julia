include("tools.jl")

function gammaTransform(img, c = 1, γ = 0.5)
    return imrepair(c * img .^ γ)
end

function logTransform(img, c = 1)
    return  imrepair(c * imsc(log.( 1  + img)))
end

function main()
    img = imgLoad("img/book/Fig3-08(a).jpg", 1)
    println(maximum(img))

    # img2 = logTransform(img, 1.2) # 1.2
    img2 = gammaTransform(img, 1, 0.7)
    save("img/transformgamma12.png", img2)
    imshow(img2)
    

    println("done!!")
end

# main()