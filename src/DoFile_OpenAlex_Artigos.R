library(httr)
library(jsonlite)
library(dplyr)

# Lista de universidades ("Top Universities in Brazil in 2021-2022 | CWUR")
universidades <- c(
  "University of São Paulo",
  "University of Campinas",
  "Federal University of Rio de Janeiro",
  "São Paulo State University",
  "Federal University of Rio Grande do Sul",
  "Federal University of Minas Gerais",
  "Federal University of São Paulo",
  "Rio de Janeiro State University",
  "Oswaldo Cruz Foundation",
  "Federal University of Santa Catarina",
  "Federal University of Paraná",
  "Brazilian Center for Research in Physics (CBPF)",
  "Getúlio Vargas Foundation",
  "Federal University of Pernambuco",
  "University of Brasília",
  "Federal University of ABC",
  "Federal University of Viçosa",
  "Federal University of Ceará",
  "Federal University of Pelotas",
  "Federal University of São Carlos",
  "Fluminense Federal University",
  "Federal University of Juiz de Fora",
  "Federal University of Rio Grande do Norte",
  "Federal University of Bahia",
  "Federal University of Santa Maria",
  "Federal University of Goiás",
  "Federal University of São João del-Rei",
  "Federal University of Mato Grosso do Sul",
  "Federal University of Pará",
  "Federal University of Paraíba",
  "Federal University of Espírito Santo",
  "Federal University of Uberlândia",
  "National Institute for Space Research (INPE)",
  "State University of Maringá",
  "Federal University of Lavras",
  "Institute for Pure and Applied Mathematics (IMPA)",
  "Pontifical Catholic University of Rio Grande do Sul",
  "State University of Londrina",
  "Federal University of Technology - Paraná",
  "National Institute of Amazonian Research (INPA)",
  "Federal Institute of Education, Science and Technology of Rio Grande do Sul",
  "Federal University of Sergipe",
  "Pontifical Catholic University of Rio de Janeiro",
  "Federal Rural University of Pernambuco",
  "Federal University of Rio Grande",
  "Pontifical Catholic University of Paraná",
  "Federal University of Mato Grosso",
  "Technological Institute of Aeronautics",
  "Federal University of Campina Grande",
  "Federal University of Triângulo Mineiro",
  "Federal University of Ouro Preto",
  "Federal University of Alagoas",
  "Federal Rural University of Rio de Janeiro",
  "Federal University of Piauí",
  "Federal University of Amazonas",
  "Santa Catarina State University"
)

# Mapeamento das universidades pros estados
map_estados <- list(
  "University of São Paulo" = "SP",
  "University of Campinas" = "SP",
  "Federal University of Rio de Janeiro" = "RJ",
  "São Paulo State University" = "SP",
  "Federal University of Rio Grande do Sul" = "RS",
  "Federal University of Minas Gerais" = "MG",
  "Federal University of São Paulo" = "SP",
  "Rio de Janeiro State University" = "RJ",
  "Oswaldo Cruz Foundation" = "RJ",
  "Federal University of Santa Catarina" = "SC",
  "Federal University of Paraná" = "PR",
  "Brazilian Center for Research in Physics (CBPF)" = "RJ",
  "Getúlio Vargas Foundation" = "RJ",
  "Federal University of Pernambuco" = "PE",
  "University of Brasília" = "DF",
  "Federal University of ABC" = "SP",
  "Federal University of Viçosa" = "MG",
  "Federal University of Ceará" = "CE",
  "Federal University of Pelotas" = "RS",
  "Federal University of São Carlos" = "SP",
  "Fluminense Federal University" = "RJ",
  "Federal University of Juiz de Fora" = "MG",
  "Federal University of Rio Grande do Norte" = "RN",
  "Federal University of Bahia" = "BA",
  "Federal University of Santa Maria" = "RS",
  "Federal University of Goiás" = "GO",
  "Federal University of São João del-Rei" = "MG",
  "Federal University of Mato Grosso do Sul" = "MS",
  "Federal University of Pará" = "PA",
  "Federal University of Paraíba" = "PB",
  "Federal University of Espírito Santo" = "ES",
  "Federal University of Uberlândia" = "MG",
  "National Institute for Space Research (INPE)" = "SP",
  "State University of Maringá" = "PR",
  "Federal University of Lavras" = "MG",
  "Institute for Pure and Applied Mathematics (IMPA)" = "RJ",
  "Pontifical Catholic University of Rio Grande do Sul" = "RS",
  "State University of Londrina" = "PR",
  "Federal University of Technology - Paraná" = "PR",
  "National Institute of Amazonian Research (INPA)" = "AM",
  "Federal Institute of Education, Science and Technology of Rio Grande do Sul" = "RS",
  "Federal University of Sergipe" = "SE",
  "Pontifical Catholic University of Rio de Janeiro" = "RJ",
  "Federal Rural University of Pernambuco" = "PE",
  "Federal University of Rio Grande" = "RS",
  "Pontifical Catholic University of Paraná" = "PR",
  "Federal University of Mato Grosso" = "MT",
  "Technological Institute of Aeronautics" = "SP",
  "Federal University of Campina Grande" = "PB",
  "Federal University of Triângulo Mineiro" = "MG",
  "Federal University of Ouro Preto" = "MG",
  "Federal University of Alagoas" = "AL",
  "Federal Rural University of Rio de Janeiro" = "RJ",
  "Federal University of Piauí" = "PI",
  "Federal University of Amazonas" = "AM",
  "Santa Catarina State University" = "SC"
)

# Buscar ID da universidade
get_university_id <- function(nome) {
  url <- paste0("https://api.openalex.org/institutions?search=", URLencode(nome))
  res <- GET(url)
  if (status_code(res) != 200) return(NA)
  dados <- content(res, as = "parsed", encoding = "UTF-8")
  if (length(dados$results) == 0) return(NA)
  return(dados$results[[1]]$id)
}

# Contar artigos em um ano específico
get_article_count_year <- function(inst_id, ano) {
  url <- paste0(
    "https://api.openalex.org/works?",
    "filter=institutions.id:", inst_id,
    ",type_crossref:journal-article",
    ",primary_location.source.type:journal",
    ",is_paratext:false",
    ",from_publication_date:", ano, "-01-01",
    ",to_publication_date:", ano, "-12-31"
  )
  res <- GET(url)
  if (status_code(res) != 200) return(0)
  dados <- content(res, as = "parsed", encoding = "UTF-8")
  return(dados$meta$count)
}

# Loop principal
anos <- 2019:as.integer(format(Sys.Date(), "%Y"))
resultados <- data.frame()

for (uni in universidades) {
  cat("Processando:", uni, "\n")
  id_uni <- get_university_id(uni)
  estado <- ifelse(!is.null(map_estados[[uni]]), map_estados[[uni]], "ND")
  
  if (!is.na(id_uni)) {
    for (ano in anos) {
      count <- get_article_count_year(id_uni, ano)
      resultados <- rbind(resultados, data.frame(
        Universidade = uni,
        Estado = estado,
        Ano = ano,
        Artigos = count
      ))
    }
  }
}

# Tabela final exportada pro Power BI
resultados

# Salvar em CSV
# write.csv(resultados, "~/top50_universidades_ano_estado.csv", row.names = FALSE)
