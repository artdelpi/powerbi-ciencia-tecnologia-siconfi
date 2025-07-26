# Data Dictionary

Este documento descreve as colunas, descrições e fontes usadas no projeto.

---

## **1. Dataset: ciencia_tec_bi_2019_atual.csv**

**Fonte:** API SICONFI – MSC Orçamentária.  
**Descrição:** Contém informações de execução orçamentária da Função 19 (Ciência e Tecnologia) por estado e bimestre.

**Colunas:**
- **`exercicio`**: Ano de referência (2019 até atual).
- **`bimestre`**: Bimestre do ano (1 a 6).
- **`uf`**: Código IBGE do estado.
- **`funcao`**: Código da função orçamentária (19 = Ciência e Tecnologia).
- **`nome_funcao`**: Nome da função orçamentária.
- **`valor_total`**: Valor total das despesas em R$ (somatório do bimestre).

---

## **2. Dataset: top50_universidades_ano_estado.csv**

**Fonte:** API OpenAlex – Institutions e Works.  
**Descrição:** Contém o número de artigos científicos publicados por ano, considerando as Top 57 universidades do Brasil segundo CWUR.

**Colunas:**
- **`Universidade`**: Nome da instituição (ex: University of São Paulo).
- **`Estado`**: UF associada à instituição (SP, RJ, MG, etc.).
- **`Ano`**: Ano de publicação (2019 até atual).
- **`Artigos`**: Total de artigos de periódicos publicados no ano.

---

## **3. Dataset: estados.csv**

**Fonte:** Mapeamento interno (IBGE).  
**Descrição:** Contém o nome completo, longitude, latitude e código IBGE das 27 unidades federativas.

**Colunas:**
- **`cod_ibge`**: Código IBGE da UF.
- **`uf`**: Sigla da UF (SP, RJ etc.).
- **`estado`**: Nome completo do estado.
