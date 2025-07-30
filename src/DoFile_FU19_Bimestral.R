# ============================================================
# Script: DoFile_FU19_Bimestral.R
# Objetivo: Coletar dados da API RREO (SICONFI)
#           para todos os entes federativos,
#           de 2015 até o ano atual, consolidando por bimestre,
#           filtrando Função 19 - Ciência e Tecnologia.
# Fonte do mapeamento de funções:
# Manual Técnico de Orçamento – MTO 2026 (SOF)
# https://www1.siop.planejamento.gov.br/mto/doku.php/mto2026
# ============================================================

library(httr)
library(jsonlite)
library(dplyr)

ufs <- c(
  12, 27, 13, 16, 29, 23, 53, 32, 52, 21, 31, 50,
  51, 15, 25, 26, 22, 41, 33, 24, 11, 14, 43, 42,
  28, 35, 17
)

anos <- 2015:2025
bimestres <- 1:6
tipo_demonstrativo <- "RREO"
anexo <- "RREO-Anexo 02"
contas <- c(
  "Ciência e Tecnologia",
  "Desenvolvimento Científico",
  "Desenvolvimento Tecnológico e Engenharia",
  "Difusão do Conhecimento Científico e Tecnológico",
  "FU19 - Administração Geral",
  "FU19 - Demais Subfunções"
)

resultado <- data.frame(
  uf = character(),
  cod_ibge = integer(),
  ano = integer(),
  bimestre = integer(),
  gasto_liquidado = numeric(),
  stringsAsFactors = FALSE
)

for (ano in anos) {
  for (bimestre in bimestres) {
    for (id_ente in ufs) {
      cat("Ano:", ano, "| Bimestre:", bimestre, "| UF:", id_ente, "\n")
      
      url <- paste0(
        "https://apidatalake.tesouro.gov.br/ords/siconfi/tt/rreo?",
        "an_exercicio=", ano,
        "&nr_periodo=", bimestre,
        "&co_tipo_demonstrativo=", tipo_demonstrativo,
        "&id_ente=", id_ente,
        "&no_anexo=", URLencode(anexo)
      )
      
      res <- GET(url)
      if (status_code(res) != 200) next
      
      dados <- fromJSON(content(res, as = "text", encoding = "UTF-8"))
      if (length(dados$items) == 0) next
      df <- as.data.frame(dados$items)
      
      df_fun19 <- df %>%
        filter(
          coluna == "DESPESAS LIQUIDADAS ATÉ O BIMESTRE (d)",
          rotulo == "Total das Despesas Exceto Intra-Orçamentárias",
          conta %in% contas
        )
      
      gasto <- sum(df_fun19$valor, na.rm = TRUE)
      
      resultado <- rbind(
        resultado,
        data.frame(
          uf = unique(df$uf),
          cod_ibge = id_ente,
          ano = ano,
          bimestre = bimestre,
          gasto_liquidado = gasto
        )
      )
      
      Sys.sleep(1) # respeita limite de 1 req/s
    }
  }
}

resultado

# Exportar para CSV
# out_file <- "~/ciencia_tec_liquidadas_bimestrais.csv"
# write.csv(resultado, out_file, row.names = FALSE)