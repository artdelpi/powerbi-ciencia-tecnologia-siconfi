# Painel MSC – Análise de Ciência e Tecnologia (Função 19) e Produção Científica

Este projeto disponibiliza um **dashboard interativo em Power BI** para análise das **despesas da Função 19 (Ciência e Tecnologia)**, obtidas diretamente da **API do Tesouro Transparente (SICONFI)** por meio do endpoint `msc_orcamentaria`.  
Além disso, foram integrados **dados de produção científica** obtidos da **API OpenAlex**, possibilitando **correlacionar investimentos públicos com a produção acadêmica (número de artigos científicos) por estado e por ano**.

O painel permite:
- Visualizar a **execução orçamentária** da Função 19 em todos os estados da federação, com dados **de 2019 até o ano atual**.
- Analisar a **produção científica** (artigos de periódicos revisados por pares) das **Top 57 universidades do Brasil** segundo o ranking **CWUR**, distribuída por estado e ao longo do tempo.
- Identificar tendências e correlações entre **gastos públicos** e **número de publicações**.

---

<p align="center">
  <img src="docs/demo.png" alt="Visão geral do dashboard de Ciência e Tecnologia" width="600px">
  <br>
  <em>Figura 1 – Painel interativo em Power BI com dados de despesas e produção científica por estado.</em>
</p>

---

## Destaques do Painel

- **Ciência e Tecnologia:** análise exclusiva dos gastos públicos classificados como Função 19, conforme a Classificação Funcional do **MTO 2026**.  
- **Produção Científica:** número de artigos publicados em periódicos (2019–Atual) das **Top 57 universidades brasileiras (CWUR)**.  
- **Comparativo entre Estados:** visualização e ranking de despesas e produção acadêmica.  
- **Correlação Investimento × Produção:** análise dos dados orçamentários com a produção científica anual por estado.  
- **Série Histórica (2019–Atual):** evolução dos indicadores em linha do tempo.  
- **Mapa Interativo:** visão geográfica das despesas e da quantidade de artigos.

---

## Coleta de Dados

### **Despesas Públicas (SICONFI)**
- **Endpoint:** `msc_orcamentaria` (API Tesouro Nacional).  
- **Filtros utilizados:**  
  - **`id_ente`**: Código IBGE do estado (ex: 33 = Rio de Janeiro);
  - **`an_referencia`**: Ano de referência (2019 até o atual);
  - **`me_referencia`**: Mês (1 a 12);
  - **`co_tipo_matriz`**: `MSCC` (matriz mensal agregada);
  - **`classe_conta`**: 6 (Execução Orçamentária);
  - **`id_tv`**: `period_change` (movimento do período).

### **Produção Científica (OpenAlex)**
- **Endpoint:** `works` e `institutions`.  
- **Filtros utilizados:**  
  - **Instituições:** Top 57 universidades do Brasil (CWUR).  
  - **Tipo de publicação:** `type_crossref=journal-article`.  
  - **Período:** 2019 até o ano atual.  
  - **Outros filtros:** `is_paratext=false`, `primary_location.source.type=journal`.  

---

## Uso do Script R no Power BI

O projeto utiliza dois scripts principais:
- **`DoFile_MSC_Ciencia_Tecnologia_All.R`**  
  Para extrair e organizar dados de execução orçamentária. A tabela resultante já é processada e estruturada para revelar o gasto total por bimestre de cada ano, para cada UF e especificamente na função 19 do MTO.
- **`DoFile_OpenAlex_Artigos.R`**  
  Para extrair e consolidar o número de artigos científicos por universidade, estado e ano.

Ambos os scripts geram arquivos `.csv` prontos para importação no Power BI:
- `ciencia_tec_bi_2019_atual.csv` (com gastos totais por bimestre, por ente e por ano, na função 19 do MTO)
- `top50_universidades_ano_estado.csv` (com dados de artigos científicos).

---

## Alternativa Rápida: CSV Pré-Gerado

O repositório inclui arquivos `.csv` pré-processados:
- **Despesas:** `ciencia_tec_bi_2019_atual.csv`
- **Artigos Científicos:** `top50_universidades_ano_estado.csv`

Esses arquivos permitem carregar rapidamente os dados no Power BI via **Obter Dados > Texto/CSV**.

## Estrutura do Projeto

```text
POWERBI-CIENCIA-TECNOLOGIA-SICONFI/
│
├── data/                     # Dados processados
│   ├── ciencia_tec_bi_2019_atual.csv
│   ├── estados.csv
│   ├── top50_universidades_ano_estado.csv
│
├── docs/                     # Documentação e captura de tela
│   ├── api-reference.md
│   ├── data-dictionary.md
│   └── demo.png
│
├── src/                      # Scripts R
│   ├── DoFile_MSC_Ciencia_Tecnologia.R
│   └── DoFile_OpenAlex_Artigos.R
│
├── .gitignore
├── README.md
└── Dashboard_Ciencia_Tecnologia.pbix  # Arquivo Power BI
```
