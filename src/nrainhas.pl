/*  N-Rainhas com backtracking — Grupo 04 (L2)
    Paradigmas de Linguagens de Programação — Prolog (SWISH)

    COMO USAR: digite   ajuda.   na caixa ?- e clique em Run!

    Representação: uma solução é uma lista Qs = [Q1, Q2, ..., QN] em que
    Qi é a LINHA da rainha que está na COLUNA i. Como cada coluna tem
    exatamente uma rainha e a lista é uma permutação de 1..N, ataques por
    linha ou coluna são impossíveis por construção: só falta checar as
    diagonais.

    Nenhuma pilha, laço ou "desfazer jogada" é escrito à mão: quando um
    objetivo falha, o próprio Prolog volta (backtracking) ao último ponto
    de escolha e tenta a próxima alternativa.

    Três versões, da mais ingênua para a mais esperta:
      v1  gerar e testar ............ N até ~10
      v2  backtracking com poda ..... N até ~20
      v3  verificação adiante ....... N = 100, 200, 300... (principal)
*/

% ==================================================================
% 1. Quando duas rainhas se atacam?
% ==================================================================
% nao_ataca(+Q, +Rainhas, +D): a rainha Q não ataca nenhuma das Rainhas.
% D é a distância (em colunas) entre Q e a primeira rainha da lista.
% Duas rainhas estão na mesma diagonal quando a diferença de linhas
% é igual à diferença de colunas.
nao_ataca(_, [], _).
nao_ataca(Q, [Q1|Qs], D) :-
    Q =\= Q1 + D,
    Q =\= Q1 - D,
    D1 is D + 1,
    nao_ataca(Q, Qs, D1).

% segura(+Qs): nenhuma rainha de Qs ataca outra na diagonal.
segura([]).
segura([Q|Qs]) :-
    nao_ataca(Q, Qs, 1),
    segura(Qs).

% ==================================================================
% 2. v1 — Gerar e testar
% ==================================================================
% permutation/2 GERA um tabuleiro completo; segura/1 TESTA.
% Se o teste falha, o Prolog volta para permutation/2 e pede a próxima
% permutação. Simples, mas gera até N! tabuleiros.
rainhas_v1(N, Qs) :-
    numlist(1, N, Linhas),
    permutation(Linhas, Qs),
    segura(Qs).

% ==================================================================
% 3. v2 — Backtracking com poda
% ==================================================================
% Coloca uma rainha por coluna: select/3 escolhe uma linha ainda livre e
% nao_ataca/3 é testado IMEDIATAMENTE contra as rainhas já colocadas.
% Um ramo inválido é abandonado logo, sem montar o tabuleiro inteiro.
rainhas_v2(N, Qs) :-
    numlist(1, N, Linhas),
    posicionar(Linhas, [], Qs).

% posicionar(+LinhasLivres, +Colocadas, -Qs)
% Colocadas guarda a rainha mais recente na frente (é contra ela que
% nao_ataca/3 testa a distância 1); no fim invertemos a lista para a
% coluna 1 ficar na primeira posição.
posicionar([], Colocadas, Qs) :-
    reverse(Colocadas, Qs).
posicionar(Livres, Colocadas, Qs) :-
    select(Q, Livres, Resto),          % ponto de escolha
    nao_ataca(Q, Colocadas, 1),        % poda: falhou? volta ao select
    posicionar(Resto, [Q|Colocadas], Qs).

