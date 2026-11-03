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
| `testar.` | Roda os 24 testes automáticos e mostra cada resultado assim que ele sai |
| `contar_solucoes(N, Total).` | Quantas soluções existem (N até 12) |
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
?- testar.
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

?- testar.
♛ Testes automáticos
24 testes. Cada resultado é comparado com o valor esperado (✔ igual, ✗ diferente).
1. O conferidor valida/1 reconhece tabuleiros errados
✔ valida([2,4,1,3]), solução correta → aceita · 0.000 s
✔ valida([1,2,3,4]), todas na mesma diagonal → rejeita · 0.000 s
✔ valida([2,4,1,1]), duas na mesma linha → rejeita · 0.000 s
2. Total de soluções igual ao conhecido (N = 1 a 10)
✔ contar_solucoes(1, T) → 1 · 0.000 s
✔ contar_solucoes(2, T) → 0 · 0.000 s
✔ contar_solucoes(3, T) → 0 · 0.000 s
✔ contar_solucoes(4, T) → 2 · 0.000 s
✔ contar_solucoes(5, T) → 10 · 0.001 s
✔ contar_solucoes(6, T) → 4 · 0.001 s
✔ contar_solucoes(7, T) → 40 · 0.003 s
✔ contar_solucoes(8, T) → 92 · 0.012 s
✔ contar_solucoes(9, T) → 352 · 0.043 s
✔ contar_solucoes(10, T) → 724 · 0.161 s
3. As três versões chegam ao mesmo total
✔ totais da v1, v2 e v3 para N = 4 → [2,2,2] · 0.000 s
✔ totais da v1, v2 e v3 para N = 6 → [4,4,4] · 0.002 s
✔ totais da v1, v2 e v3 para N = 8 → [92,92,92] · 0.071 s
4. As respostas do Next: válidas e sem repetição
✔ soluções de rainhas(8, Qs) reprovadas por valida/1 → 0 · 0.013 s
✔ soluções repetidas entre as respostas de rainhas(8, Qs) → 0 · 0.015 s
5. Tabuleiros grandes (v3)
✔ valida/1 na 1ª solução de rainhas(20, Qs) → aceita · 0.004 s
✔ valida/1 na 1ª solução de rainhas(50, Qs) → aceita · 0.034 s
✔ valida/1 na 1ª solução de rainhas(100, Qs) → aceita · 0.287 s
✔ valida/1 na 1ª solução de rainhas(200, Qs) → aceita · 2.556 s
6. Mesma 1ª solução das versões em C e Java
✔ 1ª solução de rainhas_v2(4, Qs) → [2,4,1,3] · 0.000 s
✔ 1ª solução de rainhas_v2(8, Qs) → [1,5,8,6,3,7,2,4] · 0.000 s
♛ Resultado dos testes
✔ Todos os 24 testes passaram.
Tempo total: 3.21 s
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
- O comando `testar.` roda **24 testes automáticos** direto no SWISH e mostra cada resultado assim que ele sai. Ele confere o próprio conferidor (`valida/1`), o total de soluções de N = 1 a 10, que as três versões concordam, que as respostas do **Next** são válidas e não se repetem, tabuleiros de 20 a 200 rainhas e a mesma 1ª solução das versões em C e Java. Os testes são uma base de fatos (`teste/4`), e `resultado/2` calcula o valor obtido em cada caso.
- As três versões dão o mesmo número de soluções de N = 1 a 9: 1, 0, 0, 2, 10, 4, 40, 92 e 352. A v3 também acerta N = 10 (724) e N = 11 (2680).
- A v3 achou uma solução válida para **todo N de 1 a 250** (N = 2 e N = 3 não têm solução). Tempo médio de 1,3 s, pior caso 5,6 s (N = 248). Também foram testados N = 300 (9,4 s) e N = 400 (24,5 s).

**Versões em C e Java** (pasta [`comparacao/`](comparacao/)): o mesmo algoritmo da v2, com o backtracking implementado manualmente, para a análise comparativa.

### Análise Comparativa

A comparação usa o mesmo algoritmo da v2 reescrito em C e Java (pasta [`comparacao/`](comparacao/)). As três versões dão o mesmo total de soluções e a mesma primeira solução, então as diferenças vêm do paradigma, e não do algoritmo.

#### 1. Sintaxe

Em Prolog, o programa é uma sequência de cláusulas `Cabeça :- Corpo`. Não há declaração de tipos, chaves, atribuição nem laços: a vírgula significa "e", e a repetição é feita por recursão. Cada caso é uma cláusula escolhida por casamento de padrões: `nao_ataca(_, [], _)` trata a lista vazia, e `nao_ataca(Q, [Q1|Qs], D)` separa a primeira rainha do resto. O núcleo da v2 tem **15 linhas em Prolog, 45 em C e 39 em Java**. As outras duas precisam de vetores de marcação, índices e funções para marcar e desmarcar casas.

