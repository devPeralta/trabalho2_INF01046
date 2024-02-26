% Lê os parâmetros de entrada L e K
L=4;
K=256;

% Le a Imagem de Entrada
imagem=imread('lenna.jpg');
row=size(imagem,1);
col=size(imagem,2);
figure, imshow(imagem);
title('Imagem de entrada');

% Verifica se a imagem de entrada é uma imagem em tons de cinza ou colorida e
% implementa k-means para 3 componentes (R, G, B) se for uma imagem colorida
restoRow=rem(row,sqrt(L));
restoCol=rem(col,sqrt(L));
imagemNova=zeros(row+restoRow,col+restoCol);
if length(size(imagem))==3
   for i=1:3

% Verifica as dimensões da imagem e preenche as linhas/colunas de acordo
       imagemNova(1:row,1:col)=imagem(:,:,i);
       if restoRow~=0
           rowExtra=imagem(end,:,i);
           for j=1:restoRow
               rowExtra(j,:)=rowExtra(1,:);
           end
           imagemNova(row+1:end,1:col)=rowExtra;
       end
       if restoRow~=0 && restoCol~=0
           colExtra=imagemNova(:,col);
           for j=1:restoCol
               colExtra(:,j)=colExtra(:,1);
           end
           imagemNova(1:end,col+1:end)=colExtra;
       elseif restoCol~=0
           colExtra=imagem(:,col);
           for j=1:sqrt(L)-restoCol
               colExtra(:,j)=colExtra(:,1);
           end
           imagemNova(1:row,col+1:end)=colExtra;
       end
       if i==1
           imagemKmeans=zeros(size(imagemNova,1),size(imagemNova,2),3);
       end
       imagemKmeans(:,:,i)=kmeansDicionario(imagemNova,L,K);
   end
   imagemKmeans=imagemKmeans(1:end-restoRow,1:end-restoCol,1:3);
else

   % Verifica as dimensões da imagem e preenche as linhas/colunas de acordo 
   imagemNova(1:row,1:col)=imagem;
   if restoRow~=0
       rowExtra=imagem(end,:);
       for j=1:restoRow
           rowExtra(j,:)=rowExtra(1,:);
       end
       imagemNova(1:row,1:col)=Img;
       imagemNova(row+1:end,1:col)=rowExtra;
   end
   if restoRow~=0 && restoCol~=0
       colExtra=imagemNova(:,col);
       for j=1:restoCol
           colExtra(:,j)=colExtra(:,1);
       end
       imagemNova(1:end,col+1:end)=colExtra;
   elseif restoCol~=0
       colExtra=imagem(:,col);
       for j=1:sqrt(L)-restoCol
           colExtra(:,j)=colExtra(:,1);
       end
       imagemNova(1:row,1:col)=imagem;
       imagemNova(1:row,col+1:end)=colExtra;
   end
   imagemKmeans=kmeansDicionario(imagemNova,L,K);
end

% Exibe a imagem agrupada pelo k-means
imagemKmeans=uint8(imagemKmeans);
figure, imshow(imagemKmeans);

title('Imagem comprimida por quantização vetorial (k-means)');
% Exibe a memória ocupada pela imagem de entrada e pela imagem de saída
fprintf('Tamanho da imagem de entrada = %d bytes',numel(imagem));
disp(' ');
fprintf('Tamanho da imagem de saida = %d bytes',K*L+numel(imagemNova)/L);
disp(' ');

% PSNR
MSE = sum(sum((double(imagem) - double(imagemKmeans)).^2)) / (size(imagem,1) * size(imagem,2));
PSNR = 10 * log10((255^2) / MSE);
fprintf('PSNR: %.2f\n', PSNR);
