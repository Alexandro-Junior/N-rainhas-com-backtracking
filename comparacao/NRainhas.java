```java
/*
 * N-Rainhas com backtracking — versão em Java
 * Grupo 04 (L2) · usada apenas na análise comparativa do relatório.
 *
 * Implementação do problema das N-Rainhas utilizando backtracking
 * recursivo. O tabuleiro é representado por um vetor de inteiros,
 * no qual cada posição representa uma coluna e seu valor indica
 * a linha onde a rainha está posicionada.
 *
 * A cada tentativa, o algoritmo verifica se a posição é segura,
 * evitando conflitos na mesma linha e nas diagonais. Quando não
 * encontra uma solução, a recursão retorna e permite testar
 * outras posições.
 *
 * A implementação utiliza métodos estáticos e não possui
 * estruturas auxiliares para registrar linhas ou diagonais ocupadas.
 * A verificação é realizada comparando as posições das rainhas
 * anteriormente posicionadas.
 *
 * Compilar e rodar:  javac NRainhas.java
 *                    java NRainhas
 */

import java.util.Scanner;

public class NRainhas {

    public static void main(String[] args) {
        Scanner entrada = new Scanner(System.in);

        // Solicita ao usuário a quantidade de rainhas do problema.
        System.out.print("Digite um número inteiro para N: ");

        // Verifica se a entrada fornecida é um número inteiro.
        if (!entrada.hasNextInt()) {
            System.out.println("Entrada inválida. Digite um número inteiro usando algarismos.");
            entrada.close();
            return;
        }

        int n = entrada.nextInt();

        // Impede a execução com valores menores que 1.
        if (n < 1) {
            System.out.println("N deve ser um número inteiro positivo.");
            entrada.close();
            return;
        }

        // Vetor que armazena a linha de cada rainha.
        // O índice representa a coluna e o valor representa a linha.
        int[] linhas = new int[n];

        // Inicia o backtracking pela primeira coluna.
        if (resolver(0, linhas)) {
            System.out.println("\nSolução para N = " + n + ":");

            // Exibe a posição de cada rainha no tabuleiro.
            for (int coluna = 0; coluna < n; coluna++) {

                System.out.println(
                        "Coluna " + (coluna + 1) + " -> linha " + (linhas[coluna] + 1));
            }

            System.out.println("\nTabuleiro:");

            // Desenha o tabuleiro, indicando as posições das rainhas.
            for (int linha = 0; linha < n; linha++) {

                for (int coluna = 0; coluna < n; coluna++) {

                    if (linhas[coluna] == linha) {
                        System.out.print(" Q ");
                    } else {
                        System.out.print(" . ");
                    }
                }

                System.out.println();
            }
        } else {
            // Informa quando nenhuma configuração válida é encontrada.
            System.out.println("Não existe solução para N = " + n + ".");
        }

        entrada.close();
    }

    /*
     * Método recursivo responsável pelo backtracking.
     * Tenta posicionar uma rainha por coluna, avançando somente
     * quando encontra uma posição segura.
     */
    private static boolean resolver(int coluna, int[] linhas) {

        // Caso base: todas as colunas receberam uma rainha.
        if (coluna == linhas.length) {
            return true;
        }

        // Testa todas as linhas disponíveis na coluna atual.
        for (int linha = 0; linha < linhas.length; linha++) {

            // Verifica se a posição não apresenta conflitos.
            if (posicaoSegura(linha, coluna, linhas)) {

                // Posiciona a rainha na linha escolhida.
                linhas[coluna] = linha;

                // Avança recursivamente para a próxima coluna.
                if (resolver(coluna + 1, linhas)) {
                    return true;
                }

                // Se a próxima coluna não permitir uma solução,
                // a recursão retorna e o laço testa outra linha.
                // Esse retorno caracteriza o backtracking.
            }
        }

        // Nenhuma posição válida foi encontrada nesta coluna.
        return false;
    }

    /*
     * Verifica se uma posição pode receber uma rainha.
     * Como o algoritmo posiciona uma rainha por coluna,
     * basta verificar as colunas anteriores.
     */
    private static boolean posicaoSegura(int linha, int coluna, int[] linhas) {

        // Percorre todas as colunas que já receberam rainhas.
        for (int colunaAnterior = 0; colunaAnterior < coluna; colunaAnterior++) {

            int linhaAnterior = linhas[colunaAnterior];

            // Verifica conflito na mesma linha.
            if (linhaAnterior == linha) {
                return false;
            }

            // Verifica conflito nas diagonais.
            // Duas posições estão na mesma diagonal quando
            // a diferença entre as linhas é igual à diferença
            // entre as colunas, em valor absoluto.
            if (Math.abs(linhaAnterior - linha) == Math.abs(colunaAnterior - coluna)) {
                return false;
            }
        }

        // Nenhum conflito foi encontrado: posição segura.
        return true;
    }
}
```
