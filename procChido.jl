function procrustes(X, Y, doScaling = true, doReflection = "best_")
    n, m   = size(X, 1, 2);
    ny, my = size(Y, 1, 2);

    if ny != n
        error("InputSizeMismatch");
    elseif my > m
        error("TooManyColumns'");
    end

    # % Center at the origin.
    muX = mean(X,1);
    muY = mean(Y,1);
    X0 = X - repmat(muX, n, 1);
    Y0 = Y - repmat(muY, n, 1);

    ssqX   = sum(X0 .^ 2, 1);
    ssqY   = sum(Y0 .^ 2, 1);
    constX = false#all(ssqX <= abs(eps((X))*n*muX) .^ 2);
    constY = false#all(ssqY <= abs(eps((X))*n*muY) .^ 2);
    ssqX   = sum(ssqX);
    ssqY   = sum(ssqY);

    transform = ()

    # % The "centered" Frobenius norm.
    normX = sqrt(ssqX); #% == sqrt(trace(X0*X0'))
    normY = sqrt(ssqY); #% == sqrt(trace(Y0*Y0'))

    # % Scale to equal (unit) norm.
    X0 = X0 ./ normX;
    Y0 = Y0 ./ normY;

    # % Make sure they're in the same dimension space.
    if my < m
        Y0 = [Y0 zeros(n, m-my)];
    end

    # % The optimum rotation matrix of Y.
    A = X0' * Y0;
    L, D, M = svd(A);
    T = M * L';
    if doReflection == "best" #% 'best'
        println("algo")
        # % Let the data decide if a reflection is needed.
    else
        haveReflection = det(T) < 0;
        # % If we don't have what was asked for ...
        if doReflection != haveReflection
            #% ... then either force a reflection, or undo one.
            M[:,end] = -M[:,end];
            D[end,end] = -D[end,end];
            T = M * L';
        end
    end
    
    # % The minimized unstandardized distance D(X0,b*Y0*T) is
    # % ||X0||^2 + b^2*||Y0||^2 - 2*b*trace(T*X0'*Y0)
    traceTA = sum(diagm(D)); #% == trace(sqrtm(A'*A)) when doReflection is 'best'
    
    if doScaling
        # % The optimum scaling of Y.
        b = traceTA * normX ./ normY;
        
        # % The standardized distance between X and b*Y*T+c.
        d = 1 - traceTA .^ 2;

        # if nargout > 1
            Z = normX*traceTA * Y0 * T + repmat(muX, n, 1);
        # end
   
    else #% if !doScaling
        b = 1;
        
        #% The standardized distance between X and Y*T+c.
        d = 1 + ssqY/ssqX - 2*traceTA*normY/normX;

        # if nargout > 1
            Z = normY*Y0 * T + repmat(muX, n, 1);
        # end
    end
    
    if true #nargout > 2
        if my < m
            T = T[1:my,:];
        end
        c = muX - b*muY*T;
       transform = (T, b, repmat(c, n, 1));
    end


    return  d, Z, transform
end

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
 chuecos = [533.199   194.913;
  463.392   171.61 ;
  517.25    269.81 ;
  297.05    128.258;
  411.162   398.707;
  292.082   327.153;
  178.66    286.712;
  199.169   355.301;
  213.596   381.604;
  252.066   451.747;
   57.4641  336.074;
   88.721   393.066;
  122.382   454.441;
  156.044   515.816;
  417.092   201.565;
  474.797   306.78 ]


procrustes(coors, chuecos)