% ==================================================================
% 4. v3 — Verificação adiante + "first-fail" (versão principal)
% ==================================================================
% Continua sendo o backtracking nativo do Prolog, só que mais esperto.
% Cada coluna ainda vazia guarda o seu DOMÍNIO: as linhas que ainda
% são possíveis para ela. A cada passo:
%   1. procura o lugar com MENOS opções ("first-fail": se é para
%      falhar, que falhe logo, com a árvore ainda pequena). Pode ser
%      uma coluna com poucas linhas possíveis ou uma linha que só cabe
%      em poucas colunas;
%   2. member/2 escolhe uma das opções (ponto de escolha);
%   3. remove das outras colunas as linhas que essa rainha ataca
%      (verificação adiante). Se alguma coluna ou linha ficar sem
%      opção, falha na hora e o Prolog volta ao member/2.
% Colunas e linhas são tentadas do centro para as bordas.
%
% Recomeço: em raros valores de N (ex.: 120) a primeira escolha leva a
% um ramo enorme sem saída. Por isso a busca tem um teto de esforço
% (número de inferências, cerca de 3x o normal). Se passar do teto sem
% achar a primeira solução, recomeça desempatando por outro "centro".
rainhas(N, Qs) :-
    rainhas_v3(N, Qs).

rainhas_v3(N, Qs) :-
    Limite is max(2000000, 6 * N^3),
    Centro is (N + 1) / 2,
    findall(Meio,
            ( member(Desvio, [0, 0.5, -0.5, 1, -1, 1.5, -1.5, 2, -2]),
              Meio is Centro + Desvio ),
            Meios),
    com_recomeco(Meios, N, Limite, Qs).

% com_recomeco(+Meios, +N, +Limite, -Qs)
% Acha a 1ª solução dentro do limite; as seguintes (Next) vêm da mesma
% busca, sem limite. Se todas as tentativas estourarem, busca sem limite.
com_recomeco([], N, _, Qs) :-
    Meio is (N + 1) / 2,
    busca_v3(N, Meio, Qs).
com_recomeco([Meio|Outros], N, Limite, Qs) :-
    call_with_inference_limit(once(busca_v3(N, Meio, Primeira)), Limite, Resultado),
    (   Resultado == inference_limit_exceeded
    ->  com_recomeco(Outros, N, Limite, Qs)
    ;   (   Qs = Primeira
        ;   busca_v3(N, Meio, Qs),
            Qs \== Primeira
        )
    ).

% busca_v3(+N, +Meio, -Qs): a busca propriamente dita.
busca_v3(N, Meio, Qs) :-
    numlist(1, N, Ns),
    do_centro_para_fora(Meio, Ns, Ordem),
    maplist(com_dominio(Ordem), Ordem, Colunas),
    preencher(Colunas, Meio, [], Posicoes),
    msort(Posicoes, PorColuna),        % pares Coluna-Linha, por coluna
    pairs_values(PorColuna, Qs).

% com_dominio(+Dominio, +Coluna, -Coluna-Dominio)
com_dominio(Dominio, Coluna, Coluna-Dominio).

% do_centro_para_fora(+Meio, +Xs, -Ordem): Xs ordenada pela distância ao meio.
do_centro_para_fora(Meio, Xs, Ordem) :-
    map_list_to_pairs(distancia_do_meio(Meio), Xs, Pares),
    keysort(Pares, Ordenados),
    pairs_values(Ordenados, Ordem).

distancia_do_meio(Meio, X, D) :-
    D is abs(X - Meio).

% preencher(+Colunas, +Meio, +Acumulado, -Posicoes)
preencher([], _, Posicoes, Posicoes).
preencher(Colunas, Meio, Acumulado, Posicoes) :-
    escolher_casa(Colunas, Meio, C, L, Outras),  % ponto de escolha
    podar(Outras, C, L, Outras1),                % falhou? volta à escolha
    preencher(Outras1, Meio, [C-L|Acumulado], Posicoes).

% escolher_casa(+Colunas, +Meio, -C, -L, -Outras): escolhe onde pôr a
% próxima rainha olhando a coluna mais restrita E a linha mais restrita.
escolher_casa(Colunas, Meio, C, L, Outras) :-
    mais_restrita(Colunas, TamColuna, C0-Linhas),
    linhas_livres(Colunas, Meio, PorLinha),
    mais_restrita(PorLinha, TamLinha, L0-ColunasDaLinha),
    (   TamLinha < TamColuna
    ->  L = L0,
        member(C, ColunasDaLinha),
        selectchk(C-_, Colunas, Outras)
    ;   C = C0,
        selectchk(C0-Linhas, Colunas, Outras),
        member(L, Linhas)
    ).

