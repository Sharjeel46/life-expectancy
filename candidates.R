---
title: "Predicting Post-Election Longevity by Age and Gender"
format: html
editor: visual
---

## Setup

```{r}
#| message: false
#| warning: false
#| echo: false
#| results: 'hide'

# Load necessary libraries
library(tidyverse)
library(primer.data)
library(tidymodels)
library(broom)
library(marginaleffects)
```

## Model: Predicting Years Lived After Election

```{r}
# Fit linear regression model
fit_years <- linear_reg(engine = "lm") %>%
  fit(lived_after ~ election_age * sex, data = governors)
```

## Visualizing Predicted Longevity

```{r}
# Generate predictions
preds <- predict(fit_years, new_data = governors) %>%
  bind_cols(governors)

# Plot the predicted values
ggplot(preds, aes(x = election_age, y = .pred, color = sex)) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    title = "How Election Age and Gender Relate to Post-Election Longevity",
    subtitle = "Male candidates tend to live fewer years after election as they age, compared to females.",
    x = "Age at Election (Years)",
    y = "Predicted Years Lived After Election",
    color = "Gender",
    caption = "Source: U.S. Governor Candidate Data, 1945–present"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold"),
    plot.subtitle = element_text(margin = margin(b = 10))
  )
```

## Regression Equation (LaTeX)

The fitted linear regression model for a simpler case with only `sex` as a predictor:

```{r}
# Simple model: lived_after ~ sex
simple_model <- linear_reg(engine = "lm") %>%
  fit(lived_after ~ sex, data = governors)

# Extract and display coefficients
tidy(simple_model, conf.int = TRUE)
```

The regression equation can be expressed as:

$$
\hat{Y}_i = \beta_0 + \beta_1 \cdot \text{sex}_{\text{Male},i}
$$

For example, suppose the output was:

```r
(Intercept): 18.4  
sexMale: 2.7
```

Then:

$$
\hat{Y}_i = 18.4 + 2.7 \cdot \text{sex}_{\text{Male},i}
$$

---
