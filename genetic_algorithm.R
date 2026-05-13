# Implementacja algorytmu genetycznego dla problemu komiwojażera (TSP)
#
# Kod oparty na materiałach z zajęć:
# K. Rogoziński — Nieklasyczne Metody Optymalizacji

library(geosphere)

# Długość trasy
route_length <- function(route, cities) {
  total <- 0
  n <- length(route)
  
  for(i in 1:(n - 1)) {
    c1 <- cities[route[i], ]
    c2 <- cities[route[i + 1], ]
    
    total <- total + distHaversine(c(c1$longitude, c1$latitude), 
                                   c(c2$longitude, c2$latitude))
  }
  
  # powrót do miasta startowego
  c_last <- cities[route[n], ]
  c_first <- cities[route[1], ]
  
  total <- total + distHaversine(c(c_last$longitude, c_last$latitude),
                                 c(c_first$longitude, c_first$latitude))
  
  total
}

# Funkcja fitness
fitness_min <- function(values) {
  quality <- max(values) - values + 1e-8
  quality / sum(quality)
}

# Selekcja ruletkowa
roulette_select <- function(prob) {
  sample(seq_along(prob), size = 1, prob = prob)
}

# Krzyżowanie OX
order_crossover <- function(parent1, parent2) {
  n <- length(parent1)
  points <- sort(sample(1:n, 2))
  child <- rep(NA, n)
  child[points[1]:points[2]]<-parent1[points[1]:points[2]]
  remaining <- parent2[!parent2 %in% child]
  child[is.na(child)] <- remaining
  
  child
}

# Mutacja
swap_mutation <- function(route, p_mut = 0.1) {
  if(runif(1) < p_mut) {
    ids <- sample(1:length(route), 2)
    tmp <- route[ids[1]]
    route[ids[1]] <- route[ids[2]]
    route[ids[2]] <- tmp
  }
  
  route
}

# Algorytm genetyczny
genetic_tsp <- function(
    cities,
    pop_size = 100,
    p_mut = 0.1,
    K = 300
) {
  
  # Liczba miast
  n_cities <- nrow(cities)
  
  # Losowa populacja początkowa
  population <- replicate(
    pop_size,
    sample(1:n_cities),
    simplify = FALSE
  )
  
  # Historia najlepszych tras
  route_hist <- vector("list", K)
  dist_hist <- rep(NA, K)
  
  # Najlepsze rozwiązanie globalne
  best_route <- NULL
  best_distance <- Inf
  
  for(k in 1:K) {
    
    # Liczymy długość tras
    values <- sapply(
      population,
      route_length,
      cities = cities
    )
    
    # Najlepszy osobnik w generacji
    gen_best_id <- which.min(values)
    gen_best_route <- population[[gen_best_id]]
    gen_best_distance <- values[gen_best_id]
    
    # Zapis historii
    route_hist[[k]] <- gen_best_route
    dist_hist[k] <- gen_best_distance
    
    #Aktualizacja najlepszego rozwiązania
    if(gen_best_distance < best_distance) {
      best_distance <- gen_best_distance
      best_route <- gen_best_route
    }
    
    # Fitness
    prob <- fitness_min(values)
    
    # Nowa populacja
    new_population <- vector("list", pop_size)
    
    for(i in 1:pop_size) {
      
      # Selekcja rodziców
      p1 <- roulette_select(prob)
      p2 <- roulette_select(prob)
      
      # Krzyżowanie
      child <- order_crossover(
        population[[p1]],
        population[[p2]]
      )
      
      # Mutacja
      child <- swap_mutation(child, p_mut)
      
      # Dodanie dziecka
      new_population[[i]] <- child
    }
    
    # Aktualizacja populacji
    population <- new_population
  }
  
  list(
    route_opt = best_route,
    dist_opt = best_distance,
    route_hist = route_hist,
    dist_hist = dist_hist
  )
}

# Uruchomienie
# source("data_loader.R")
# 
# set.seed(123)
# 
# miasta_test <- subset(
#   pl_locations,
#   name %in% c("Warszawa", "Poznań", "Kraków", "Gdańsk", "Wrocław", "Łódź", "Racibórz",
#                 "Katowice", "Nowy Sącz", "Gliwice", "Sopot")
# )
# 
# res <- genetic_tsp(
#   cities = miasta_test,
#   pop_size = 120,
#   K = 400,
#   p_mut = 0.15
# )
# 
# cat(
#   "Najlepsza trasa:\n",
#   paste(miasta_test$name[res$route_opt], collapse = " -> "),
#   "\n\nDługość trasy:\n",
#   round(res$dist_opt / 1000, 2),
#   " km\n"
# )