% linhas_livres(+Colunas, +Meio, -PorLinha): para cada linha livre, as
% colunas em que ela ainda cabe (pares Linha-[Colunas]), das linhas do
% centro para as das bordas. Falha se alguma linha livre não cabe em
% mais nenhuma coluna.
linhas_livres(Colunas, Meio, PorLinha) :-
    findall(L-C, (member(C-Dominio, Colunas), member(L, Dominio)), Pares),
    msort(Pares, Ordenados),
    group_pairs_by_key(Ordenados, Grupos),
    length(Colunas, Livres),
    length(Grupos, Livres),
    map_list_to_pairs(distancia_da_linha(Meio), Grupos, ComDistancia),
    keysort(ComDistancia, PorDistancia),
    pairs_values(PorDistancia, PorLinha).

distancia_da_linha(Meio, Linha-_, D) :-
    distancia_do_meio(Meio, Linha, D).

% mais_restrita(+Opcoes, -Tamanho, -Escolhida): o par Chave-Lista de
% lista mais curta (em caso de empate, o que aparece primeiro).
mais_restrita(Opcoes, Tamanho, Escolhida) :-
    map_list_to_pairs(tamanho_do_dominio, Opcoes, Pares),
    keysort(Pares, [Tamanho-Escolhida|_]).

tamanho_do_dominio(_-Dominio, Tamanho) :-
    length(Dominio, Tamanho).

% podar(+Colunas, +C, +L, -Podadas): tira de cada coluna as linhas
% atacadas pela rainha em (C, L). Nenhum domínio pode ficar vazio.
podar([], _, _, []).
podar([C1-D1|Cs], C, L, [C1-D2|Cs2]) :-
    Distancia is abs(C1 - C),
    exclude(ataca(L, Distancia), D1, D2),
    D2 \== [],
    podar(Cs, C, L, Cs2).

% ataca(+L, +Distancia, +L1): rainha na linha L ataca a linha L1 de uma
% coluna que está a Distancia colunas dela.
ataca(L, _, L1) :- L1 =:= L.               % mesma linha
ataca(L, D, L1) :- L1 =:= L + D.           % diagonal descendo
ataca(L, D, L1) :- L1 =:= L - D.           % diagonal subindo

% ==================================================================
% 5. Consultas úteis
% ==================================================================
todas_solucoes(N, Solucoes) :-
    findall(Qs, rainhas(N, Qs), Solucoes).

contar_solucoes(N, Total) :-
    aggregate_all(count, rainhas(N, _), Total).

% valida(+Qs): confere uma solução de forma independente do algoritmo
% que a gerou: uma rainha por linha (permutação de 1..N) e nenhuma
% diagonal repetida.
valida(Qs) :-
    length(Qs, N),
    numlist(1, N, Linhas),
    msort(Qs, Linhas),
    segura(Qs).

% ==================================================================
% 6. Tabuleiro em texto (para o README, o relatório ou um terminal)
% ==================================================================
% tabuleiro(+Qs, -Linhas): relação pura entre uma solução e o seu
% desenho, uma linha de texto por linha do tabuleiro.
tabuleiro(Qs, Linhas) :-
    length(Qs, N),
    numlist(1, N, Ns),
    maplist(linha_de_texto(Qs), Ns, Linhas).

linha_de_texto(Qs, Linha, Texto) :-
    maplist(simbolo(Linha), Qs, Simbolos),
    atomic_list_concat(Simbolos, ' ', Texto).

