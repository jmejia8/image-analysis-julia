using Colors, Images, Plots, ImageView, GtkUtilities

function getImgGray(name)
    img = load(name)

    return convert(Array{Gray}, img)
end

function imgLoad(name, sc = 255)
    img = getImgGray(name)
    return convert(Array{Float32}, img) * sc
end


function img2Vector(img)
   return convert(Array{Float32}, rawview(channelview(img)))
end

function vector2Img(v, row, cols)
    v = convert(Array{Float32}, v)
    v /= maximum(v)
    m = reshape(v, row, cols)
    return convert(Array{Gray, 2}, m)
end

function setGray(m)
     m /= maximum(m)
     #m = convert()
     return convert(Array{Gray, 2}, (m))
end

function int(x)
    return convert(Array{Int32,1}, floor.(x))
end
