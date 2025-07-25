# Painel MSC – Análise de Ciência e Tecnologia (Função 19)

Este projeto disponibiliza um **dashboard interativo em Power BI** para análise das **despesas da Função 19 (Ciência e Tecnologia)**, obtidas diretamente da **API do Tesouro Transparente (SICONFI)** por meio do endpoint `msc_orcamentaria`.

O painel permite ver a **execução orçamentária** da Função 19 em **todos os estados da federação**, com dados consolidados **de 2015 até o ano atual**, agrupados por **bimestres**.

---

## Destaques do Painel

- **Ciência e Tecnologia:** análise exclusiva dos gastos públicos classificados como Função 19, conforme a Classificação Funcional do **MTO 2026**.  
- **Comparativo entre Estados:** visualização e ranking de despesas entre todos os entes federativos.  
- **Série Histórica (2015–Atual):** evolução dos gastos por bimestre e por ano, com indicadores de tendência.  
- **Mapa Interativo:** visão geográfica das despesas por UF.

---

## Coleta de Dados

Os dados são extraídos da API do SICONFI utilizando os seguintes parâmetros obrigatórios:
- **`id_ente`**: Código IBGE do estado (ex: 33 = Rio de Janeiro);
- **`an_referencia`**: Ano de referência (2015 até o atual);
- **`me_referencia`**: Mês (1 a 12);
- **`co_tipo_matriz`**: `MSCC` (matriz mensal agregada);
- **`classe_conta`**: 6 (Execução Orçamentária);
- **`id_tv`**: `period_change` (movimento do período).


O script em R percorre automaticamente:
- Todos os anos de 2015 até o ano atual;
- Todos os 12 meses do ano, organizado em **6 bimestres**;
- Todos os 27 entes federativos (estados + Distrito Federal).

---

## Uso do Script R no Power BI

O projeto usa o script `DoFile_MSC_Ciencia_Tecnologia_All.R` para:
- Baixar e organizar os dados da Função 19 diretamente da API SICONFI;
- Criar uma coluna de **bimestres (1 a 6)** a partir dos meses de referência;
- Gerar um arquivo CSV (`dados_ciencia_tecnologia_bimestre_2015_hoje.csv`) pronto para importação no Power BI.

**Vantagem:** o script busca os dados mais atualizados sempre que executado.  
**Observação:** a coleta pode demorar devido ao limite da API (1 requisição por segundo).

---

## Alternativa Rápida: CSV Pré-Gerado

Para maior agilidade, o repositório inclui um arquivo `.csv` com os dados já processados, atualizado até a última execução do script.

### Caminho:
- **Obter Dados > Texto/CSV** no Power BI, ou  
- **Script R:**  
  ```r
  read.csv("dados/dados_ciencia_tecnologia_bimestre_2015_hoje.csv")
