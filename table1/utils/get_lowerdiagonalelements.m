function elementsBelowDiagonal = get_lowerdiagonalelements (A)
% Logical indexing to select elements below the diagonal (excluding diagonal)

lowerTriangle = tril(true(size(A)), -1);
elementsBelowDiagonal = A(lowerTriangle);

