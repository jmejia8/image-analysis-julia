include("tools.jl")

function findLabel(pxl, labels)
    # Find label at globals labels array
    for i in 1:length(labels)
        if pxl in labels[i]
            return i
        end
    end

    return 0
end

function mergeLabels!(labels, a, b)
    # For two equals labels merge them
    if a * b  > 0 && a != b
        labels[a] = union(labels[a], labels[b])
        empty!(labels[b])
    end
end

function components4(img, tol = 0.5)
    """
        Inputs:
        Procedure: components, 4 neighbors
            img: gray scale image (normalized)
            tol: background tolerance
        Outputs:
            labels: Array with pixels labels
    """
    # image dimensions
    rows, cols = size(img, 1, 2)

    # component labels
    labels   = []

    # Current label
    newLabel = Set{Int32}()

    # for each pixel, set a label
    for i in 1:rows-1
        for j in 1:cols-1

            # background check
            if img[i, j] > tol
                if !isempty(newLabel)
                    push!(labels, newLabel)
                    newLabel = Set{Int32}()
                end
                continue
            end

            # pixel ids'
            current = (i - 1) * cols + j
            right   = current + 1

            # get current pixel label (if exists)
            a = findLabel(current, labels)
            b = 0

            # get right pixel label (if exists)
            if img[i, j+1] < tol
                b = findLabel(right, labels)
            end

            # find minimum label (if exists)
            if a > 0
                label = labels[a]
            elseif b > 0
                label = labels[b]
            else
                label = newLabel
            end

            push!(label, current)

            if img[i, j+1] < tol
                push!(label, right)
            end

            if img[i + 1, j] < tol
                push!(label, current + cols)
            end

            # merge equals labels
            mergeLabels!(labels, a, b)
        end
    end


    labels = [ label for label in labels if !isempty(label) ]
    return labels
end

function components8(img, tol = 0.5)
    """
        Procedure: components, 8 neighbors
        Inputs:
            img: gray scale image (normalized)
            tol: background tolerance
        Outputs:
            labels: Array with pixels labels
    """
    # image dimensions
    rows, cols = size(img, 1, 2)

    # component labels
    labels   = []

    # Current label
    newLabel = Set{Int32}()

    # for each pixel, set a label
    for i in 1:rows-1
        for j in 2:cols-1

            # background check
            if img[i, j] > tol
                if !isempty(newLabel)
                    push!(labels, newLabel)
                    newLabel = Set{Int32}()
                end
                continue
            end

            # pixel ids
            current = (i - 1) * cols + j
            left    = current - 1
            right   = current + 1

            # get neighbor labels (if exists)
            a = findLabel(current, labels)
            b, c = -1, -1

            if img[i, j - 1] < tol
                b = findLabel(left, labels) end

            if img[i, j + 1] < tol
                c = findLabel(right, labels) end

            # find minimum label (if exists)
            if a > 0
                label = labels[a]
            elseif b > 0
                label = labels[b]
            elseif c > 0
                label = labels[c]
            else
                label = newLabel
            end

            push!(label, current)

            if b >= 0
                push!(label, left) end
            if c >= 0
                push!(label, right) end

            # bottom
            if img[i + 1, j] < tol
                push!(label, current + cols) end

            # bottom left
            if img[i + 1, j - 1] < tol
                push!(label, current + cols - 1) end

            # merge equals labels
            mergeLabels!(labels, a, b)
            mergeLabels!(labels, a, c)
            mergeLabels!(labels, b, c)



        end
    end

    labels = [ label for label in labels if !isempty(label)]
    return labels
end

function test()
    name = "img/bin4.jpg"
    img = imgLoad(name, 1)

    rows, cols = size(img, 1, 2)

    labels = components4(img)
    println("labels = ", length(labels))

    newimg = ones(rows, cols)
    for label in labels
        r = 0.5 * rand()
        for i in label
            newimg[ 1 + div(i, cols),  1+(i % cols)] = r
        end

    end

    imshow(newimg)

end

test()
