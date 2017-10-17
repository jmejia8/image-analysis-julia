using Colors, Images, ImageView, GtkUtilities, GtkReactive

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

function setGray(m, imscale = false)
    if imscale
        mmin, mmax = minimum(m), maximum(m)
        return convert(Array{Gray, 2}, (m - mmin) / (mmax - mmin))
    end

    return convert(Array{Gray, 2}, m)
end

function int(x)
    return convert(Array{Int32,1}, floor.(x))
end

function imsc(m)
    return m / maximum(m)
end

function imrepair(m)
    return map( x->begin if x <= 1 return  x else 1.0 end end , m)
end
