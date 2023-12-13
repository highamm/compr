# compr

The `compr` package provides functionality to fit and interpret paired competition models in `R`.

To install and load the package, run

```
devtools::install_github(repo = "https://github.com/jameswolpe/compr")

library(compr)
```

# compr
The `compr` package is designed to facilitate the fitting and interpretation of paired competition models in `R`. The primary function, `comp_glm()`, is the core feature of this package. It allows users to model paired competition outcomes using a formula that includes the response variable and contest-level predictors.

## Installation
To install and load the `compr` package, use the following commands:

```
devtools::install_github(repo = "https://github.com/jameswolpe/compr")
library(compr)
```

## Functionality
The main function, comp_glm(), has the following arguments:

`formula`: Specifies the response variable and contest-level predictors.
`data`: The dataset to be used.
`p1`: A string with the name of the column containing the first player.
`p2`: A string with the name of the column containing the second player.
`p1_effects`: A one-sided formula specifying player-level effects for p1.
`p2_effects`: A one-sided formula specifying player-level effects for p2.
`ref_player`: A string giving the name of the player to be used as the reference player (default is the first player in p1).

Here is an example of using `comp_glm()`:

```
comp_mod <- comp_glm(point_winner ~ -1, data = tennis_point,
                     p1 = "player1", p2 = "player2",
                     p1_effects = ~ point_server1,
                     p2_effects = ~ point_server2,
                     ref_player = "Milos Raonic")
```
                     
Feel free to explore and leverage the compr package to enhance your paired competition modeling in `R`. For detailed information and usage examples, refer to the package documentation.
