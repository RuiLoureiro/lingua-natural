Nomes: 
Nuno Cordeiro nº?
Rui Loureiro nº 80845


Para o tipo de problema descrito, o método abordado nas aulas que nos pareceu mais adequado foi o de número mínimo de edições, usando as palavras como tokens. 
Assim, optámos numa primeira abordagem por usar a função da biblioteca nltk, com todos os parâmetros default.

Decidimos que esta configuração era adequada para obter o baseline,

tendo obtido uma accuracy de ~71.43

O objetivo seria agora otimizar o algoritmo de número mínimo de edições, bem como processar os ficheiros de entrada.

Começámos pelo preprocessamento do ficheiro de treino (QuestoesConhecidas) bem como o de NovasQuestoes.

Tal como foi referido na introdução, foram-nos disponibilizados ficheiros com listas (tokens) de nomes de atores, nomes de filmes, géneros de filmes, posições na área do cinema, nomes de personagens e keywords relacionadas com filmes.

Usando as seguintes frases como exemplo:
What's the actor in Titanic
What's the actor in Reservoir Dogs

Para alguém que saiba que 'Titanic' e 'Reservoir Dogs' são nomes de filmes, estas duas queries são exatamente iguais, do ponto de vista do projeto. 

Assim, decidimos substituir nos dois ficheiros referidos, usando dicionários, todas as ocorrências de nomes de filmes por _movie_, atores por _actor_, e assim succesivamente para todos as listas.

Com esta alteração obtemos uma accuracy de ~73.81

Notámos, no entanto, que estava a ser substituido o token _keyword_ em grande parte das sentences, em muitos sitios erradamente (do ponto de vista semântico), pois este ficheiro contém strings muito gerais. Retirámos então a substituição de keywords, tendo a accuracy subido para ~76.19%.
Sendo que não vimos uma melhor maneira de utilizar o ficheiro de keywords, decidimos não o utilizar.

A ordem pela qual substituimos é também relevante, pois quando corremos o programa tendo definido a ordem aleatoriamente, notámos que as listas com strings mais pequenas e mais gerais, como é o caso de 'list_characters', estavam a substituir partes de ocorrências de strings maiores e mais específicas, como é o caso de 'list_characters'. Assim, definimos a ordem : movies, people, characters, companies, genres, jobs. 
Com esta alteração, a accuracy subiu para 85.71%.

Não podemos dizer que esta ordem, apesar de fazer sentido, é óptima, pois com este corpora, a accuracy manteve-se para ordens diferentes, não tendo conseguido subir o accuracy mais do que o referido.

Decidimos agora retirar toda a pontuação da frase, pois não nos parecia adicionar significado à mesma, tendo a accuracy subido para ~88.1%.

Decidimos de seguida retirar as 'stop words', isto é, aquelas palavras muito comuns em frases, que não adicionam significado à mesma, como é o caso de 'the', 'is', 'are'. Para este efeito, usámos a lista de stopwords fornecida pela biblioteca nltk.

Com esta alteração, a accuracy subiu para ~92.86%.

Ao analisar os ficheiros de QuestoesConhecidas, observámos que algumas substituições estavam a ser mal feitas. Alguns tokens mais pequenos estavam a substituir partes de outros tokens maiores. 
Por exemplo, uma frase com o token character 'Uniform Outside Station' estava a ser transformada para '_character_ Outside Station', pois exite também um token para 'Uniform'. Assim, ordenámos os dicionários de tokens por ordem decrescente de tamanho.

A accuracy manteve-se igual com esta alteração.

Decidimos agora tentar otimizar o algoritmo de número minimo de edições.

Começámos pela atribuição de custo à inserção, remoção e substituição.
Pela análise do ficheiro QuestoesConhecidas, foi claro que a remoção deveria ter baixo custo, face às outras duas operações. Isto porque no caso de frases com mais palavras, muitas destas não acrescentam nada ao significado da frase, de acordo com o objetivo deste projeto.

No entanto, não conseguimos alterar os pesos usando a função da bilbioteca nltk, pelo que decidimos escrever nós o algoritmo.
Assim, atribuimos à remoção um peso de 0, e às restantes operações remoção e substituição um peso de 1.

Com esta alteração a accuracy subiu para 100%.

Foram feitas outras alterações mais simples que não contabilizámos a alteração da accuracy:
eliminação de linhas em branco, passar todas as strings para lower case, etc.