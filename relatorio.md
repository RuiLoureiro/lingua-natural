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

Assim, decidimos substituir nos dois ficheiros referidos, todas as ocorrências de nomes de filmes por _movie_, atores por _actor_, e assim succesivamente para todos as listas.

A ordem pela qual substituimos é também relevante, pois quando corremos o programa tendo definido a ordem aleatoriamente, notámos que as listas com strings mais pequenas e mais gerais, como é o caso de 'list_characters', estavam a substituir partes de ocorrências de strings maiores e mais específicas, como é o caso de 'list_characters'. Assim, definimos a ordem : movies, people, characters, companies, genres, jobs. Não podemos dizer que esta ordem é óptima, pois comeste corpora, a accuracy mantinha-se sempre igual

Começámos pela atribuição de custo à inserção, remoção e substituição.
Pela análise do ficheiro QuestoesConhecidas, foi claro que a remoção deveria ter baixo custo, face às outras duas operações. Isto porque no caso de frases com mais palavras, muitas destas não acrescentam nada ao significado da frase, de acordo com o objetivo deste projeto.

No entanto, não conseguimos alterar os pesos usando a função da bilbioteca nltk, pelo que decidimos escrever nós o algoritmo.
Assim, atribuimos à remoção um peso de 0, e às restantes operações remoção e substituição um peso de 1.
