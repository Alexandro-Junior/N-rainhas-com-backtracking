/*  N-Rainhas com backtracking — Grupo 04 (L2)
    Paradigmas de Linguagens de Programação — Prolog (SWISH)

    Representação: uma solução é uma lista Qs = [Q1, Q2, ..., QN] em que
    Qi é a LINHA da rainha que está na COLUNA i. Como cada coluna tem
    exatamente uma rainha e a lista é uma permutação de 1..N, ataques por
    linha ou coluna são impossíveis por construção: só falta checar as
    diagonais.

    Nenhuma pilha, laço ou "desfazer jogada" é escrito à mão: quando um
    objetivo falha, o próprio Prolog volta (backtracking) ao último ponto
    de escolha e tenta a próxima alternativa.
*/

% ------------------------------------------------------------------
% Regra comum: a rainha Q não ataca nenhuma das rainhas da lista.
% D é a distância (em colunas) entre Q e a primeira rainha da lista.
% Duas rainhas estão na mesma diagonal quando a diferença de linhas
% é igual à diferença de colunas.
% ------------------------------------------------------------------
nao_ataca(_, [], _).
nao_ataca(Q, [Q1|Qs], D) :-
    Q =\= Q1 + D,
    Q =\= Q1 - D,
    D1 is D + 1,
    nao_ataca(Q, Qs, D1).

% ------------------------------------------------------------------
% Versão 1 — gerar e testar
% permutation/2 GERA um tabuleiro completo; segura/1 TESTA.
% Se o teste falha, o Prolog volta para permutation/2 e pede a próxima
% permutação. Simples, mas gera até N! tabuleiros.
% ------------------------------------------------------------------
rainhas_v1(N, Qs) :-
    numlist(1, N, Linhas),
    permutation(Linhas, Qs),
    segura(Qs).

segura([]).
segura([Q|Qs]) :-
    nao_ataca(Q, Qs, 1),
    segura(Qs).

% ------------------------------------------------------------------
% Versão 2 — com poda (versão principal)
% Coloca uma rainha por vez: select/3 escolhe uma linha ainda livre e
% nao_ataca/3 é testado IMEDIATAMENTE contra as rainhas já colocadas.
% Um ramo inválido é abandonado logo no início, sem montar o tabuleiro
% inteiro — por isso é muito mais rápida que a v1.
% ------------------------------------------------------------------
rainhas(N, Qs) :-
    numlist(1, N, Linhas),
    posicionar(Linhas, [], Qs).

% posicionar(+LinhasLivres, +RainhasColocadas, -Solucao)
posicionar([], Qs, Qs).
posicionar(Livres, Colocadas, Qs) :-
    select(Q, Livres, Resto),          % ponto de escolha
    nao_ataca(Q, Colocadas, 1),        % poda: falhou? volta ao select
    posicionar(Resto, [Q|Colocadas], Qs).

% ------------------------------------------------------------------
% Utilitários
% ------------------------------------------------------------------

% Todas as soluções e a quantidade delas.
todas_solucoes(N, Solucoes) :-
    findall(Qs, rainhas(N, Qs), Solucoes).

contar_solucoes(N, Total) :-
    aggregate_all(count, rainhas(N, _), Total).

% tabuleiro(+Qs, -Linhas): relação entre uma solução e o seu desenho,
% uma string por linha ('Q' = rainha, '.' = casa vazia).
% maplist/3 aplica a regra a cada elemento — sem laço explícito.
tabuleiro(Qs, Linhas) :-
    length(Qs, N),
    numlist(1, N, Ns),
    maplist(linha_do_tabuleiro(Qs), Ns, Linhas).

linha_do_tabuleiro(Qs, Linha, Texto) :-
    maplist(casa(Linha), Qs, Casas),
    atomic_list_concat(Casas, ' ', Texto).

casa(Linha, Q, Casa) :-
    ( Q =:= Linha -> Casa = 'Q' ; Casa = '.' ).

% Resolve e mostra a solução desenhada.
% Pedindo ';' no SWISH, o Prolog volta e mostra a próxima solução.
resolver(N) :-
    rainhas(N, Qs),
    tabuleiro(Qs, Linhas),
    format("Solução: ~w~n", [Qs]),
    forall(member(L, Linhas), format("~w~n", [L])).

/** <examples>
?- rainhas(4, Qs).
?- rainhas(8, Qs).
?- resolver(8).
?- rainhas(8, Qs), tabuleiro(Qs, Linhas).
?- rainhas_v1(6, Qs).
?- todas_solucoes(4, S).
?- contar_solucoes(8, Total).
?- time(rainhas_v1(8, _)), time(rainhas(8, _)).
*/
