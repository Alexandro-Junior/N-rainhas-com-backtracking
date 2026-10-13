# Plano do Projeto — Grupo 04 · L2 N-Rainhas com Backtracking

**Disciplina:** Paradigmas de Linguagens de Programação — Prof. Cid Rodrigues de Andrade
**Paradigma:** Lógico · **Linguagem:** Prolog (SWI) · **Ambiente:** [swish.swi-prolog.org](https://swish.swi-prolog.org)
**Seminário:** 11/11/2026 · **Início do plano:** 13/10/2026

| # | Integrante | RGM |
|---|---|---|
| 1 | Alexandro de Araujo Junior | 34625127 |
| 2 | Caique dos Santos Alves | 39165566 |
| 3 | Duquesnio Daniel Bandessa | 33856885 |
| 4 | Victor Alves Souza dos Santos | 34696466 |

---

## 1. O que vale nota (A2 = 5,0)

| Componente | Peso | O que garante a nota |
|---|---|---|
| Trabalho (código + relatório) | 3,0 | ver rubrica abaixo |
| Seminário | 1,0 | ver rubrica abaixo |
| Prova individual (leitura de código Haskell, Prolog **e** Go) | 1,0 | todos estudam os 3 paradigmas, não só Prolog |

### Rubrica do trabalho (3,0)
| Critério | Pts | Como vamos garantir |
|---|---|---|
| Código roda no permalink e resolve o problema | 1,0 | permalink SWISH testado em aba anônima, por 2 pessoas diferentes |
| **Uso idiomático do paradigma** (não "C disfarçado") | 0,75 | regras declarativas, recursão, unificação, backtracking nativo — **sem** simular laços/pilha/contadores à moda C |
| Relatório com análise comparativa | 0,75 | 4 tópicos (sintaxe, semântica, memória, trade-offs) com código C/Java lado a lado |
| Clareza: permalink + entrada/saída documentada | 0,5 | entrada/saída **copiadas da execução real** no SWISH |

### Rubrica do seminário (1,0)
| Critério | Pts |
|---|---|
| Domínio do conteúdo e clareza | 0,35 |
| Demo ao vivo no SWISH (levar prints de backup) | 0,3 |
| Participação equilibrada + respostas às perguntas | 0,15 |
| Postura profissional (roupa, postura, comunicação) | 0,1 |
| Slides e tempo (~15 min) | 0,1 |

---

## 2. Checklist de entrega (link do GitHub)

- [ ] `Paradigma04.pdf` **na raiz** do repositório — nome exato, faz parte da nota
- [ ] PDF em **formato ABNT** com: descrição da solução e como executar · análise comparativa · log de IA · entrada/saída de exemplo
- [ ] Arquivo-fonte `.pl` no repositório
- [ ] Permalink SWISH funcionando em **aba anônima**
- [ ] `README.md` seguindo o esqueleto (mesma ordem, sem apagar títulos)
- [ ] Log de uso de IA preenchido (README e PDF)

## 3. Estrutura do repositório

```
/
├── README.md               ← esqueleto do professor preenchido
├── Paradigma04.pdf         ← relatório ABNT (nome obrigatório)
├── PLANO.md                ← este arquivo
├── src/
│   └── nrainhas.pl         ← código final (idêntico ao do SWISH)
├── comparacao/
│   └── NRainhas.java       ← mesma solução em Java, só para a análise comparativa
├── docs/
│   └── prints/             ← capturas do SWISH (backup da demo)
└── slides/                 ← apresentação do seminário
```

---

## 4. Etapas e cronograma

| # | Etapa | Entregável | Prazo | Responsável |
|---|---|---|---|---|
| 1 | **Setup** | Repositório com estrutura, README e plano; todos com acesso de escrita | 15/10 | Alexandro |
| 2 | **Estudo de Prolog** | Cada um roda no SWISH: fatos, regras, unificação, listas, recursão, `;` para pedir próxima solução | 19/10 | Todos |
| 3 | **Código v1 — gerar e testar** | `permutation/2` gera candidatos, regra `segura/1` testa diagonais | 23/10 | Caique |
| 4 | **Código v2 — com poda** | Coloca uma rainha por vez com `select/3` e só segue se for segura (corta ramos cedo) + `contar_solucoes/2` + impressão do tabuleiro | 27/10 | Duquesnio |
| 5 | **SWISH + permalink** | Programa salvo no SWISH com consultas de exemplo; teste em aba anônima | 28/10 | Alexandro |
| 6 | **Versão Java para comparação** | Backtracking manual (recursão + desfazer jogada), com comentários | 28/10 | Victor |
| 7 | **Testes e medições** | Tabela N = 4, 6, 8, 10 (2, 4, 92, 724 soluções) + tempos v1 × v2; saídas copiadas do SWISH; prints | 31/10 | Caique + Duquesnio |
| 8 | **Relatório ABNT** | Rascunho dos 4 tópicos da análise (divisão abaixo) | 03/11 | Todos |
| 9 | **Montagem do PDF** | `Paradigma04.pdf` (capa, sumário, seções, referências ABNT) | 05/11 | Alexandro + Victor |
| 10 | **README final** | Seções do esqueleto + resumo da análise + log de IA | 06/11 | Alexandro |
| 11 | **Slides** | Roteiro de ~15 min, cada integrante com uma parte | 07/11 | Todos |
| 12 | **Ensaio + simulado de perguntas** | Cada um explica **qualquer** trecho do código; cronometrar | 09/11 | Todos |
| 13 | **Revisão final** | Checklist da seção 2 conferido; permalink retestado | 10/11 | Todos |
| — | **Seminário** | Apresentação + demo ao vivo | **11/11** | Todos |

> ⚠️ O enunciado não traz a data limite da entrega do link. **Confirmar com o professor** — se for antes de 11/11, antecipar as etapas 9–13.

### Divisão da análise comparativa (cada um escreve um, todos estudam os quatro)
| Tópico | Responsável | Pontos a cobrir |
|---|---|---|
| **Sintaxe** | Victor | Prolog declara *o que é* uma solução; Java descreve *como* procurá-la. Comparar nº de linhas e trechos lado a lado |
| **Semântica** | Caique | Unificação × atribuição; variáveis lógicas (atribuídas uma vez); backtracking cronológico automático; tipagem dinâmica; escopo de variável = cláusula |
| **Memória** | Duquesnio | Pilhas da WAM + *trail* que desfaz ligações ao retroceder; coletor de lixo do SWI. Contra: pilha/arrays e `malloc/free` manuais em C; heap + GC da JVM em Java |
| **Trade-offs** | Alexandro | Código curto, enumera todas as soluções de graça × desempenho depende da ordem dos objetivos, depuração mais difícil, pouco controle de baixo nível |

### Roteiro sugerido do seminário (~15 min)
| Tempo | Parte | Quem |
|---|---|---|
| 2 min | Problema das N-rainhas e o paradigma lógico | Alexandro |
| 4 min | O código Prolog, regra por regra | Caique |
| 3 min | **Demo ao vivo no SWISH** (N=4, N=8, `;` mostrando o backtracking) | Duquesnio |
| 4 min | Comparação com Java (backtracking manual × nativo) | Victor |
| 2 min | Trade-offs, conclusão e perguntas | Todos |

---

## 5. Regras do grupo

- **Uso de IA:** permitido, mas **anotar tudo** em `log-ia.md` durante o projeto (o que foi pedido, qual IA/modelo, o que foi aproveitado, o que reescrevemos/entendemos). Qualquer integrante pode ser questionado sobre qualquer trecho — se a IA gerou, alguém do grupo tem que saber explicar.
- **Git:** uma branch por etapa (ex.: `feat/v2-poda`, `docs/analise-semantica`), Pull Request revisado por outro integrante antes do merge na `main`.
- **Código:** o `.pl` do repositório e o do permalink devem ser **sempre idênticos**.
- **Prova individual:** reservar tempo para ler exemplos de Haskell e Go também.
- **Seminário:** ausência só com comprovante legal; roupa adequada.
