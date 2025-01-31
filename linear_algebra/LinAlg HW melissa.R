#Load the dataset
load("C:/Users/Melissa Sandahl/OneDrive/Documents/School/MSA courses/Linear Alg/Fall/Data/LeukError.RData")
row.names(leuk)

# Last column contains the factor variable with Leukemia type, do not include this in the pca
# Use scale=F to get covariance PCA since the variable scales are similar
# 3 is for number of dimensions to reduce to?
pcaOut = prcomp(leuk[,1:5000],3, scale = F)


# First look at PC1 and PC2 graphed on 2D plot:

library(ggplot2)
ggplot(leuk, aes(x=pcaOut$x[,1], y=pcaOut$x[,2], col=leuk[,5001], 
                 label=rownames(leuk))) + ggtitle("Principal Component Analysis \n of Leukemia Samples") +
                  xlab("PC 1") + ylab("PC2") + geom_text() + labs(color="Leukemia Type")



# Now look at PC1, PC2, PC3 on 3D plot:

# Create vector of colors based on the Leukemia type variable 
colors = factor(palette())
colors = colors[leuk[,5001]]

# 3D plot of the 3 principal components
library(rgl)
plot3d(x = pcaOut$x[,1], y = pcaOut$x[,2],z= pcaOut$x[,3],col = colors, xlab = "PC 1", ylab = "PC 2", zlab = "PC 3", size=1)
text3d(x = pcaOut$x[,1], y = pcaOut$x[,2],z= pcaOut$x[,3],col = colors, texts=rownames(leuk), adj = c(0.5, 0.5), font=2)


# Proportion of Variance explained by 2 components
sum(pcaOut$sdev[1:2]^2)/sum(pcaOut$sdev^2)
# Proportion of Variance explained by 3 components
sum(pcaOut$sdev[1:3]^2)/sum(pcaOut$sdev^2)
