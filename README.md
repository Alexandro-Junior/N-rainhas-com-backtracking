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
2. O código aparece no painel da esquerda. No canto inferior direito, digite uma consulta na caixa `?-` (ou escolha uma em **Examples**) e clique em **Run!**.
3. Comece por `ajuda.`: ela mostra todos os comandos disponíveis.
4. Para ver **outra solução**, clique em **Next**: o Prolog volta (backtracking) e procura a próxima.

| Consulta | O que faz |
|---|---|
| `ajuda.` | Mostra a lista de comandos |
| `resolver(N).` | Resolve e desenha o tabuleiro N×N (funciona com N = 8, 50, 100, 200...) |
| `mostrar_todas(N).` | Todas as soluções em miniatura, lado a lado (N até 8) |
| `explicar(N).` | Mostra o backtracking passo a passo (N até 6) |
| `comparar(N).` | Tempo das três versões do algoritmo para o mesmo N |
| `contar_solucoes(N, Total).` | Quantas soluções existem |
| `rainhas(N, Qs).` | A solução como lista (versão principal, v3) |
| `rainhas_v1(N, Qs).` / `rainhas_v2(N, Qs).` | As versões mais simples, para comparação |
| `imprimir_tabuleiro(Qs).` | Desenho da solução em texto |

**Entrada de Exemplo:**

```text
?- rainhas(4, Qs).
?- imprimir_tabuleiro([3,1,4,2]).
?- contar_solucoes(8, Total).
?- explicar(4).
?- resolver(100).
?- comparar(20).
```

**Saída Esperada:**

```text
?- rainhas(4, Qs).
Qs = [3, 1, 4, 2]
   (clicando em Next: Qs = [2, 4, 1, 3]; clicando de novo: false)

?- imprimir_tabuleiro([3,1,4,2]).
. Q . .
. . . Q
Q . . .
. . Q .
true

?- contar_solucoes(8, Total).
Total = 92

?- explicar(4).
♛ Passo a passo do backtracking · N = 4
  ✓ coluna 1 → linha 1
     ✗ coluna 2 → linha 2 (atacada)
     ✓ coluna 2 → linha 3
        ✗ coluna 3 → linha 2 (atacada)
        ✗ coluna 3 → linha 4 (atacada)
        ↩ coluna 3 sem saída: volta para a coluna 2
     ✓ coluna 2 → linha 4
        ✓ coluna 3 → linha 2
           ✗ coluna 4 → linha 3 (atacada)
           ↩ coluna 4 sem saída: volta para a coluna 3
        ✗ coluna 3 → linha 3 (atacada)
        ↩ coluna 3 sem saída: volta para a coluna 2
     ↩ coluna 2 sem saída: volta para a coluna 1
  ✓ coluna 1 → linha 2
     ✗ coluna 2 → linha 1 (atacada)
     ✗ coluna 2 → linha 3 (atacada)
     ✓ coluna 2 → linha 4
        ✓ coluna 3 → linha 1
           ✓ coluna 4 → linha 3
♛ Solução encontrada: [2,4,1,3]
   (seguida do tabuleiro desenhado)

?- resolver(100).
♛ 100 rainhas · tabuleiro 100×100
Solução nº 1 · encontrada em 0.3333 s
Qs = [27,31,63,70,76,73,61,42,34,59,44,32,60,35,43,72,90,45,77,12, ...]
   (tabuleiro 100×100 desenhado, com as rainhas em vermelho)
✔ Conferido: 100 rainhas, uma por linha e por coluna, nenhuma na mesma diagonal.

?- comparar(20).
♛ Comparando as 3 versões · N = 20
Versão                         Tempo
v1 · gerar e testar            não roda (lenta demais para N > 10)
v2 · backtracking com poda     1.5936 s
v3 · verificação adiante       0.0033 s
```

> Em `Qs = [3, 1, 4, 2]`, cada posição é uma **coluna** e cada valor é a **linha** da rainha: coluna 1 → linha 3, coluna 2 → linha 1, e assim por diante. Os tempos variam um pouco a cada execução.

## Relatório Técnico

