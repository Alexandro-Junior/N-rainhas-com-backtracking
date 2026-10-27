# Versões em C e Java (análise comparativa)

Estes arquivos **não fazem parte da entrega executável**, que é o Prolog no SWISH. Eles existem só para a análise comparativa do relatório (item 2.6 do enunciado): o mesmo problema, resolvido com o mesmo algoritmo da **v2** do Prolog (uma rainha por coluna, com poda imediata), nos paradigmas que a turma já conhece.

| Arquivo | Paradigma | Como rodar |
|---|---|---|
| [`nrainhas.c`](nrainhas.c) | Imperativo (C) | `gcc -O2 -o nrainhas nrainhas.c` e depois `./nrainhas 8` |
| [`NRainhas.java`](NRainhas.java) | Orientado a objetos (Java) | `javac NRainhas.java` e depois `java NRainhas 8` |

O número no fim do comando é o N (padrão: 8). Os dois programas mostram a primeira solução e, para N ≤ 12, também o total de soluções.

## Testes (27/10/2026)

Compilados sem nenhum aviso: `gcc 16.2 -O2 -Wall -Wextra -std=c11` e `javac 21 -Xlint:all`.

**Corretude:** C, Java e a v2 em Prolog dão o mesmo total de soluções (N = 1, 2, 3, 4, 8, 12 → 1, 0, 0, 2, 92, 14200) e **a mesma primeira solução** (N = 8 → `[1,5,8,6,3,7,2,4]`). Isso confirma que é o mesmo algoritmo de busca.

**Tempo até a primeira solução** (o Prolog foi medido no SWISH, então os ambientes são diferentes e a comparação é aproximada):

| N | C (v2) | Java (v2) | Prolog v2 | Prolog v3 |
|---|---|---|---|---|
| 20 | 0,017 s | 0,028 s | 1,6 s | 0,003 s |
| 24 | 0,035 s | 0,055 s | 5,4 s | — |
| 28 | 0,30 s | 0,34 s | 49,5 s | 0,003 s |
| 32 | 9,3 s | — | — | — |
| 100 | mais de 60 s (interrompido) | — | — | 0,3 s |

**Leitura:** com o mesmo algoritmo, C e Java são cerca de 100 vezes mais rápidos que o Prolog, porque usam vetores mutáveis e acesso direto à memória. Mas os três crescem de forma exponencial. Quem resolve N = 100 é o **algoritmo** (a v3), não a linguagem. E a v3 em C ou Java exigiria guardar e desfazer à mão os domínios podados, que o Prolog desfaz sozinho no backtracking.

## O que comparar com o Prolog

| Aspecto | Prolog (`src/nrainhas.pl`) | C / Java |
|---|---|---|
| Tentativa e erro | `select/3` ou `member/2` criam pontos de escolha | laço `for` sobre as linhas |
| Voltar atrás | automático: quando um objetivo falha, o motor volta ao último ponto de escolha | manual: `marcar(..., false)` desfaz o que foi marcado |
| Estado | listas imutáveis; cada passo cria uma lista nova | vetores mutáveis (`linha_usada`, `diag1`, `diag2`) |
| Todas as soluções | `findall/3`, `aggregate_all/3` ou o botão **Next** | uma segunda função recursiva (`contar` / `coletar`) |
| Memória | pilhas da máquina Prolog + coletor de lixo | C: `malloc`/`calloc`/`free` manuais; Java: coletor de lixo da JVM |
