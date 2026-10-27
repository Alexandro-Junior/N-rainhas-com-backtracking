/*
 * N-Rainhas com backtracking — versão em C (paradigma imperativo)
 * Grupo 04 (L2) · usada apenas na análise comparativa do relatório.
 *
 * É o mesmo algoritmo da v2 em Prolog (uma rainha por coluna, poda
 * imediata), mas aqui tudo o que o Prolog faz sozinho é escrito à mão:
 *   - o estado (linhas e diagonais ocupadas) fica em vetores alocados
 *     com malloc/calloc e liberados com free;
 *   - a tentativa e erro é um laço for;
 *   - o "voltar atrás" é explícito: desmarcar o que foi marcado.
 *
 * Compilar e rodar:  gcc -O2 -o nrainhas nrainhas.c
 *                    ./nrainhas 8
 */
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

typedef struct {
    int n;
    int *linha;          /* linha[c] = linha da rainha da coluna c (0..n-1) */
    bool *linha_usada;   /* n posições                                     */
    bool *diag1;         /* 2n-1 posições, índice l - c + n - 1            */
    bool *diag2;         /* 2n-1 posições, índice l + c                    */
} Tabuleiro;

/* Gerenciamento manual de memória: quem aloca é responsável por liberar. */
static bool criar(Tabuleiro *t, int n) {
    t->n = n;
    t->linha = malloc(n * sizeof *t->linha);
    t->linha_usada = calloc(n, sizeof *t->linha_usada);
    t->diag1 = calloc(2 * n - 1, sizeof *t->diag1);
    t->diag2 = calloc(2 * n - 1, sizeof *t->diag2);
    return t->linha && t->linha_usada && t->diag1 && t->diag2;
}

static void destruir(Tabuleiro *t) {
    free(t->linha);
    free(t->linha_usada);
    free(t->diag1);
    free(t->diag2);
}

static void limpar(Tabuleiro *t) {
    memset(t->linha_usada, 0, t->n * sizeof *t->linha_usada);
    memset(t->diag1, 0, (2 * t->n - 1) * sizeof *t->diag1);
    memset(t->diag2, 0, (2 * t->n - 1) * sizeof *t->diag2);
}

static bool livre(const Tabuleiro *t, int l, int c) {
    return !t->linha_usada[l]
        && !t->diag1[l - c + t->n - 1]
        && !t->diag2[l + c];
}

static void marcar(Tabuleiro *t, int l, int c, bool ocupada) {
    t->linha_usada[l] = ocupada;
    t->diag1[l - c + t->n - 1] = ocupada;
    t->diag2[l + c] = ocupada;
}

/* Primeira solução: devolve true assim que encontra uma. */
static bool posicionar(Tabuleiro *t, int c) {
    if (c == t->n)
        return true;
    for (int l = 0; l < t->n; l++) {
        if (livre(t, l, c)) {
            t->linha[c] = l;
            marcar(t, l, c, true);              /* tenta              */
            if (posicionar(t, c + 1))
                return true;
            marcar(t, l, c, false);             /* desfaz: backtracking */
        }
    }
    return false;                               /* nenhuma linha serve */
}

/* Conta todas as soluções: o mesmo laço, sem parar na primeira. */
static long contar(Tabuleiro *t, int c) {
    if (c == t->n)
        return 1;
    long total = 0;
    for (int l = 0; l < t->n; l++) {
        if (livre(t, l, c)) {
            marcar(t, l, c, true);
            total += contar(t, c + 1);
            marcar(t, l, c, false);
        }
    }
    return total;
}

static void imprimir(const Tabuleiro *t) {
    printf("Qs = [");
    for (int c = 0; c < t->n; c++)
        printf("%s%d", c ? "," : "", t->linha[c] + 1);
    printf("]\n");
    if (t->n > 16)
        return;
    for (int l = 0; l < t->n; l++) {
        for (int c = 0; c < t->n; c++)
            printf(" %c", t->linha[c] == l ? 'Q' : '.');
        printf("\n");
    }
}

int main(int argc, char **argv) {
    int n = argc > 1 ? atoi(argv[1]) : 8;
    if (n < 1) {
        fprintf(stderr, "N precisa ser um inteiro maior que zero.\n");
        return 1;
    }

    Tabuleiro t;
    if (!criar(&t, n)) {
        fprintf(stderr, "Sem memória para N = %d.\n", n);
        destruir(&t);
        return 1;
    }

    clock_t inicio = clock();
    bool achou = posicionar(&t, 0);
    double segundos = (double)(clock() - inicio) / CLOCKS_PER_SEC;

    if (achou) {
        printf("Primeira solução para N = %d (%.4f s):\n", n, segundos);
        imprimir(&t);
    } else {
        printf("Não existe solução para N = %d.\n", n);
    }

    if (n <= 12) {
        limpar(&t);
        printf("Total de soluções: %ld\n", contar(&t, 0));
    }

    destruir(&t);
    return 0;
}
