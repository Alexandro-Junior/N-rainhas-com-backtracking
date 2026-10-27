# Avaliação A2 - Paradigmas de Linguagens de Programação

## Grupo 04

### 👥 Integrantes (3 a 5 alunos)

* Alexandro de Araujo Junior (34625127)
* Caique dos Santos Alves (39165566)
* Duquesnio Daniel Bandessa (33856885)
* Victor Alves Souza dos Santos (34696466)

## Definição do Tema

* **Paradigma:** Lógico
* **Linguagem:** Prolog
* **Código do Tema:** L2
* **Descrição do Desafio:** Resolvedor das N-rainhas com backtracking — posicionar N rainhas em um tabuleiro N×N sem que se ataquem, usando o mecanismo de busca com backtracking automático do Prolog.

## Execução do Código



* **Ambiente Online Utilizado:** SWISH (swish.swi-prolog.org)
* **Permalink:** https://swish.swi-prolog.org/p/nrainhas-grupo04.pl

### Instruções de Teste (Entrada e Saída)

1. Abra o permalink acima. Não precisa de login nem de instalação.
2. O código aparece no painel da esquerda. No canto inferior direito, digite a consulta na caixa `?-` (ou escolha uma em **Examples**) e clique em **Run!**.
3. Para ver **outra solução**, clique em **Next**: o Prolog volta (backtracking) e procura a próxima.

| Consulta | O que faz |
|---|---|
| `rainhas(N, Qs).` | Uma solução para N rainhas (versão com poda) |
| `rainhas_v1(N, Qs).` | Uma solução pela versão gerar e testar |
| `resolver(N).` | Resolve e desenha o tabuleiro |
| `todas_solucoes(N, S).` | Lista todas as soluções |
| `contar_solucoes(N, Total).` | Conta as soluções |

**Entrada de Exemplo:**

```text
?- rainhas(4, Qs).
?- todas_solucoes(4, S).
?- resolver(8).
?- contar_solucoes(8, Total).
```

**Saída Esperada:**

```text
?- rainhas(4, Qs).
Qs = [3, 1, 4, 2]
   (clicando em Next: Qs = [2, 4, 1, 3])

?- todas_solucoes(4, S).
S = [[3, 1, 4, 2], [2, 4, 1, 3]]

?- resolver(8).
Solução: [4,2,7,3,6,8,5,1]
. . . . . . . Q
. Q . . . . . .
. . . Q . . . .
Q . . . . . . .
. . . . . . Q .
. . . . Q . . .
. . Q . . . . .
. . . . . Q . .
true

?- contar_solucoes(8, Total).
Total = 92
```

> Em `Qs = [3, 1, 4, 2]`, cada posição é uma **coluna** e cada valor é a **linha** da rainha: coluna 1 → linha 3, coluna 2 → linha 1, e assim por diante.

## Relatório Técnico

### Descrição da Solução

_[A preencher: lógica, arquitetura do código e principais regras.]_

### Análise Comparativa

#### 1. Sintaxe

_[A preencher]_

#### 2. Semântica

_[A preencher]_

#### 3. Gerenciamento de Memória

_[A preencher]_

#### 4. Trade-offs

_[A preencher]_

### Resumo da Análise Comparativa

O detalhamento completo está no relatório [`Paradigma04.pdf`](Paradigma04.pdf).

* **Sintaxe:** _[A preencher]_
* **Semântica:** _[A preencher]_
* **Gerenciamento de Memória:** _[A preencher]_
* **Trade-offs:** _[A preencher]_

## Log de Uso de Inteligência Artificial (IA)

* **O que foi pedido à IA:** _[A preencher]_
* **Qual IA foi utilizada:** _[A preencher]_
* **O que foi aproveitado:** _[A preencher]_
* **O que foi reescrito/entendido pelo grupo:** _[A preencher]_
