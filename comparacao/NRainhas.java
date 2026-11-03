/*
 * N-Rainhas com backtracking — versão em Java (orientação a objetos)
 * Grupo 04 (L2) · usada apenas na análise comparativa do relatório.
 *
 * Mesmo algoritmo da v2 em Prolog e da versão em C, organizado como
 * uma classe: o estado do tabuleiro fica encapsulado em atributos
 * privados (vetores mutáveis) e o backtracking continua sendo manual,
 * marcando e desmarcando casas. A memória é liberada pelo coletor de
 * lixo da JVM, sem free().
 *
 * Compilar e rodar:  javac NRainhas.java
 *                    java NRainhas 8
 */
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class NRainhas {

    private final int n;
    private final int[] linhaDaColuna;   // linhaDaColuna[c] = linha da rainha da coluna c
    private final boolean[] linhaUsada;  // n posições
    private final boolean[] diag1;       // 2n-1 posições, índice l - c + n - 1
    private final boolean[] diag2;       // 2n-1 posições, índice l + c

    public NRainhas(int n) {
        if (n < 1) {
            throw new IllegalArgumentException("N precisa ser um inteiro maior que zero.");
        }
        this.n = n;
        this.linhaDaColuna = new int[n];
        this.linhaUsada = new boolean[n];
        this.diag1 = new boolean[2 * n - 1];
        this.diag2 = new boolean[2 * n - 1];
    }

    /** Primeira solução encontrada, ou null se não existir nenhuma. */
    public int[] primeiraSolucao() {
        limpar();
        return posicionar(0) ? linhaDaColuna.clone() : null;
    }

    /** Todas as soluções. Cada uma é copiada, pois o vetor é reaproveitado. */
    public List<int[]> todasSolucoes() {
        limpar();
        List<int[]> solucoes = new ArrayList<>();
        coletar(0, solucoes);
        return solucoes;
    }

    private boolean posicionar(int c) {
        if (c == n) {
            return true;
        }
        for (int l = 0; l < n; l++) {
            if (livre(l, c)) {
                linhaDaColuna[c] = l;
                marcar(l, c, true);            // tenta
                if (posicionar(c + 1)) {
                    return true;
                }
                marcar(l, c, false);           // desfaz: backtracking manual
            }
        }
        return false;                          // nenhuma linha serve
    }

    private void coletar(int c, List<int[]> solucoes) {
        if (c == n) {
            solucoes.add(linhaDaColuna.clone());
            return;
        }
        for (int l = 0; l < n; l++) {
            if (livre(l, c)) {
                linhaDaColuna[c] = l;
                marcar(l, c, true);
                coletar(c + 1, solucoes);
                marcar(l, c, false);
            }
        }
    }

    private boolean livre(int l, int c) {
        return !linhaUsada[l] && !diag1[l - c + n - 1] && !diag2[l + c];
    }

    private void marcar(int l, int c, boolean ocupada) {
        linhaUsada[l] = ocupada;
        diag1[l - c + n - 1] = ocupada;
        diag2[l + c] = ocupada;
    }

    private void limpar() {
        Arrays.fill(linhaUsada, false);
        Arrays.fill(diag1, false);
        Arrays.fill(diag2, false);
    }

    /** Texto da solução com linhas e colunas contadas a partir de 1. */
    public static String desenhar(int[] solucao) {
        StringBuilder sb = new StringBuilder("Qs = [");
        for (int c = 0; c < solucao.length; c++) {
            sb.append(c > 0 ? "," : "").append(solucao[c] + 1);
        }
        sb.append("]\n");
        if (solucao.length <= 16) {
            for (int l = 0; l < solucao.length; l++) {
                for (int c = 0; c < solucao.length; c++) {
                    sb.append(solucao[c] == l ? " Q" : " .");
                }
                sb.append('\n');
            }
        }
        return sb.toString();
    }

    public static void main(String[] args) {
        int n = args.length > 0 ? Integer.parseInt(args[0]) : 8;
        NRainhas problema = new NRainhas(n);

        long inicio = System.nanoTime();
        int[] solucao = problema.primeiraSolucao();
        double segundos = (System.nanoTime() - inicio) / 1e9;

        if (solucao != null) {
            System.out.printf("Primeira solução para N = %d (%.4f s):%n", n, segundos);
            System.out.print(desenhar(solucao));
        } else {
            System.out.printf("Não existe solução para N = %d.%n", n);
        }

        if (n <= 12) {
            System.out.println("Total de soluções: " + problema.todasSolucoes().size());
        }
    }
}
