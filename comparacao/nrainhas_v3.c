/*
 * Problema das N-Rainhas em C - versao com verificacao adiante (v3)
 * Grupo 04 (L2) - Duquesnio Daniel Bandessa, com auxilio de IA.
 * Adaptacao da v3 do programa Prolog, usada na analise comparativa.
 *
 * Estrategia: backtracking com verificacao adiante e heuristica MRV
 * (escolhe primeiro a coluna com menos linhas disponiveis).
 *
 * Compilar: gcc -O2 -Wall -Wextra -std=c11 nrainhas_v3.c -o nrainhas_v3
 * Executar: ./nrainhas_v3 8
 * Todas:    ./nrainhas_v3 8 --all
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <limits.h>
#include <time.h>
#include <math.h>

/* Acima disso o tabuleiro nao cabe na tela: so a lista e mostrada. */
#define MAIOR_DESENHO 30

typedef struct {
    int n;
    int *solucao;              /* solucao[coluna] = linha */
    int *primeira;             /* copia da 1a solucao (a busca desfaz solucao[]) */
    unsigned long long total;
    bool mostrar_todas;
    bool encontrou;
    double centro;             /* desempate: linhas e colunas perto daqui primeiro */
    long long passos, limite;  /* teto de esforco (0 = sem teto) */
    bool estourou;
} Contexto;

/* Ordena as linhas pela distancia ao centro, do meio para as bordas. */
static int *criar_ordem_central(int n, double centro) {
    int *ordem = malloc((size_t)n * sizeof(int));
    if (!ordem) return NULL;

    for (int i = 0; i < n; i++) {
        int r = i, k = i;
        while (k > 0 && fabs(ordem[k - 1] - centro) > fabs(r - centro)) {
            ordem[k] = ordem[k - 1];
            k--;
        }
        ordem[k] = r;
    }
    return ordem;
}

/* A solucao no formato da lista do Prolog: Qs = [linha da coluna 1, ...]. */
static void imprimir_lista(const int *solucao, int n) {
    printf("Qs = [");
    for (int c = 0; c < n; c++)
        printf("%s%d", c ? "," : "", solucao[c] + 1);
    printf("]\n");
}

/* Tabuleiro com moldura e coordenadas: casas escuras ":::", rainhas " Q ". */
static void imprimir_tabuleiro(const int *solucao, int n) {
    imprimir_lista(solucao, n);
    if (n > MAIOR_DESENHO) {
        printf("(tabuleiro %dx%d grande demais para desenhar)\n", n, n);
        return;
    }

    printf("\n    ");
    for (int c = 0; c < n; c++)
        printf("%3d ", c + 1);
    printf("\n");

    for (int linha = 0; linha < n; linha++) {
        printf("    +");
        for (int c = 0; c < n; c++) printf("---+");
        printf("\n%3d |", linha + 1);
        for (int c = 0; c < n; c++) {
            if (solucao[c] == linha)        printf(" Q |");
            else if ((linha + c) % 2 == 1)  printf(":::|");
            else                            printf("   |");
        }
        printf("\n");
    }
    printf("    +");
    for (int c = 0; c < n; c++) printf("---+");
    printf("\n");
}

/* Confere linhas e diagonais de uma solucao completa. */
static bool validar_solucao(const int *solucao, int n) {
    for (int c1 = 0; c1 < n; c1++) {
        for (int c2 = c1 + 1; c2 < n; c2++) {
            if (solucao[c1] == solucao[c2]) return false;
            if (abs(solucao[c1] - solucao[c2]) == c2 - c1)
                return false;
        }
    }
    return true;
}

/*
 * dominios[c * n + r] == 1 significa que a linha r ainda pode
 * receber a rainha da coluna c.
 *
 * A cada jogada, removemos das outras colunas:
 * - a mesma linha;
 * - as duas diagonais atacadas.
 *
 * Cada ramo recebe uma copia dos dominios, o que torna o desfazer
 * da jogada automatico quando a recursao retorna.
 */