#### 2. Semântica

- **Unificação no lugar da atribuição.** Uma variável ligada não muda mais naquele ramo da prova, e o retrocesso desfaz as ligações sozinho, por isso não existe "desmarcar".
- **Controle implícito.** É a falha de um objetivo que faz a busca voltar.
- **Avaliação.** É estrita, mas as soluções saem sob demanda (**Next**, `findall/3`), como um gerador com `yield` em Python. Em C e Java foi preciso uma segunda função (`contar`/`coletar`).
- **Relações, não funções.** `rainhas_v2(4, Qs)` gera uma solução e `rainhas_v2(4, [2,4,1,3])` confere uma.
- **Tipos e escopo.** A tipagem é dinâmica, enquanto C e Java têm tipagem estática. O escopo de uma variável é a cláusula, e não há estado global.

#### 3. Gerenciamento de Memória

- **C:** `malloc`/`calloc` e `free` manuais em `criar` e `destruir`, com risco de vazamento ou de uso após liberar.
- **Java:** `new` e o coletor de lixo da JVM. Como o vetor é reaproveitado, cada solução guardada precisa ser copiada com `clone()`.
- **Prolog:** nenhuma alocação explícita. Os termos ficam na pilha global, e a trilha (*trail*) registra as ligações a desfazer. Ao retroceder, o SWI-Prolog descarta de uma vez tudo o que foi criado depois do ponto de escolha, e o coletor de lixo recolhe o resto. A v3 cria listas novas de domínios a cada passo, o que gasta mais memória, mas é isso que permite restaurá-los sem nenhum código extra.

#### 4. Trade-offs

Com o mesmo algoritmo, C e Java são cerca de 100 vezes mais rápidos. Para N = 28, levam 0,30 s (C) e 0,34 s (Java), contra 49,5 s do Prolog v2. Mas nas três linguagens o tempo cresce de forma exponencial: o C não terminou N = 100 em 60 s, e a v3 em Prolog resolve N = 100 em 0,3 s. Quem resolve N grande é o algoritmo, e a v3 só foi simples de escrever porque o Prolog restaura os domínios ao retroceder.

- **Vantagens do Prolog:** backtracking nativo, sem código para desfazer jogadas; código curto e próximo da definição do problema; todas as soluções sem esforço extra; predicados que geram e conferem.
- **Desvantagens:** desempenho e consumo de memória; eficiência dependente da ordem dos objetivos (`contar_solucoes(50, T)` não terminaria); depuração mais difícil; erros de tipo só na execução; pouco controle de baixo nível.

### Resumo da Análise Comparativa

O detalhamento completo está no relatório [`Paradigma04.pdf`](Paradigma04.pdf). A fonte editável fica em [`relatorio/Paradigma04.docx`](relatorio/Paradigma04.docx).

* **Sintaxe:** cláusulas declarativas e recursão no lugar de laços, índices e `if`. O núcleo da v2 tem 15 linhas em Prolog, contra 45 em C e 39 em Java.
* **Semântica:** unificação em vez de atribuição, retrocesso automático, soluções sob demanda e predicados que funcionam nos dois sentidos. Tipagem dinâmica e escopo restrito à cláusula.
* **Gerenciamento de Memória:** nenhum `malloc`/`free`. As pilhas da máquina Prolog são recuperadas no retrocesso, e o coletor de lixo faz o resto. Em C a memória é manual, e em Java fica com o coletor da JVM.
* **Trade-offs:** C e Java são cerca de 100 vezes mais rápidos com o mesmo algoritmo. O Prolog torna trivial a parte difícil, que é retroceder corretamente, e deixa simples escrever a v3, que resolve 100 rainhas em 0,3 s.

## Log de Uso de Inteligência Artificial (IA)

O registro detalhado, com data, está em [`log-ia.md`](log-ia.md).

* **O que foi pedido à IA:** análise do enunciado e plano do projeto; escrita do código Prolog em três versões (gerar e testar, poda, verificação adiante) e da apresentação visual no SWISH; versões em C e Java para a comparação; testes de N=1 a 200; comando `testar`; rascunho do relatório `Paradigma04.pdf` e prints do SWISH.
* **Qual IA foi utilizada:** Anthropic Claude Opus 5.5 (Claude Code).
* **O que foi aproveitado:** `src/nrainhas.pl`, `comparacao/nrainhas.c`, `comparacao/NRainhas.java`, o `PLANO.md`, a estrutura deste README, o texto-base do relatório e as figuras de `docs/prints/`.
* **O que foi reescrito/entendido pelo grupo:** _[A preencher pelo grupo]_
