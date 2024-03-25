# fish-feeding-traits-glmm
A model to predict fish feeding traits for the North Atlantic and Arctic Oceans

THIS INFORMATION IS LICENSED UNDER THE CONDITIONS OF THE OPEN GOVERNMENT LICENCE found at: http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3

We make use of predator-prey body size scaling relationships to draw on multiple stomach content databases and derive comparable fish feeding trait information for the North Atlantic and Arctic Oceans (https://doi.org/10.14466/CefasDataHub.149; Thompson et al. 2024). Here is an example showing how to predict individual prey size (log10 transformed wet mass in grams) for fish in the North Atlantic and Arctic Oceans using published fish stomach contents data with information on predator taxa, predator size (log10 transformed wet mass in grams) and prey functional groups (i.e., fish, zooplankton, benthos, nekton, other). We fit a generalized linear mixed model (GLMM) using Template Model Builder (TMB).

This work was undertaken for the study "Fish functional groups of the North Atlantic and Arctic Oceans ", by Murray S.A. Thompson, Izaskun Preciado, Federico Maioli, Valerio Bartolino, Andrea Belgrano, Michele Casini, Pierre Cresson, Elena Eriksen, Gema Hernandez-Milian, Ingibjörg G. Jónsdóttir, Stefan Neuenfeldt, John K. Pinnegar, Stefán Ragnarsson, Sabine Schückel, Ulrike Schückel, Brian E. Smith, María Ángeles Torres, Thomas J. Webb, and Christopher P. Lynam (in prep; see also Thompson et al., 2023).

Thompson, M. S. A., Lynam, C. P., & Preciado, I. (2023). Pilot Assessment of Feeding Guilds. In: OSPAR, 2023: The 2023 Quality Status Report for the Northeast Atlantic. https://oap.ospar.org/en/ospar-assessments/quality-status-reports/qsr-2023/indicator-assessments/feeding-guild-pilot-assessment

Thompson, M. S. A., Preciado, I., Maioli, F., Bartolino, V., Belgrano, A., Casini, M., Cresson, P., Eriksen, E., Hernandez-Milian, G., Jónsdóttir, I. G., Neuenfeldt, S., Pinnegar, J. K., Ragnarsson, S., Schückel, S., Schückel, U., Smith, B. E., Torres, M. Á., Webb, T. J., & Lynam, C. P. (2024). Modelled and observed fish feeding traits for the North Atlantic and Arctic Oceans (1836-2020) and population estimates of fish with different feeding traits from Northeast Atlantic scientific trawl surveys (1997-2020). Cefas, UK. V1. doi: https://doi.org/10.14466/CefasDataHub.149