simbolo(Linha, Q, Simbolo) :-
    ( Q =:= Linha -> Simbolo = 'Q' ; Simbolo = '.' ).

imprimir_tabuleiro(Qs) :-
    tabuleiro(Qs, Linhas),
    forall(member(Linha, Linhas), format("~w~n", [Linha])).

% ==================================================================
% 7. Tabuleiro gráfico no SWISH
% ==================================================================
% html/1 é do SWISH: recebe um TERMO Prolog que descreve a página
% (table, tr, td...) e o mostra na área de resultados. O tabuleiro
% abaixo é só um termo montado com maplist/3, como qualquer outro dado.

% tabuleiro_html(+Qs, +Lado, -Termo): Lado = tamanho de cada casa em px.
tabuleiro_html(Qs, Lado, table([class('nr-tab'), style(Tamanho)], Linhas)) :-
    length(Qs, N),
    format(atom(Tamanho), '--lado:~wpx', [Lado]),
    numlist(1, N, Ns),
    maplist(linha_html(Qs, Lado, N), Ns, Corpo),
    (   com_rotulos(N)
    ->  maplist(rotulo_html, Ns, Rotulos),
        Linhas = [tr([td(class('nr-rotulo'), '')|Rotulos])|Corpo]
    ;   Linhas = Corpo
    ).

com_rotulos(N) :- N =< 16.

rotulo_html(Numero, td(class('nr-rotulo'), Numero)).

linha_html(Qs, Lado, N, Linha, tr(Celulas)) :-
    numlist(1, N, Colunas),
    maplist(casa_html(Lado, Linha), Colunas, Qs, Casas),
    (   com_rotulos(N)
    ->  Celulas = [td(class('nr-rotulo'), Linha)|Casas]
    ;   Celulas = Casas
    ).

% casa_html(+Lado, +Linha, +Coluna, +Q, -Td): casa clara ou escura, com
% ou sem rainha. Em casas muito pequenas a rainha vira um ponto vermelho.
casa_html(Lado, Linha, Coluna, Q, td(class(Classes), Conteudo)) :-
    ( (Linha + Coluna) mod 2 =:= 0 -> Cor = 'nr-clara' ; Cor = 'nr-escura' ),
    (   Q =\= Linha -> Classes = [Cor],             Conteudo = []
    ;   Lado >= 14  -> Classes = [Cor, 'nr-rainha'], Conteudo = '♛'
    ;                  Classes = [Cor, 'nr-ponto'],  Conteudo = []
    ).

