# Roteiro do seminário — Grupo 04 (N-rainhas em Prolog)

**Data:** 11/11/2026 · **Tempo:** cerca de 15 minutos · **Slides:** `slides/Seminario-NRainhas-Grupo04.pptx` (cada slide tem notas do apresentador)

**Permalink da demo:** https://swish.swi-prolog.org/p/nrainhas-grupo04.pl

| Parte | Quem | Slides | Tempo |
|---|---|---|---|
| Abertura: o problema, o backtracking e o Prolog | Alexandro | 1 a 6 | 4 min |
| O código Prolog e as três versões | Caique | 7 a 10 | 4 min |
| Demo ao vivo, testes e a versão em C | Duquesnio | 11 a 13 | 3 min |
| Versão em Java e comparações | Victor | 14 a 17 | 3 min |
| Uso de IA, conclusão e perguntas | Alexandro e todos | 18 e 19 | 1 min |

> **Regra do enunciado:** qualquer integrante pode ser perguntado sobre **qualquer** parte do código. Todos devem ler o roteiro inteiro, não só a própria parte.

---

## Alexandro — abertura (slides 1 a 6) e conclusão (slide 19)

**O que falar**
1. **O problema:** colocar N rainhas num tabuleiro N×N sem que duas fiquem na mesma linha, coluna ou diagonal. Foi proposto em 1848 para 8 rainhas. O número de soluções explode: 92 para N = 8, 14.200 para N = 12 e mais de 39 bilhões para N = 20. Testar tudo é impossível.
2. **Backtracking:** tentar uma posição, conferir se é atacada, avançar se der certo, e **voltar** (desfazer a última escolha) quando nenhuma linha serve.
3. **Prolog:** do paradigma lógico. O programa é feito de **fatos** (verdades), **regras** (`cabeça :- corpo`, em que a vírgula é "e") e **consultas** (`?- rainhas(8, Qs).`). Não tem `for` nem atribuição: repetição é recursão, e variáveis recebem valor por **unificação**.
4. **Backtracking nativo:** em `?- member(X, [1,2,3]), X > 1.`, o `member` oferece X = 1, 2 ou 3. Com 1, o teste falha, e o Prolog volta sozinho e tenta 2. O botão **Next** pede outra volta (X = 3).
5. **Conclusão:** "Em Prolog, descrevemos o que é uma solução. Procurar e voltar atrás é trabalho da linguagem. O preço é desempenho."

**Perguntas prováveis**
- *O que é um ponto de escolha?* É um lugar onde um objetivo tem mais de uma resposta possível (como `member/2` ou `select/3`). O Prolog o guarda para voltar ali se algo falhar depois.
- *Qual a diferença entre unificação e atribuição?* Atribuição troca o valor de uma variável. Unificação torna dois termos iguais; uma variável ligada não muda mais naquele caminho, e só é "desligada" quando o Prolog volta.
- *Existe solução para todo N?* Para N = 1 e para todo N ≥ 4. N = 2 e N = 3 não têm solução (o programa responde `false`).

---

## Caique — o código Prolog (slides 7 a 10)

**O que falar**
1. **Representação:** `Qs = [2,4,1,3]`. A posição na lista é a coluna e o valor é a linha. Como a lista é uma permutação de 1..N, linha e coluna nunca se repetem; só falta conferir as diagonais.
2. **`nao_ataca/3`:** a rainha `Q` não ataca uma lista vazia; e não ataca a lista se não estiver na diagonal da primeira rainha (que fica a `D` colunas) nem das seguintes. É recursão, não laço. Duas rainhas estão na mesma diagonal quando a diferença de linhas é igual à diferença de colunas.
3. **As três versões** usam o mesmo backtracking nativo:
   - **v1, gerar e testar** (`permutation/2`): monta o tabuleiro inteiro e só depois testa. Vai até N ≈ 10.
   - **v2, com poda** (`select/3`): testa cada rainha assim que ela é colocada. Vai até N ≈ 20.
   - **v3, verificação adiante** (`member/2`): cada coluna guarda as linhas ainda possíveis; começa pelo lugar com **menos opções** e tira das outras colunas as linhas atacadas (`podar/4`). Resolve 100 rainhas em 0,3 s e foi testada até 400.
4. **Ponto principal:** na v2 ninguém escreveu "desfazer jogada". Se `nao_ataca` falha, o Prolog volta ao `select` e tenta outra linha, e as listas voltam a ser as de antes.