### Descrição da Solução

**Representação.** Uma solução é uma lista `Qs = [Q1, ..., QN]` em que `Qi` é a linha da rainha da coluna `i`. Com uma rainha por coluna e a lista sendo uma permutação de `1..N`, ataques por linha ou por coluna ficam impossíveis por construção. Só falta conferir as diagonais: duas rainhas estão na mesma diagonal quando a diferença de linhas é igual à diferença de colunas (regra `nao_ataca/3`).

**Três versões do mesmo backtracking nativo**, da mais ingênua para a mais eficiente:

| Versão | Regra | Ideia | Até onde vai |
|---|---|---|---|
| v1 · gerar e testar | `rainhas_v1/2` | `permutation/2` gera um tabuleiro completo e `segura/1` testa. Se falha, o Prolog volta e gera a próxima permutação. | N ≈ 10 |
| v2 · backtracking com poda | `rainhas_v2/2` | Coloca uma rainha por coluna com `select/3` e testa na hora, com `nao_ataca/3`. Um ramo inválido é abandonado logo no início. | N ≈ 20 |
| v3 · verificação adiante | `rainhas/2` = `rainhas_v3/2` | Cada coluna guarda as linhas ainda possíveis (o seu domínio). A cada passo escolhe a coluna ou linha com **menos opções** ("first-fail"), coloca a rainha com `member/2` e tira das outras colunas as linhas atacadas (`podar/4`). Se alguma coluna ou linha fica sem opção, falha na hora e o Prolog volta. Colunas e linhas são tentadas do centro para as bordas. Se a primeira solução não aparece dentro de um teto de esforço, a busca recomeça com outro desempate (`com_recomeco/4`). | N = 100 em ~0,3 s, N = 200 em ~3 s, N = 400 em ~25 s |

Nas três, **não há pilha, laço nem "desfazer jogada" escritos à mão**. Quando um objetivo falha, o próprio motor do Prolog volta ao último ponto de escolha (`permutation/2`, `select/3` ou `member/2`) e tenta a próxima alternativa. É esse mecanismo que o botão **Next** do SWISH aciona.

**Apresentação.** A parte que mostra os resultados fica separada da lógica:
- `tabuleiro/2` é uma relação pura entre uma solução e o seu desenho em texto;
- `tabuleiro_html/3` monta o tabuleiro gráfico como um **termo Prolog** (`table`, `tr`, `td`), e o predicado `html/1` do SWISH o exibe;
- os comandos (`ajuda/0`, as cores e os estilos) são bases de fatos.

Cada solução exibida é conferida de forma independente por `valida/1`: uma rainha por linha e nenhuma diagonal repetida.

**Testes (no SWISH, em 27/10/2026):**
- As três versões dão o mesmo número de soluções de N = 1 a 9: 1, 0, 0, 2, 10, 4, 40, 92 e 352. A v3 também acerta N = 10 (724) e N = 11 (2680).
- A v3 achou uma solução válida para **todo N de 1 a 250** (N = 2 e N = 3 não têm solução). Tempo médio de 1,3 s, pior caso 5,6 s (N = 248). Também foram testados N = 300 (9,4 s) e N = 400 (24,5 s).

**Versões em C e Java** (pasta [`comparacao/`](comparacao/)): o mesmo algoritmo da v2, com o backtracking implementado manualmente, para a análise comparativa.

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

O registro detalhado, com data, está em [`log-ia.md`](log-ia.md).

* **O que foi pedido à IA:** análise do enunciado e plano do projeto; escrita do código Prolog em três versões (gerar e testar, poda, verificação adiante) e da apresentação visual no SWISH; versões em C e Java para a comparação; testes de N=1 a 200.
* **Qual IA foi utilizada:** Anthropic Claude Opus 5.5 (Claude Code).
* **O que foi aproveitado:** `src/nrainhas.pl`, `comparacao/nrainhas.c`, `comparacao/NRainhas.java`, o `PLANO.md` e a estrutura deste README.
* **O que foi reescrito/entendido pelo grupo:** _[A preencher pelo grupo]_
