install.packages("lmtest")
install.packages("skedastic")
install.packages("readxl")

library(skedastic)
library(readxl)


datos <- read_excel("C:\\Users\\JHOSSEP\\Documents\\CURSOS_UNI\\7MO CICLO\\DISEÑO DE EXPERIMENTOS\\22 datos PC2.xlsx")


head(datos)
names(datos)

# Renombramos para que los nombres sean simples
names(datos) <- c("OrdenEst", "OrdenCorrida", "Bloques", "PuntoCentral",
                  "Glucose", "NH4NO3", "FeSO4", "MnSO4", "Y", "RESS1")


modelo <- lm(Y ~ Glucose + NH4NO3 + FeSO4 + MnSO4, data = datos)



install.packages("skedastic", dependencies = TRUE, repos = "https://cloud.r-project.org/")

# Prueba de White
white_lm(modelo)


# Prueba de White manual (términos cuadráticos e interacciones)
bptest(modelo, ~ Glucose + NH4NO3 + FeSO4 + MnSO4 + PuntoCentral +
         I(Glucose^2) + I(NH4NO3^2) + I(FeSO4^2) + I(MnSO4^2) + I(PuntoCentral^2) +
         I(Glucose*NH4NO3) + I(Glucose*FeSO4) + I(Glucose*MnSO4) + I(Glucose*PuntoCentral) +
         I(NH4NO3*FeSO4) + I(NH4NO3*MnSO4) + I(NH4NO3*PuntoCentral) +
         I(FeSO4*MnSO4) + I(FeSO4*PuntoCentral) + I(MnSO4*PuntoCentral),
       data = datos)

install.packages("lmtest")   #
library(lmtest)    


# Modelo inicial
modelo <- lm(Y ~ 
               # Efectos principales
               Glucose + NH4NO3 + FeSO4 + MnSO4 +
               # Interacciones dobles (2 a 2)
               I(Glucose*NH4NO3) + I(Glucose*FeSO4) + I(Glucose*MnSO4) +
               I(NH4NO3*FeSO4) + I(NH4NO3*MnSO4) + I(FeSO4*MnSO4) +
               # Interacciones triples (3 a 3)
               I(Glucose*NH4NO3*FeSO4) + I(Glucose*NH4NO3*MnSO4) +
               I(Glucose*FeSO4*MnSO4) + I(NH4NO3*FeSO4*MnSO4) +
               # Interacción cuádruple (4 a 4)
               I(Glucose*NH4NO3*FeSO4*MnSO4),
             data = datos)


modelo

# Prueba de White (manual)
bptest(modelo, ~ Glucose + NH4NO3 + FeSO4 + MnSO4 +
         I(Glucose^2) + I(NH4NO3^2) + I(FeSO4^2) + I(MnSO4^2) +
         I(Glucose*NH4NO3) + I(Glucose*FeSO4) + I(Glucose*MnSO4) +
         I(NH4NO3*FeSO4) + I(NH4NO3*MnSO4) + I(FeSO4*MnSO4),
       data = datos)

# NO hay evidencia estadísticamente significativa de heterocedasticidad.


summary(modelo)



# ------------------
resultado_white <- bptest(modelo, ~ Glucose + NH4NO3 + FeSO4 + MnSO4 +
                            I(Glucose^2) + I(NH4NO3^2) + I(FeSO4^2) + I(MnSO4^2) +
                            I(Glucose*NH4NO3) + I(Glucose*FeSO4) + I(Glucose*MnSO4) +
                            I(NH4NO3*FeSO4) + I(NH4NO3*MnSO4) + I(FeSO4*MnSO4),
                          data = datos)


resultado_white

# ----------- Modelo de White --------------
# residuos al cuadrado
datos$resid2 <- residuals(modelo)^2

# ajustar el modelo de white
modelo_white <- lm(resid2 ~ Glucose + NH4NO3 + FeSO4 + MnSO4 +
                     I(Glucose^2) + I(NH4NO3^2) + I(FeSO4^2) + I(MnSO4^2) +
                     I(Glucose*NH4NO3) + I(Glucose*FeSO4) + I(Glucose*MnSO4) +
                     I(NH4NO3*FeSO4) + I(NH4NO3*MnSO4) + I(FeSO4*MnSO4),
                   data = datos)

n <- nrow(datos)                     # número de observaciones
R2 <- summary(modelo_white)$r.squared # R² del modelo auxiliar

BP <- n * R2                         # estadístico de White
BP

# ver resumen
summary(modelo_white)

# El 81 % de la variación de los residuos al cuadrado se explica por tus variables (Glucose, NH4NO3, FeSO4, MnSO4), sus cuadrados e interacciones.

# ESTADÍSTICO DE CHI2


gl <- length(coef(modelo_white)) - 1  # grados de libertad
valor_critico <- qchisq(0.95, df = gl)
BP
valor_critico

# el valor critico es 23.68
# el valor del estadístico de White es 17

# W es menor a Chi2, existe homocedasticidad
