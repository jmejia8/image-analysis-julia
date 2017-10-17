include("tools.jl")
# gr()

function main()
    polar(r, θ, center) = center[1] + r .* cos.(θ), center[2] + r .* sin.(θ)

    imwidth  = 500
    imheight = 500

    r = 50
    θ = linspace(0, 2π , 6r)
    c = ( div(imwidth, 2), div(imheight, 2))

    x, y = polar(r, θ, c)
    x = floor.(Int32, x)
    y = floor.(Int32, y)

    F = zeros(imwidth, imheight)

    for i = 1:length(x)
        F[x[i], y[i]] = 1.0
    end

    # center
    F[c[1], c[2]] =  mean(F)


    imshow(F)
    # save("tmp/img/Ffourier$r.png",setGray(F, true))

    F = ifftshift(F)

    f = real(ifft(F))
    f = ifftshift(f)
    imshow(setGray(f))
    # save("tmp/img/fourier$r.png",setGray(f, true))
    # imshow(log.(1+abs.(f)))


end

main()