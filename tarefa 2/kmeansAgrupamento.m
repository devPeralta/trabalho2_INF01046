% Função que aplica a técnica de agrupamento do k-means
function[dicionario,numGrupos]=kmeansAgrupamento(s,L,K)

    % Inicializa os k-vetores (palavras) do dicionário
    dicionario=cell(1,K);
    indiceAleatorio=randsample(length(s),K);
    for i=1:K
       dicionario{i}=s{indiceAleatorio(i)};
    end
    
    % Algoritmo iterativo para atribuir os números de cluster aos vetores de saída da fonte
    % Inicializa os valores de distorção. O primeiro elemento é o valor antigo e
    % o segundo elemento é o valor atual.
    distanciaVet=cell(1,length(s));
    numGrupos=zeros(1,length(s));
    distorcao=[0 0];
    iteracao=0;
    while(iteracao<=2 || (distorcao(1)-distorcao(2))/distorcao(2) > 0.9)
       iteracao=iteracao+1;
       distorcao(1)=distorcao(2);
       distorcao(2)=0;
       for i=1:length(s)
    
    % distanciaVet é um array de palavras em que cada palavra corresponde a cada vetor de entrada
    % Cada palavra é um array de distâncias do vetor de entrada de cada um dos K-vetores do dicionário
    distanciaVet{i}=dist(s{i},reshape(cell2mat(dicionario),L,length(dicionario)));
           numGrupos(i)=find(distanciaVet{i}==min(distanciaVet{i}),1);
           distorcao(2)=distorcao(2)+min(distanciaVet{i});
       end
       distorcao(2)=distorcao(2)/length(s);
    
    % Atualiza os vetores do dicionário substituindo cada um deles pela média do conjunto correspondente de vetores de entrada
       for i=1:K
           temp=reshape(cell2mat(s),L,length(s));
           dicionario{i}=mean(temp(:,numGrupos==i),2);
       end
    end
    