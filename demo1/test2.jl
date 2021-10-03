A= 1:9
sz = (3,3)
# A[3,2]

i = 3
j = 2
reshape(A, (3,3))[3,2]
A[i + (j-1)*3]

A = rand(1000, 100)
B = rand(1000, 100)
C = rand(1000, 100)

using BenchmarkTools
function inner_rows!(C, A, B)
    for i in 1:1000, j in 1:100
        C[i,j] = A[i, j] + B[i, j]
    end
end

@btime inner_rows!(C, A, B)

function inner_cols!(C, A, B)
    for j in 1:100, i in 1:1000
        C[i,j] = A[i, j] + B[i, j]
    end
end
@btime inner_cols!(C, A, B)

function inner_alloc!(C, A, B)
    for j in 1:100, i in 1:100
        val = [ A[i,j] + B[i, j]]
        C[i, j] = val[1]
    end
end
@btime inner_alloc!(C, A, B)

function inner_noalloc!(C, A, B)

    for j in 1:100, i in 1:100
        val =  A[i,j] + B[i, j]
        C[i, j] = val[1]
    end
end
@btime inner_noalloc!(C, A,B)

using StaticArrays
val = SVector{1,Float64}(1.)
typeof(val)

function static_inner_alloc!(C, A, B)
    for j in 1:100, i in 1:100
        val = @SVector [A[i,j] + B[i,j]]
        C[i,j] = val[1]
    end
end
@btime static_inner_alloc!(C, A, B)