**Perguntas prováveis**
- *Por que a v3 é tão mais rápida?* Porque descobre o beco sem saída antes: quando uma coluna fica sem linha possível, falha na hora, sem precisar descer até o fim.
- *O que é `=\=`?* Comparação aritmética "diferente". `is` calcula uma conta (`D1 is D + 1`).
- *O que acontece se a v3 demorar demais?* Ela tem um teto de esforço (`call_with_inference_limit/3`). Se passar dele, recomeça com outro desempate (`com_recomeco/4`). Isso resolveu valores difíceis como N = 120.

---

## Duquesnio — demo, testes e versão em C (slides 11 a 13)

**Demo (abrir o permalink antes de começar)**
1. `ajuda.` mostra os comandos.
2. `resolver(8).` e depois **Next** duas vezes: cada Next é o Prolog voltando e achando outra solução.
3. `explicar(4).` mostra o backtracking passo a passo ("coluna 3 sem saída: volta para a coluna 2").
4. `resolver(100).` resolve 100 rainhas em cerca de 0,3 s.
5. `comparar(20).` mostra a v2 com cerca de 1,6 s e a v3 com cerca de 0,003 s.
6. `testar.` roda os 24 testes; cada linha aparece quando o teste termina.

Se o SWISH mostrar "Erro do Servidor Interno", recarregue a página. Se a internet falhar, use os prints de `docs/prints/`.

**Versão em C:** é o mesmo algoritmo da v2, mas o backtracking é feito à mão. Vetores marcam linhas e diagonais ocupadas; um `for` tenta cada linha; depois de cada tentativa, `marcar(..., false)` desfaz a jogada. A memória é alocada com `malloc`/`calloc` e liberada com `free`.

**Sua v3 em C (`comparacao/nrainhas_v3.c`):** é a mesma verificação adiante da v3 em Prolog. Cada coluna tem um vetor de linhas possíveis, escolhe-se a coluna mais restrita, e cada ramo recebe uma **cópia** dos domínios (`malloc` + `memcpy` + `free`). Essa cópia é o "desfazer" feito à mão; em Prolog ele é automático. Ela resolve N = 400 em 0,05 s, contra 24,5 s no Prolog. Na revisão foram corrigidos três pontos: a validação final conferia a solução depois de ela ser apagada; o tabuleiro ganhou moldura; e alguns N (108, 122, 180…) travavam, o que foi resolvido com recomeço por teto de esforço, igual à v3 em Prolog.

**Perguntas prováveis**
- *A solução muda se rodar de novo?* Não. Para o mesmo N, a primeira solução é sempre a mesma; as outras aparecem com Next.
- *Por que os testes são fatos?* Por segurança, o SWISH não deixa chamar com `call/1` um objetivo montado durante a execução. Então cada teste é um dado (`contagem(8)`), e `resultado/2` tem uma cláusula para cada tipo.
- *O que acontece se esquecer o `marcar(..., false)` no C?* As casas continuam marcadas como ocupadas e a busca deixa de achar soluções: um erro silencioso que no Prolog não existe.

---

## Victor — Java e comparações (slides 14 a 17)

**O que falar**
1. **Java:** o mesmo algoritmo, organizado como uma classe com atributos `private`. A memória é automática (`new` e coletor de lixo da JVM), mas o backtracking continua manual, igual ao C. Para guardar todas as soluções, cada uma é copiada com `clone()`.
2. **Lado a lado:** Prolog usa unificação, volta sozinho e tem tipos dinâmicos; C e Java usam atribuição, desfazem à mão e têm tipos estáticos. O núcleo da v2 tem 15 linhas em Prolog, 45 em C e 39 em Java.
3. **Desempenho:** com o mesmo algoritmo, C e Java são cerca de 100× mais rápidos (N = 28: C 0,30 s, Java 0,34 s, Prolog v2 49,5 s). Mas o C não terminou N = 100 em 60 s, e a v3 em Prolog faz em 0,3 s: quem resolve é o algoritmo.
4. **Melhor ou pior:** Prolog é melhor para busca e código curto, pior em velocidade e depuração. C é o mais rápido, mas tudo é manual. Java tem memória automática e tipos fortes, mas o backtracking continua manual.

**Perguntas prováveis**
- *A comparação de tempo é justa?* É aproximada: C e Java rodaram num computador pessoal e o Prolog no servidor do SWISH. Mas o algoritmo é o mesmo, e todos dão a mesma primeira solução, [1,5,8,6,3,7,2,4] para N = 8.
- *Como o Prolog gerencia a memória?* Os termos ficam numa pilha. Ao voltar a um ponto de escolha, tudo o que foi criado depois é descartado de uma vez, e um coletor de lixo cuida do resto.
- *Então por que não usar sempre C?* Para problemas de busca, o Prolog deixa simples escrever técnicas como a v3, porque restaura o estado ao voltar. Em C, isso exigiria guardar e desfazer cada mudança à mão.
