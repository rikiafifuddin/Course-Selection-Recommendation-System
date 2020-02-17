function [output] = princompal(data, dim)
    covar = cov(data);
    [eigvec, eigval] = eig(covar);
    [nilai, indeks] = sort(diag(eigval), 'descend');
    vrow = eigvec(:, indeks(1:dim))';
    output = vrow * data';
    output = output';
end

