# Data Dictionary

Este documento descreve as colunas, descrições e fontes usadas no projeto.

---

## **1. Dataset: ciencia_tec_liquidadas_bimestrais.csv**

**Fonte:** API SICONFI – RREO (Relatório Resumido da Execução Orçamentária – Anexo 02).  
**Descrição:** Contém informações de execução orçamentária da **Função 19 (Ciência e Tecnologia)** e suas subfunções, por estado e bimestre, considerando apenas **Despesas Liquidadas no Bimestre** e excluindo despesas intra-orçamentárias.

**Filtros aplicados:**
- **Coluna (`coluna`)**: `DESPESAS LIQUIDADAS NO BIMESTRE`
- **Conta (`conta`)**: 
  - `Ciência e Tecnologia`
  - `Desenvolvimento Científico (571)`
  - `Desenvolvimento Tecnológico e Engenharia (572)`
  - `Difusão do Conhecimento Científico e Tecnológico (573)`
  - `FU19 - Administração Geral`
  - `FU19 - Demais Subfunções`
- **Rotulo (`rotulo`)**: `Total das Despesas Exceto Intra-Orçamentárias`

**Colunas:**
- **`uf`**: Sigla da unidade federativa (ex: SP, RJ, MG).
- **`cod_ibge`**: Código IBGE do estado.
- **`ano`**: Ano de referência (2015 até o ano atual).
- **`bimestre`**: Bimestre do ano (1 a 6).
- **`conta`**: Nome da função ou subfunção orçamentária (ex: Ciência e Tecnologia, Desenvolvimento Científico).
- **`gasto_liquidado`**: Valor total liquidado no bimestre em R$.

---

## **2. Dataset: top50_universidades_ano_estado.csv**

**Fonte:** API OpenAlex – Institutions e Works.  
**Descrição:** Contém o número de artigos científicos publicados por ano, considerando as Top 57 universidades do Brasil segundo CWUR.

**Colunas:**
- **`Universidade`**: Nome da instituição (ex: University of São Paulo).
- **`Estado`**: UF associada à instituição (SP, RJ, MG, etc.).
- **`Ano`**: Ano de publicação (2019 até o ano atual).
- **`Artigos`**: Total de artigos de periódicos publicados no ano.

---

## **3. Dataset: estados.csv**

**Fonte:** Mapeamento interno (IBGE).  
**Descrição:** Contém o nome completo, longitude, latitude e código IBGE das 27 unidades federativas.

**Colunas:**
- **`cod_ibge`**: Código IBGE da UF.
- **`uf`**: Sigla da UF (SP, RJ etc.).
- **`estado`**: Nome completo do estado.
