% Le imagem e converte para o espaço de cores YCbCr
% e mantém apenas o canal Y
original = imread('mundo.jpg');
a = rgb2ycbcr(original);
a = (a(:,:,1));

% Calcula a entropia local da imagem e redimensiona os valores de entropia
% para o intervalo [0,1]
E = entropyfilt(a);
Eim = rescale(E);

% Escolhe um valor de limiar e binariza a imagem
limiar = 0.62;
BW1 = imbinarize(Eim,limiar);

% Remove as regioes menores que 2000 pixels na imagem binarizada
% trocar este valor caso necessario, para melhorar a segmentação
BWao = bwareaopen(BW1,2000);

% Define um elemento estruturante 9x9 e fecha os buracos na imagem
nhood = ones(9);
closeBWao = imclose(BWao,nhood);
% Preenche os buracos na imagem fechada
mask = imfill(closeBWao, 'holes');

% Cria duas versões do canal Y da imagem:
% textureTop mantém os pixels fora da máscara como 0
% textureBottom mantém os pixels dentro da máscara como 0.
textureTop = a;             % Cria uma cópia do canal Y
textureTop(mask) = 0;       % Define como zero os pixels fora da máscara
textureBottom = a;          % Cria outra cópia do canal Y
textureBottom(~mask) = 0;   % Define como zero os pixels dentro da máscara
% Cria uma matriz de rótulos para a segmentação
L = mask+1;
figure
subplot(1,2,1);
imshow(original);
title('Imagem Original');
subplot(1,2,2);
imshow(labeloverlay(original,L));
title('Segmentação por textura');
