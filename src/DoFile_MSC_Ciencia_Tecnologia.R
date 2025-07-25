# ============================================================
# Script: DoFile_MSC_Ciencia_Tecnologia_All.R
# Objetivo: Coletar dados da API msc_orcamentaria (SICONFI)
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
library(stringr)
library(knitr)
library(lubridate)

# URL base da API MSC Orçamentária
base_url_msc <- "https://apidatalake.tesouro.gov.br/ords/siconfi/tt/msc_orcamentaria?"

# Mapeamento de funções (MTO 2026) 
funcoes_map <- data.frame(
  funcao = sprintf("%02d", c(1:28, 99)),
  nome_funcao = c(
    "Legislativa", "Judiciária", "Essencial à Justiça", "Administração",
    "Defesa Nacional", "Segurança Pública", "Relações Exteriores",
    "Assistência Social", "Previdência Social", "Saúde",
    "Trabalho", "Educação", "Cultura", "Direitos da Cidadania",
    "Urbanismo", "Habitação", "Saneamento", "Gestão Ambiental",
    "Ciência e Tecnologia", "Agricultura", "Organização Agrária",
    "Indústria", "Comércio e Serviços", "Comunicações", "Energia",
    "Transporte", "Desporto e Lazer", "Encargos Especiais",
    "Reserva de Contingência"
  )
)

# Lista de códigos IBGE das UFs 
ufs <- c(12, 27, 13, 16, 29, 23, 53, 32, 52, 21, 31, 50,
         51, 15, 25, 26, 22, 41, 33, 24, 11, 14, 43, 42,
         28, 35, 17)

# Função para consultar a API MSC 
get_msc_orc <- function(ano, mes, uf) {
  url <- paste0(base_url_msc,
                "id_ente=", uf,
                "&an_referencia=", ano,
                "&me_referencia=", mes,
                "&co_tipo_matriz=MSCC",
                "&classe_conta=6",
                "&id_tv=period_change")
  
  res <- GET(url)
  if (status_code(res) != 200) return(NULL)
  
  res_txt <- content(res, as = "text", encoding = "UTF-8")
  res_json <- fromJSON(res_txt, flatten = FALSE)
  
  if (length(res_json[["items"]]) == 0) return(NULL)
  
  df <- as.data.frame(res_json[["items"]])
  return(df)
}

# Loop para coletar os dados 
ano_inicio <- 2015
ano_atual <- year(Sys.Date())
meses <- 1:12
all_data <- list()

cat("Coletando dados de 2015 até", ano_atual, "...\n")

for (ano in ano_inicio:ano_atual) {
  for (mes in meses) {
    for (uf in ufs) {
      cat("Processando UF:", uf, "| Ano:", ano, "| Mês:", mes, "\n")
      df <- get_msc_orc(ano, mes, uf)
      if (!is.null(df)) {
        all_data[[length(all_data) + 1]] <- df
      }
      #Sys.sleep(1) # respeita 1 requisição/segundo
    }
  }
}

# Consolidar dados 
df_all <- bind_rows(all_data)

# Filtrar Ciência e Tecnologia (Função 19) 
df_ciencia <- df_all %>%
  left_join(funcoes_map, by = "funcao") %>%
  filter(funcao == "19") %>%
  select(exercicio, mes_referencia, uf = cod_ibge, funcao, nome_funcao,
         subfuncao, natureza_despesa, valor)

# Criar coluna Bimestre 
df_ciencia <- df_ciencia %>%
  mutate(bimestre = case_when(
    mes_referencia %in% c(1, 2) ~ 1,
    mes_referencia %in% c(3, 4) ~ 2,
    mes_referencia %in% c(5, 6) ~ 3,
    mes_referencia %in% c(7, 8) ~ 4,
    mes_referencia %in% c(9, 10) ~ 5,
    mes_referencia %in% c(11, 12) ~ 6
  ))

# Agrupar por Ano, Bimestre e UF
df_ciencia_bimestre <- df_ciencia %>%
  group_by(exercicio, bimestre, uf, funcao, nome_funcao) %>%
  summarise(valor_total = sum(valor, na.rm = TRUE), .groups = "drop")

# Exportar para CSV 
out_file <- "C:/Users/artde/Downloads/dados_ciencia_tecnologia_bimestre_2015_hoje.csv"
write.csv(df_ciencia_bimestre, out_file, row.names = FALSE)
cat("Arquivo CSV gerado em:", out_file, "\n")
