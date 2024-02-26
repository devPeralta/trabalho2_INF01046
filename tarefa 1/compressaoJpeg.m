function [I_comprimida, taxa_compressao] = compressaoJpeg(I, tabela)

    [sx, sy] = size(I);
    
    % cria blocos 8x8
    blocos = zeros(floor(sx / 8), floor(sy / 8), 8, 8);
    I_comprimida = I;
    
    % aplica DCT nos blocos
    for i = 1 : floor(sx / 8)
        for j = 1 : floor(sy / 8)
            blocos(i, j, :, :) = dct2(I(8 * (i - 1) + 1 : 8 * i, 8 * (j - 1) + 1 : 8 * j));
        end
    end
    
    % quantiza os coeficientes
    for i = 1 : floor(sx / 8)
        for j = 1 : floor(sy / 8)
            blocos(i, j, :, :) = round(squeeze(blocos(i ,j, :, :)) ./ tabela);
        end
    end
    
    % calcula a taxa de compressao
    taxa_compressao = sum(blocos(:) == 0) / (sx * sy);
    
    % inverso da quantizacao
    for i = 1 : floor(sx / 8)
        for j = 1 : floor(sy / 8)
            blocos(i, j, :, :) = squeeze(blocos(i ,j, :, :)) .* tabela;
        end
    end
    
    % aplica IDCT nos blocos
    for i = 1 : floor(sx / 8)
        for j = 1 : floor(sy / 8)
            blocos(i, j, :, :) = idct2(squeeze(blocos(i, j, :, :)));
        end
    end
    
    % gera a imagem comprimida
    for i = 1 : floor(sx / 8)
        for j = 1 : floor(sy / 8)
            I_comprimida(8 * (i - 1) + 1 : 8 * i, 8 * (j - 1) + 1 : 8 * j) = squeeze(blocos(i, j, :, :));
        end
    end
    
    I = imread('cameraman.tif');
    
    table = [ ...
        16 11 10 16 24 40 51 61; ...
        12 12 14 19 26 58 60 55; ...
        14 13 16 24 40 57 69 56; ...
        14 17 22 29 51 87 80 62; ...
        18 22 37 56 68 109 103 77; ...
        24 35 55 64 81 104 113 92; ...
        49 64 78 87 103 121 120 101; ...
        72 92 95 98 112 100 103 99];
    
    factor = 1.0;
    [I_comp, taxa_c] = compressaoJpeg(I, table * factor);
    figure, imshow(I), title('Imagem original'), figure,
    imshow(uint8(I_comp)), title('Imagem comprimida');
    
    fprintf('taxa de compressão: %.2f\n%', taxa_c);
    disp('');
    
    I_max = max(max(double(I)));
    I_min = min(min(double(I)));
    
    A = I_max - I_min;
    
    psnr = 10 * log10((A^2) / (std2(double(I) - double(I_comp))^2));
    
    fprintf('PSNR: %.2f\n', psnr);
    
    