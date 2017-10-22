include("transformations.jl")
include("procChido.jl")



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


    A = coors



    # subplot(2, 5, 1)
    # imshow(img, cmap=:gray)
    # plot(A[3:end,1], A[3:end,2], marker=:o, lw=0, color=:red)
    # plot(A[1:2,1], A[1:2,2], marker=:o, lw=0, color=:blue)
    # return

    errores = 0.
    for i in 1:5

        Txy = [0,0]#[0.2rows*rand() , 0.2cols*rand()]
        S   = rand()
        θ   = 2π*rand()

        Sxy = [S, S]
        imcenter = [rows, cols] / 2

        imgTrans = mytranform(img, Txy, Sxy, θ)
        
        B = coorTrans(coors, Txy, Sxy, θ, imcenter)

        subplot(2, 5, i)
        imshow(imgTrans, cmap=:gray)
        plot(B[3:end,1], B[3:end,2], marker=:o, lw=0, color=:red)
        plot(B[1:2,1], B[1:2,2], marker=:o, lw=0, color=:blue)





        d, Z, transform = procrustes(A, B, true, -1)
        R, s, t = transform

        # C = Z

        println("rota = ", R)
        println("escala = ", s)
        println("trans", t)

        C = (s*R) * B' + t'
        C = C'

        errores += norm(C - A)




        subplot(2, 5, 5+i)
        imshow(img, cmap=:gray)
        plot(C[3:end,1], C[3:end,2], marker=:o, lw=0, color=:red)
        plot(C[1:2,1], C[1:2,2], marker=:o, lw=0, color=:blue)


    end

    println("Error", errores/5)

end

# main()


function test2()
    original = [   
      239.3569  114.8566;
      175.5802   66.7326;
      147.2351   11.6628;
      117.6681   68.7171;
       76.8609  122.7946;
       47.0496  187.2907;
      107.1609  141.6473;
       96.1649  203.1667;
       69.5302  295.9419;
      125.7319  294.9496;
      142.5923  248.3140;
      131.3520  228.9651;
      147.2351  189.2752;
      154.8101  226.4845;
      163.8512  307.8488;
      197.5722  316.2829;
      196.3504  224.9961;
      197.0835  124.7791;
      221.5190  207.1357]


    rb1 = [
      159.6972  119.3217;
      155.0544   70.2054;
      169.7157   35.4767;
      131.5964   43.4147;
       91.0335   49.3682;
       50.7149   58.2984;
       95.6762   68.2209;
       63.4214   90.5465;
        9.6633  111.8798;
       31.4109  138.6705;
       60.9778  128.2519;
       65.8649  113.8643;
       90.3004  106.4225;
       76.3722  122.7946;
       41.1851  160.9961;
       51.9367  181.3372;
       91.7665  142.1434;
      136.9722  104.4380;
      111.5593  145.6163;
    ]
    rb2 = [
      209.3012  173.3992;
      186.0875  189.2752;
      162.8738  192.2519;
      179.7343  210.1124;
      195.1286  229.4612;
      214.9214  249.3062;
      205.6359  221.5233;
      227.3835  232.9341;
      258.4165  254.2674;
      263.5480  233.4302;
      249.1310  222.0194;
      239.6012  222.5155;
      226.1617  214.5775;
      240.5786  215.0736;
      271.1230  219.0426;
      278.9423  205.1512;
      246.4431  202.1744;
      211.2560  189.2752;
      240.0899  189.7713;
    ]
    rb3 = [
      268.2431  169.8294;
      250.0910   94.2609;
      264.0541   33.6195;
      205.4090   55.0773;
      139.7823   70.9373;
       76.2500   95.1939;
      148.8583   99.8586;
      102.0818  143.7070;
       22.4919  196.8848;
       62.9850  232.3367;
      105.5726  210.8790;
      105.5726  181.9577;
      148.1601  170.7624;
      131.4044  200.6166;
       83.2316  264.9898;
      105.5726  292.9781;
      159.3306  226.7391;
      227.0518  156.7682;
      194.2385  226.7391;
    ]

    rb4 = [

      153.8327  190.2674;
      116.6907  201.6783;
       86.1464  203.1667;
      100.0746  229.9574;
      112.5367  260.7171;
      132.5738  290.9806;
      129.1528  254.7636;
      153.8327  277.0891;
      185.3544  313.8023;
      202.4593  289.9884;
      187.0649  268.6550;
      175.0915  270.6395;
      161.8964  250.2984;
      178.0238  258.2364;
      218.3423  274.1124;
      231.7819  261.2132;
      189.2641  240.8721;
      149.6786  211.1047;
      189.7528  219.5388;
    ]
    rb5 = [
       97.1423  166.9496;
      135.5060  196.2209;
      155.2988  231.9419;
      172.1593  195.7248;
      195.1286  160.9961;
      212.7222  120.8101;
      178.0238  152.5620;
      183.1552  112.3760;
      199.0383   54.8256;
      163.6069   56.3140;
      154.5657   85.0891;
      160.6746   97.4922;
      152.8552  121.3062;
      147.2351  101.9574;
      141.8593   47.8798;
      121.0891   45.3992;
      123.5327   98.9806;
      122.5552  158.0194;
      106.9165  112.3760;
    ]

    modif = [rb1, rb2, rb3, rb4, rb5]

    imgOrig = imgLoad("img/robotis.jpg",1)

    # imshow(imgOrig, cmap=:gray)
    # plot(original[1:3,1], original[1:3,2], marker=:o, lw=0, color=:blue)

    # plot(original[4:end,1], original[4:end,2], marker=:o, lw=0, color=:red)

    # return
    for imn in 1:length(modif)

        img = imgLoad("img/robotisM$imn.jpg",1)
        pts = modif[imn]
        
        subplot(2, 5, imn)
        imshow(img, cmap=:gray)
        plot(pts[1:3,1], pts[1:3,2], marker=:o, lw=0, color=:blue)
        plot(pts[4:end,1], pts[4:end,2], marker=:o, lw=0, color=:red)

        A = original
        B = pts
        d, Z, transform = procrustes(A, B, true, -1)
        R, s, t = transform


        C = (s*B) * R + t

        subplot(2, 5, 5+imn)
        imshow(imgOrig, cmap=:gray)
        plot(C[1:3,1], C[1:3,2], marker=:o, lw=0, color=:blue)
        plot(C[4:end,1], C[4:end,2], marker=:o, lw=0, color=:red)


    end

end

test2()