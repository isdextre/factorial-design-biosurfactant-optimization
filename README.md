# Optimizing Surfactin Production with a 2⁴ Factorial Design

A full factorial design of experiments (2⁴, no replication, 6 center points) applied to optimize the production of surfactin — a biosurfactant of high industrial interest — as a function of four culture-medium components: glucose, NH₄NO₃, FeSO₄, and MnSO₄.

## Overview

This is the data-analysis component of a course project for *Diseño de Experimentos* (Design of Experiments) at UNI, co-authored with Alvaro Ayesta, Sebastian Romero and Frankli Zeña. The experimental data is taken from a published study (*Journal of Chemical Technology and Biotechnology*, 1997) — this project is a rigorous statistical re-analysis of that data, not new wet-lab data collection, and the paper is explicit about that limitation.

The response variable is (CMC)⁻¹, the inverse of the critical micelle concentration, used as an indirect proxy for surfactin concentration (a lower CMC means a more effective surfactant, hence a higher (CMC)⁻¹ is desirable).

## Why this stands out

- **A designed experiment with no replicates, handled correctly.** With only one run per treatment combination, there's no direct estimate of experimental error — so significance can't be assessed with a classical ANOVA F-test alone. The analysis first screens effects with a **Pareto chart built from Lenth's method (1989)**, estimating a pseudo-standard error from the smaller effects, before any error term is available.
- **Center points to test the linearity assumption itself.** Six center-point runs were added to estimate pure error and formally test for curvature — the test came back significant (p < 0.001), so the report is explicit that the first-order model, while adequate for optimization within the studied range, does not fully capture the system's real (likely second-order) behavior.
- **All four regression assumptions verified, not assumed.** Normality (Anderson–Darling on standardized residuals, p = 0.29 and p = 0.427 across the two fitted models), independence (justified by randomized run order), and homoscedasticity — checked graphically and then formally with **White's test**, cross-validated independently in R (`white_test_heteroscedasticity.R`, computing the White statistic by hand as n·R² from the auxiliary regression of squared residuals) against Minitab's built-in result.
- **Optimization grounded in the model, not guesswork.** Once the significant effects were identified (Glucose, FeSO₄, MnSO₄, and the Glucose×NH₄NO₃ and FeSO₄×MnSO₄ interactions), the optimal region was characterized through interaction plots, 3D response surfaces, and contour plots — and the same optimum was independently confirmed by both the plain 2⁴ model and the model extended with center points.

## Methodology

1. **Design.** Full 2⁴ factorial, 16 runs, factors Glucose (20–60 g/dm³), NH₄NO₃ (2–6 g/dm³), FeSO₄ (6–30 ×10⁻⁴ g/dm³), MnSO₄ (4–20 ×10⁻² g/dm³), plus 6 center-point runs at the midlevel of each factor.
2. **Effect screening.** Contrasts and effects computed per factor/interaction; Lenth's PSE method used to build the significance threshold for the Pareto chart (since no replicates exist to estimate error directly).
3. **ANOVA.** Model fit with the effects retained by the Pareto screening, respecting the hierarchy principle (NH₄NO₃'s main effect kept despite p = 1.00, because its interaction with Glucose is significant).
4. **Assumption checks.** Normal probability plot + Anderson–Darling test, residuals-vs-fitted plot, and White's test for heteroscedasticity (validated independently in R).
5. **Curvature check.** Comparison of the average response at the factorial points vs. the center points; formal test via `SS_curvature`.
6. **Response surface analysis.** Interaction plots, 3D response surfaces and contour plots for the two significant two-factor interactions, used to identify the optimum since the design (built on literature data, without axial points) could not be extended to a full central composite design.

## Results

| Model | S | R² | R² adj. | R² pred. |
|---|---|---|---|---|
| 2⁴ factorial, no center points | 2.339 | 93.25% | 88.75% | 78.67% |
| 2⁴ factorial + 6 center points | 1.277 | 98.59% | 97.54% | 93.42% |

Significant effects (α = 0.05): **Glucose**, **FeSO₄**, **MnSO₄**, **Glucose × NH₄NO₃**, and **FeSO₄ × MnSO₄**. NH₄NO₃'s main effect alone was not significant but is retained through its interaction with Glucose.

**Optimal conditions:** low Glucose (20 g/dm³) and low NH₄NO₃ (2 g/dm³), combined with high FeSO₄ (30×10⁻⁴ g/dm³) and high MnSO₄ (20×10⁻² g/dm³) — i.e., limited carbon and nitrogen paired with abundant iron and manganese maximizes the surfactin response, consistent across both the plain and center-point-augmented models.

**White's test:** W = 21.098 (Minitab, with center points) < χ²₀.₀₅,₁₄ = 23.685 → no evidence of heteroscedasticity; independently reproduced in R on the base model (statistic ≈ 17 < critical value 23.68).

## Honest limitations

- The data is from a literature example, not original experimentation — this project's contribution is the statistical design, analysis, and interpretation, not the underlying wet-lab work.
- Significant curvature was detected, meaning the first-order model is adequate for optimization *within the studied experimental range* but does not fully represent the system. The paper recommends extending the design to a central composite or Box-Behnken design for a proper second-order response-surface optimization — that extension was out of scope here since it would require new axial-point data.

## Repository layout

```
paper_surfactin_factorial_design.pdf   Full write-up (methodology, ANOVA, response surfaces, conclusions)
data_surfactin_experiment.xlsx          Factorial design data (16 runs) + 6 center points + residuals
data_pse_calculation.xlsx                Effect/PSE calculations behind the Pareto chart
minitab_factorial_design.mpx             Minitab project: full ANOVA, Pareto and optimization workflow
white_test_heteroscedasticity.R          Independent R implementation of White's test
```

## Authors

Alvaro Alberto Ayesta Ramirez, Ibeth Sofia Dextre Simangas, Sebastian Matias Romero Davila, Frankli Zeña Zeña.

## References

- Journal of Chemical Technology and Biotechnology (1997). *Response Surface Optimization of the Critical Media Components for the Production of Surfactin*, 68(3), 263–270.
- Montgomery, D. C. (2017). *Design and Analysis of Experiments* (9th ed.). John Wiley & Sons.

## Running it

```r
install.packages(c("lmtest", "skedastic", "readxl"))
```
Then run `white_test_heteroscedasticity.R` against `data_surfactin_experiment.xlsx` (update the file path at the top of the script). The full step-by-step ANOVA, Pareto chart, and response-surface optimization are documented in `minitab_factorial_design.mpx`.