static void buscar(Contexto *ctx, unsigned char *dominios,
                   const int *ordem_linhas, int colocadas) {
    int n = ctx->n;

    /* Passou do teto de esforco: desiste desta tentativa (ver main). */
    if (ctx->limite && ++ctx->passos > ctx->limite) {
        ctx->estourou = true;
        return;
    }

    if (colocadas == n) {
        ctx->total++;
        ctx->encontrou = true;
        if (ctx->total == 1)
            memcpy(ctx->primeira, ctx->solucao, (size_t)n * sizeof(int));

        if (ctx->total == 1 || ctx->mostrar_todas) {
            printf("\nSolucao %llu:\n", ctx->total);
            imprimir_tabuleiro(ctx->solucao, n);
        }
        return;
    }

    /* Heuristica MRV: escolhe a coluna nao preenchida mais restrita. */
    int melhor_coluna = -1;
    int menor_dominio = INT_MAX;
    double centro = ctx->centro;

    for (int c = 0; c < n; c++) {
        if (ctx->solucao[c] != -1) continue;

        int quantidade = 0;
        for (int r = 0; r < n; r++)
            quantidade += dominios[(size_t)c * n + r] != 0;

        if (quantidade == 0) return; /* ramo sem possibilidade */

        if (quantidade < menor_dominio ||
            (quantidade == menor_dominio &&
             (melhor_coluna == -1 ||
              fabs(c - centro) < fabs(melhor_coluna - centro)))) {
            menor_dominio = quantidade;
            melhor_coluna = c;
        }
    }

    if (melhor_coluna == -1) return;

    /* Tenta primeiro as linhas mais proximas do centro. */
    for (int i = 0; i < n; i++) {
        int linha = ordem_linhas[i];
        if (!dominios[(size_t)melhor_coluna * n + linha]) continue;

        size_t tamanho = (size_t)n * n;
        unsigned char *proximos = malloc(tamanho);
        if (!proximos) {
            fprintf(stderr, "Erro: memoria insuficiente.\n");
            exit(EXIT_FAILURE);
        }
        memcpy(proximos, dominios, tamanho);

        ctx->solucao[melhor_coluna] = linha;

        /* Propagacao: elimina casas atacadas nas demais colunas. */
        bool ramo_valido = true;
        for (int c = 0; c < n && ramo_valido; c++) {
            if (ctx->solucao[c] != -1) continue;

            int distancia = abs(c - melhor_coluna);
            for (int r = 0; r < n; r++) {
                if (r == linha || abs(r - linha) == distancia)
                    proximos[(size_t)c * n + r] = 0;
            }

            bool tem_opcao = false;
            for (int r = 0; r < n; r++) {
                if (proximos[(size_t)c * n + r]) {
                    tem_opcao = true;
                    break;
                }
            }
            if (!tem_opcao) ramo_valido = false;
        }

        if (ramo_valido)
            buscar(ctx, proximos, ordem_linhas, colocadas + 1);

        ctx->solucao[melhor_coluna] = -1;
        free(proximos);

        /* Na busca por uma unica solucao, para assim que encontrar. */
        if (ctx->encontrou && !ctx->mostrar_todas) return;
        if (ctx->estourou) return;
    }
}

int main(int argc, char *argv[]) {
    if (argc < 2 || argc > 3) {
        printf("Uso: %s N [--all]\n", argv[0]);
        printf("Exemplo: %s 8\n", argv[0]);
        return EXIT_FAILURE;
    }

    char *fim;
    long valor = strtol(argv[1], &fim, 10);
    if (*fim != '\0' || valor < 1 || valor > 1000) {
        fprintf(stderr, "Informe um N inteiro entre 1 e 1000.\n");
        return EXIT_FAILURE;
    }

    bool todas = false;
    if (argc == 3) {
        if (strcmp(argv[2], "--all") != 0) {
            fprintf(stderr, "Opcao desconhecida: %s\n", argv[2]);
            return EXIT_FAILURE;
        }
        todas = true;
    }

    int n = (int)valor;
    if (n == 2 || n == 3) {
        printf("Nao existe solucao para N = %d.\n", n);
        return EXIT_SUCCESS;
    }

    Contexto ctx;
    ctx.n = n;
    ctx.total = 0;
    ctx.mostrar_todas = todas;
    ctx.encontrou = false;

    ctx.solucao = malloc((size_t)n * sizeof(int));
    ctx.primeira = malloc((size_t)n * sizeof(int));
    unsigned char *dominios = malloc((size_t)n * n);

    if (!ctx.solucao || !ctx.primeira || !dominios) {
        fprintf(stderr, "Erro: nao foi possivel alocar memoria.\n");
        free(ctx.solucao);
        free(ctx.primeira);
        free(dominios);
        return EXIT_FAILURE;
    }

    printf("Problema das %d-Rainhas\n", n);
    printf("Estrategia: backtracking + verificacao adiante + MRV.\n");

    /*
     * Recomeco (igual ao com_recomeco/4 da v3 em Prolog): em alguns N
     * (108, 122, 180...) a primeira escolha leva a um ramo enorme sem
     * saida. Cada tentativa tem um teto de passos; se estourar, a busca
     * recomeca desempatando por outro "centro". A ultima nao tem teto.
     * Para listar todas as solucoes (--all) nao ha teto.
     */
    const double desvios[] = {0, 0.5, -0.5, 1, -1, 1.5, -1.5, 2, -2};
    const int tentativas = (int)(sizeof desvios / sizeof desvios[0]);

    clock_t inicio = clock();
    for (int t = 0; t < tentativas && !ctx.encontrou; t++) {
        bool ultima = todas || t == tentativas - 1;
        ctx.centro = (n - 1) / 2.0 + desvios[t];
        ctx.limite = ultima ? 0 : 50LL * n + 1000;
        ctx.passos = 0;
        ctx.estourou = false;

        int *ordem_linhas = criar_ordem_central(n, ctx.centro);
        if (!ordem_linhas) {
            fprintf(stderr, "Erro: nao foi possivel alocar memoria.\n");
            return EXIT_FAILURE;
        }
        for (int c = 0; c < n; c++) ctx.solucao[c] = -1;
        memset(dominios, 1, (size_t)n * n);

        buscar(&ctx, dominios, ordem_linhas, 0);
        free(ordem_linhas);
        if (ultima) break;
    }
    double segundos = (double)(clock() - inicio) / CLOCKS_PER_SEC;

    if (!ctx.encontrou) {
        printf("\nNenhuma solucao encontrada.\n");
    } else {
        printf("\nTotal %s: %llu (%.3f s)\n",
               todas ? "de solucoes encontradas" : "de solucoes exibidas",
               ctx.total, segundos);
        printf("Primeira solucao valida: %s\n",
               validar_solucao(ctx.primeira, n) ? "sim" : "nao");
    }

    free(ctx.solucao);
    free(ctx.primeira);
    free(dominios);
    return EXIT_SUCCESS;
}
