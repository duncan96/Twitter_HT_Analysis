function signm = signMatrix(X)
    signm = ((X < 0) .* -2) + 1;