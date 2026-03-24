# Section 7.1

# to find our chi-squared value
1 - pchisq(7.396, 2) # = z^2


21/205
68/205
116/205

10/150
79/150
61/150

# Example 1 ---------------------------------------------------------------

expected_prop <- c(1/3, 1/3, 1/3)
obs_count <- c(107, 124, 150)

chi_res = chisq.test(x=obs_count, p=expected_prop)

chi_res
chi_res$expected

# Example 2 ---------------------------------------------------------------

# Observed counts
obs <- c(AA = 142, BB = 121, AB = 307)

# Assumed proportions
p <- c(AA = 0.25, BB = 0.25, AB = 0.50)

chi_res <- chisq.test(x=obs, p=p)
chi_res

chi_res$expected


# Example 3 ---------------------------------------------------------------

tag <- matrix(c(33, 134, 68, 121), ncol=2, byrow = TRUE)

colnames(tag) <- c("survival", "death")
rownames(tag) <- c("metal", "electronic")

chi_res <- chisq.test(tag)


# Example 4 ---------------------------------------------------------------

tag <- matrix(c(17, 35, 8, 53, 22, 491), ncol=2, byrow = TRUE)

colnames(tag) <- c("hep_c", "no_hep_c")
rownames(tag) <- c("tattoo_parlor", "tattoo_else", "no_tattoo")

chi_res <- chisq.test(tag)

chi_res
chi_res$expected
format(chi_res$p.value)

prop.table(tag,1)
prop.table(tag,2)
