include("spatial-filtering.jl")
plotly(reuse=true, ratio=1, leg=false, size=(1280, 720))
function sobelFilter(img)
    Gy = [ 1   2  1;
            0   0  0;
           -1  -2  -1.0]

    return  spatialFilter(img, Gy'),  spatialFilter(img, Gy)
end

function main()
    # Opening image
    imagename = "Edge_Operators.png"
    img = imgLoad("img/$imagename", 1)

    # derivates 
    Gx, Gy = sobelFilter(img)
    mag = sqrt.( (Gy - Gx).^2 )
    
    # Gradiente
    ∇f(x, y) = Gx[x,   y], -Gy[x,   y]

    
    # Original image 
    p0 = heatmap(img, title = "Imagen Original", color=:gray)
    
    # Gradient maginitude
    px = heatmap(Gx, title = "Gx", color=:gray)
    py = heatmap(Gy, title = "Gy", color=:gray)

    # Vectorial field
    Gx = Gx'
    Gy = Gy'
    rows, cols = size(Gx, 1, 2)
    pts = vec([(i, j) for i = 1:rows,  j = 1:cols])
    p2 = quiver(pts, quiver=∇f, title = "Campo Vectorial", xlimits = (90, 110))

    m = heatmap(mag, color=:gray)
    quiver!(pts, quiver=∇f, title = "Campo Vectorial y magnitud del gradiente", color=:red)
    # p2 = plot(m)
    plot(p0, px, py, p2,m, layout=(5,1))
    # png("salida.png")
end

# main()