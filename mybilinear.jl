function bilinear(f, p, distance)
    rows, cols = size(f, 1, 2)

    x, y = p 

    if !( 0 < x < rows && 0 < y < cols)
        return 0
    end 
    
    # distancia de pixel nuevo
    # con el pixel de la imágen original
    dx, dy = distance
    
    try
        A, B = f[x, y],     f[x + 1, y]
        C, D = f[x, y + 1], f[x + 1, y + 1]
        return  A * (1 - dx) * (1 - dy) +  B * dx * (1 - dy) +
                C * dy * (1 - dx)       +  D * (dx  * dy)
    end
    
    try  return f[x, y] end
    
    return 0
end
