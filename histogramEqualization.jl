include("tools.jl")
plotlyjs(size = (1280, 500))

function calcHist(img)
    h = zeros(Int32, 256)
    for pixel in img
        h[pixel+1] += 1.0
    end

    return h
end

function histEqualization(img)
    h = calcHist(img)
  
    p = h / sum(h)
    
    return map( x -> sum(p[1:x]), img)

end

function main()
    imagename = "Fig3.15(a)3.jpg"
    # Load image
    img = imgLoad("img/book/$imagename")
    img = Int32.(floor.(img))

    # Process image
    newimg = histEqualization(img)
    newimg = Int32.(floor.(newimg*255))
    
    # Show image 
    # imshow(newimg)

    # Plot histogram
    h  = calcHist(img)
    h2 = calcHist(newimg)
    
    # Original image histogram
    hst1 =  bar(h,  color=:blue,
                    label = "Original")
    # Transformed image histogram
    hst2 =  bar(h2, color=:red,
                    label = "Ecualizada")

    # save("equlizada_$imagename", setGray(newimg, true))
    plot(hst1, hst2)
    savefig("hist_$imagename.pdf")

end

# main()