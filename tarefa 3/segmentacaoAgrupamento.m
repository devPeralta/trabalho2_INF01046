% Carrega uma imagem RGB e exibe
imagem=imread('mundo.jpg');
% Exibe a imagem original
subplot(1,2,1);
imshow(imagem);
% Separa os canais de cores
redChannel=imagem(:, :, 1);
greenChannel=imagem(:, :, 2);
blueChannel=imagem(:, :, 3);
% Faz um cast dos canais para double
canaisDouble=double([redChannel(:), greenChannel(:), blueChannel(:)]);
% Define o numero de clusters do algoritmo
numClusters=5;
% Aplica o algoritmo k-means
[m, n]=kmeans(canaisDouble,numClusters);
% Redimensiona os rótulos dos clusters para o tamanho da imagem
m=reshape(m,size(imagem,1),size(imagem,2));
% Normaliza os centróides de 0 a 1 para uso na função label2rgb
n=n/255;
% Cria uma imagem onde cada pixel é colorido de acordo com o cluster a que
% pertence usando centróides normalizados
novaImagem=label2rgb(m,n);
% Exibe a imagem segmentada
subplot(1,2,2);
imshow(novaImagem);
