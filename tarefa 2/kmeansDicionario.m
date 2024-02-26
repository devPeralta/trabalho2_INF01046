% Função que cria vetores de dimensão L a partir da imagem
function[novaImagem]=kmeansDicionario(entradaImagem,L,K)



    % L representa os tamanhos dos blocos utilizados na técnica de agrupamento, organizados de uma forma matricial
    % Para uma imagem, L é um número inteiro que é uma potência de 4. Por exemplo, L=4 representa blocos de 2x2, L=16 representa blocos de 4x4, e assim por diante
    % K representa o tamanho do dicionário. Quanto maior K, mais tempo é necessário para o processamento
    % Rearranja os valores dos pixels da imagem de entrada da forma de matriz para uma forma de array a ser armazenado na palavra "s" de arrays
    s=cell(1,numel(entradaImagem)/L);
    row=size(entradaImagem,1);
    for j=1:length(s)
       for i=1:sqrt(L)
           % Calcula os índices para acessar os blocos na imagem
           inicioLinha = (i + floor((j - 1) * sqrt(L) / row) * sqrt(L) - 1) * row + 1 + rem(j - 1, row / sqrt(L)) * sqrt(L);
           fimLinha = (i + floor((j - 1) * sqrt(L) / row) * sqrt(L) - 1) * row + (rem(j - 1, row / sqrt(L)) + 1) * sqrt(L);
           % Extrai o bloco da imagem e adicioná-lo ao vetor s{j}
           bloco = entradaImagem(inicioLinha:fimLinha);
           s{j} = [s{j}, bloco];
       end
    end
    
    % Chama a função de agrupamento kmeansAgrupamento com os parâmetros fornecidos
    [dicionario,numGrupos]=kmeansAgrupamento(s,L,K);
    % Reconstroi a imagem usando os vetores do dicionário (Centros do Cluster)
    sNovo=cell(1,length(s));
    for i=1:length(sNovo)
       sNovo{i}=dicionario{numGrupos(i)};
    end
    novaImagem=zeros(size(entradaImagem));
    for j=1:length(sNovo)
       for i=1:sqrt(L)
    
    % Calcula os índices para acessar os pixels na nova imagem
    inicioNovaLinha = (i + floor((j - 1) * sqrt(L) / row) * sqrt(L) - 1) * row + 1 + rem(j - 1, row / sqrt(L)) * sqrt(L);
    fimNovaLinha = (i + floor((j - 1) * sqrt(L) / row) * sqrt(L) - 1) * row + (rem(j - 1, row / sqrt(L)) + 1) * sqrt(L);
           % Calcula os índices para acessar os pixels no bloco sNovo{j}
           inicioBloco = 1 + (i - 1) * sqrt(L);
           fimBloco = i * sqrt(L);
           % Atribui os valores do bloco sNovo{j} à nova imagem
           novaImagem(inicioNovaLinha:fimNovaLinha) = sNovo{j}(inicioBloco:fimBloco);
       end
    end
    