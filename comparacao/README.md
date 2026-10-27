# Versões em C e Java (análise comparativa)

Estes arquivos **não fazem parte da entrega executável**, que é o Prolog no SWISH. Eles existem só para a análise comparativa do relatório (item 2.6 do enunciado): o mesmo problema, resolvido com o mesmo algoritmo da **v2** do Prolog (uma rainha por coluna, com poda imediata), nos paradigmas que a turma já conhece.

| Arquivo | Paradigma | Como rodar |
|---|---|---|
| [`nrainhas.c`](nrainhas.c) | Imperativo (C) | `gcc -O2 -o nrainhas nrainhas.c` e depois `./nrainhas 8` |
| [`NRainhas.java`](NRainhas.java) | Orientado a objetos (Java) | `javac NRainhas.java` e depois `java NRainhas 8` |

O número no fim do comando é o N (padrão: 8). Os dois programas mostram a primeira solução e, para N ≤ 12, também o total de soluções.

## O que comparar com o Prolog

| Aspecto | Prolog (`src/nrainhas.pl`) | C / Java |
|---|---|---|
| Tentativa e erro | `select/3` ou `member/2` criam pontos de escolha | laço `for` sobre as linhas |
| Voltar atrás | automático: quando um objetivo falha, o motor volta ao último ponto de escolha | manual: `marcar(..., false)` desfaz o que foi marcado |
| Estado | listas imutáveis; cada passo cria uma lista nova | vetores mutáveis (`linha_usada`, `diag1`, `diag2`) |
| Todas as soluções | `findall/3`, `aggregate_all/3` ou o botão **Next** | uma segunda função recursiva (`contar` / `coletar`) |
| Memória | pilhas da máquina Prolog + coletor de lixo | C: `malloc`/`calloc`/`free` manuais; Java: coletor de lixo da JVM |