% lado_da_casa(+N, -Lado): o tabuleiro cresce com N até uns 420 px e,
% a partir daí, as casas é que diminuem.
lado_da_casa(N, Lado) :-
    Lado is max(3, min(44, 420 // N)).

% Até onde vale a pena desenhar (acima disso, só a lista).
maior_desenho(150).

% cartao(+Titulo, +Conteudo): moldura comum a todas as respostas.
cartao(Titulo, Conteudo) :-
    findall(Regra, regra_css(Regra), Regras),
    atomic_list_concat(Regras, Css),
    html(div(class('nr-cartao'),
             [ style(Css),
               div(class('nr-titulo'), ['♛ ', Titulo])
             | Conteudo ])).

% A aparência fica numa pequena base de fatos.
regra_css('.nr-cartao{font-family:Segoe UI,Helvetica,Arial,sans-serif;display:table;padding:12px 18px;margin:4px 0;border-radius:12px;background:#fbf7f0;border:1px solid #dcc9ab;color:#333;max-width:640px}').
regra_css('.nr-titulo{font-size:18px;font-weight:700;color:#5b3a1e;margin-bottom:4px}').
regra_css('.nr-info{color:#6b6b6b;margin:2px 0 10px}').
regra_css('.nr-tab{border-collapse:collapse;border:3px solid #5b3a1e;margin:4px 0}').
regra_css('.nr-tab td{padding:0;width:var(--lado);height:var(--lado);min-width:var(--lado);text-align:center;vertical-align:middle;line-height:var(--lado);font-size:calc(var(--lado)*0.72)}').
regra_css('.nr-clara{background:#f0d9b5}').
regra_css('.nr-escura{background:#b58863}').
regra_css('.nr-rainha{color:#1b1b1b;text-shadow:0 0 2px #fff}').
regra_css('.nr-ponto{background:#c0392b!important}').
regra_css('.nr-tab td.nr-rotulo{background:#fbf7f0;color:#8a6d4b;font-size:11px;font-weight:600}').
regra_css('.nr-lista{font-family:Consolas,monospace;font-size:12px;color:#444;word-break:break-all;margin-bottom:8px}').
regra_css('.nr-ok{color:#2e7d32;margin-top:10px;font-weight:600}').
regra_css('.nr-erro{color:#c0392b;font-weight:600}').
regra_css('.nr-dica{color:#8a6d4b;font-size:12px;margin-top:6px}').
regra_css('.nr-galeria{display:flex;flex-wrap:wrap;gap:12px}').
regra_css('.nr-mini{text-align:center;font-size:12px;color:#6b6b6b}').
regra_css('.nr-cmd{border-collapse:collapse}').
regra_css('.nr-cmd td{padding:3px 12px 3px 0;vertical-align:top}').
regra_css('.nr-cmd code{background:#efe4d2;padding:1px 6px;border-radius:4px;color:#5b3a1e}').
regra_css('.nr-comp{border-collapse:collapse;margin:6px 0}').
regra_css('.nr-comp td,.nr-comp th{border:1px solid #dcc9ab;padding:5px 12px;text-align:left}').
regra_css('.nr-comp th{background:#efe4d2;color:#5b3a1e}').

% ==================================================================
% 8. Comandos para o usuário
% ==================================================================
ajuda :-
    findall(tr([td(code(Exemplo)), td(Descricao)]),
            comando(Exemplo, Descricao),
            Linhas),
    cartao('N-Rainhas com backtracking · Grupo 04 (L2)',
           [ div(class('nr-info'), 'Digite um comando na caixa ?- e clique em Run!'),
             table(class('nr-cmd'), Linhas) ]).

% A lista de comandos também é uma base de fatos.
comando('resolver(8).',           'desenha uma solução; Next mostra a próxima').
comando('resolver(100).',         'tabuleiros grandes também (testado de N = 1 a 400)').
comando('mostrar_todas(6).',      'todas as soluções lado a lado (N até 8)').
comando('explicar(4).',           'o backtracking passo a passo (N até 6)').
comando('comparar(20).',          'tempo da v1, v2 e v3 para o mesmo N').
comando('contar_solucoes(8, T).', 'quantas soluções existem').
comando('rainhas(8, Qs).',        'a solução como lista (versão v3)').
comando('imprimir_tabuleiro([2,4,1,3]).', 'desenho em texto de uma solução').

% resolver(+N): mostra uma solução desenhada. Cada Next pede ao Prolog
% a próxima solução (backtracking). call_nth/2 numera as soluções e
% *-> só cai no "senão" se não houver nenhuma solução.
resolver(N) :-
    n_valido(N),
    statistics(cputime, T0),
    (   call_nth(rainhas(N, Qs), K)
    *-> statistics(cputime, T1),
        Tempo is T1 - T0,
        cartao_da_solucao(N, K, Qs, Tempo)
    ;   titulo_do_tabuleiro(N, Titulo),
        cartao(Titulo, [div(class('nr-erro'),
                            ['✗ Não existe solução para N = ', N, '.'])])
    ).

titulo_do_tabuleiro(N, Titulo) :-
    quantas_rainhas(N, Rainhas),
    format(atom(Titulo), '~w · tabuleiro ~w×~w', [Rainhas, N, N]).

quantas_rainhas(N, '1 rainha') :-
    N =:= 1.
quantas_rainhas(N, Texto) :-
    N > 1,
    format(atom(Texto), '~w rainhas', [N]).

cartao_da_solucao(N, K, Qs, Tempo) :-
    titulo_do_tabuleiro(N, Titulo),
    format(atom(Info), 'Solução nº ~w · encontrada em ~4f s', [K, Tempo]),
    format(atom(Lista), 'Qs = ~w', [Qs]),
    desenho_ou_aviso(Qs, Desenho),
    conferencia(Qs, Conferencia),
    cartao(Titulo,
           [ div(class('nr-info'), Info),
             div(class('nr-lista'), Lista),
             Desenho,
             Conferencia,
             div(class('nr-dica'),
                 '▶ Clique em Next: o Prolog volta (backtracking) e busca outra solução.')
           ]).

desenho_ou_aviso(Qs, Desenho) :-
    length(Qs, N),
    maior_desenho(Maximo),
    (   N =< Maximo
    ->  lado_da_casa(N, Lado),
        tabuleiro_html(Qs, Lado, Desenho)
    ;   format(atom(Aviso), '(tabuleiro ~w×~w grande demais para desenhar)', [N, N]),
        Desenho = div(class('nr-info'), Aviso)
    ).

conferencia(Qs, div(class('nr-ok'), Texto)) :-
    valida(Qs),
    !,
    length(Qs, N),
    quantas_rainhas(N, Rainhas),
    format(atom(Texto),
           '✔ Conferido: ~w, uma por linha e por coluna, nenhuma na mesma diagonal.',
           [Rainhas]).
conferencia(_, div(class('nr-erro'), '✗ Solução inválida!')).

% mostrar_todas(+N): todas as soluções, em miniatura, lado a lado.
mostrar_todas(N) :-
    n_valido(N),
    no_maximo(N, 8, mostrar_todas),
    findall(Qs, rainhas_v2(N, Qs), Todas),
    length(Todas, Total),
    findall(div(class('nr-mini'), [Mini, div(Legenda)]),
            ( nth1(K, Todas, Qs),
              tabuleiro_html(Qs, 18, Mini),
              format(atom(Legenda), 'nº ~w · ~w', [K, Qs]) ),
            Miniaturas),
    format(atom(Titulo), 'Todas as soluções para N = ~w', [N]),
    format(atom(Info), 'Total: ~w solução(ões).', [Total]),
    cartao(Titulo, [div(class('nr-info'), Info),
                    div(class('nr-galeria'), Miniaturas)]).

% explicar(+N): mostra o backtracking acontecendo, usando a lógica da v2.
explicar(N) :-
    n_valido(N),
    no_maximo(N, 6, explicar),
    format(atom(Titulo), 'Passo a passo do backtracking · N = ~w', [N]),
    cartao(Titulo,
           [ div(class('nr-info'),
                 'Coluna por coluna, o Prolog tenta as linhas em ordem.'),
             div('✓ cabe    ✗ atacada    ↩ backtracking: volta e tenta outra linha') ]),
    numlist(1, N, Linhas),
    (   explorar(Linhas, [], 1, Qs)
    ->  format(atom(Fim), 'Solução encontrada: ~w', [Qs]),
        tabuleiro_html(Qs, 40, Desenho),
        cartao(Fim, [Desenho])
    ;   format(atom(Fim), 'Todas as possibilidades falharam: não há solução para N = ~w.', [N]),
        cartao(Fim, [])
    ).

% explorar/4 é o posicionar/3 da v2 com mensagens. A segunda alternativa
% da disjunção só roda quando TODAS as linhas da coluna já falharam:
% é exatamente o momento em que o Prolog faz o backtracking.
explorar([], Colocadas, _, Qs) :-
    reverse(Colocadas, Qs).
explorar(Livres, Colocadas, Coluna, Qs) :-
    Livres = [_|_],
    (   select(Q, Livres, Resto),
        tentar(Q, Colocadas, Coluna),
        Proxima is Coluna + 1,
        explorar(Resto, [Q|Colocadas], Proxima, Qs)
    ;   recuo(Coluna, Espaco),
        para_onde_volta(Coluna, Destino),
        format("~w↩ coluna ~w sem saída: ~w~n", [Espaco, Coluna, Destino]),
        fail
    ).

para_onde_volta(Coluna, 'não há mais o que tentar') :-
    Coluna =:= 1.
para_onde_volta(Coluna, Destino) :-
    Coluna > 1,
    Anterior is Coluna - 1,
    format(atom(Destino), 'volta para a coluna ~w', [Anterior]).

tentar(Q, Colocadas, Coluna) :-
    recuo(Coluna, Espaco),
    (   nao_ataca(Q, Colocadas, 1)
    ->  format("~w✓ coluna ~w → linha ~w~n", [Espaco, Coluna, Q])
    ;   format("~w✗ coluna ~w → linha ~w (atacada)~n", [Espaco, Coluna, Q]),
        fail
    ).

recuo(Coluna, Espaco) :-
    Tamanho is 2 + 3 * (Coluna - 1),
    length(Espacos, Tamanho),
    maplist(=(' '), Espacos),
    atomic_list_concat(Espacos, Espaco).

% comparar(+N): tempo de cada versão para achar a primeira solução.
comparar(N) :-
    n_valido(N),
    findall(tr([td(Nome), td(Texto)]),
            ( versao(Id, Nome, Maximo), medir(Id, N, Maximo, Texto) ),
            Linhas),
    format(atom(Titulo), 'Comparando as 3 versões · N = ~w', [N]),
    cartao(Titulo,
           [ div(class('nr-info'), 'Tempo para achar a primeira solução:'),
             table(class('nr-comp'), [tr([th('Versão'), th('Tempo')])|Linhas]),
             div(class('nr-dica'),
                 'As três usam o MESMO mecanismo, o backtracking nativo do Prolog. O que muda é quanto da árvore de busca cada uma consegue podar.')
           ]).

% versao(Id, Nome, MaiorN): MaiorN evita esperar minutos na v1 e na v2.
versao(v1, 'v1 · gerar e testar',        10).
versao(v2, 'v2 · backtracking com poda', 20).
versao(v3, 'v3 · verificação adiante',   400).

executar(v1, N, Qs) :- rainhas_v1(N, Qs).
executar(v2, N, Qs) :- rainhas_v2(N, Qs).
executar(v3, N, Qs) :- rainhas_v3(N, Qs).

medir(Id, N, Maximo, Texto) :-
    (   N > Maximo
    ->  format(atom(Texto), 'não roda (lenta demais para N > ~w)', [Maximo])
    ;   statistics(cputime, T0),
        (   executar(Id, N, _)
        ->  statistics(cputime, T1),
            Tempo is T1 - T0,
            format(atom(Texto), '~4f s', [Tempo])
        ;   Texto = 'sem solução'
        )
    ).

% --- Validação da entrada -------------------------------------------
n_valido(N) :-
    (   integer(N), N >= 1
    ->  true
    ;   format("⚠ N precisa ser um número inteiro maior que zero (recebi: ~w).~n", [N]),
        fail
    ).

no_maximo(N, Maximo, Comando) :-
    (   N =< Maximo
    ->  true
    ;   format("⚠ ~w aceita N até ~w; acima disso a saída fica enorme.~n", [Comando, Maximo]),
        fail
    ).

/** <examples>
?- ajuda.
?- resolver(8).
?- resolver(100).
?- mostrar_todas(6).
?- explicar(4).
?- comparar(20).
?- contar_solucoes(8, Total).
?- rainhas(8, Qs).
?- imprimir_tabuleiro([2,4,1,3]).
*/
