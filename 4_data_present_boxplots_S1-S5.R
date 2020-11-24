library(haven)
library(cowplot)
library(ggplot2)

S5000<-read_dta("C:/Users/chloe/Documents/UniMan/Publications/Individual_Diagnostics/code_and_outputs/datasets_results/S5_overlap_20_5000.dta")
S2000<-read_dta("C:/Users/chloe/Documents/UniMan/Publications/Individual_Diagnostics/code_and_outputs/datasets_results/S5_overlap_20_2000.dta")
S500<-read_dta("C:/Users/chloe/Documents/UniMan/Publications/Individual_Diagnostics/code_and_outputs/datasets_results/S5_overlap_20_500.dta")

ss <- c(rep(1, 2000), rep(2,2000), rep(3, 2000))
ps <- c(rep(c(rep(1,1000), rep(2,1000)), 3)) 

sd <- c(S5000$sd, S2000$sd, S500$sd)
df<-data.frame(sd, ss, ps)
df$ss<-as.factor(df$ss)
df$ps<-as.factor(df$ps)
sd<-ggplot(df, aes(x=ss, y=sd, fill=ps))+geom_boxplot()+
scale_x_discrete(limits=c("1","2","3"), labels=c(" ", " ", " "))+
labs(y="SMD",x=" ")+
theme(text=element_text(size=18))+
scale_fill_manual(values=c("white", "darkgrey"))+
theme(legend.position="none")

t <- c(S5000$t, S2000$t, S500$t)
df<-data.frame(t, ss, ps)
df$ss<-as.factor(df$ss)
df$ps<-as.factor(df$ps)
t<-ggplot(df, aes(x=ss, y=t, fill=ps))+geom_boxplot()+
scale_x_discrete(limits=c("1","2","3"), labels=c(" ", " ", " "))+
labs(y="T",x=" ")+
theme(text=element_text(size=18))+
scale_fill_manual(values=c("white", "darkgrey"))+
theme(legend.position="none")

pr <- c(S5000$perc_red, S2000$perc_red, S500$perc_red)
df<-data.frame(pr, ss, ps)
df$ss<-as.factor(df$ss)
df$ps<-as.factor(df$ps)
pr<-ggplot(df, aes(x=ss, y=pr, fill=ps))+geom_boxplot()+
scale_x_discrete(limits=c("1","2","3"), labels=c(" ", " ", " "))+
labs(y="PRMD",x=" ")+
theme(text=element_text(size=18))+
scale_fill_manual(values=c("white", "darkgrey"))+
theme(legend.position="none")

oc <- c(S5000$ovl, S2000$ovl, S500$ovl)
df<-data.frame(oc, ss, ps)
df$ss<-as.factor(df$ss)
df$ps<-as.factor(df$ps)
oc<-ggplot(df, aes(x=ss, y=oc, fill=ps))+geom_boxplot()+
scale_x_discrete(limits=c("1","2","3"), labels=c(" ", " ", " "))+
labs(y="OC",x=" ")+
theme(text=element_text(size=18))+
scale_fill_manual(values=c("white", "darkgrey"))+
theme(legend.position="none")

ks <- c(S5000$ks, S2000$ks, S500$ks)
df<-data.frame(ks, ss, ps)
df$ss<-as.factor(df$ss)
df$ps<-as.factor(df$ps)
ks<-ggplot(df, aes(x=ss, y=ks, fill=ps))+geom_boxplot()+
scale_x_discrete(limits=c("1","2","3"), labels=c(" ", " ", " "))+
labs(y="KS",x=" ")+
theme(text=element_text(size=18))+
scale_fill_manual(values=c("white", "darkgrey"))+
theme(legend.position="none")

ld <- c(S5000$levy, S2000$levy, S500$levy)
df<-data.frame(ld, ss, ps)
df$ss<-as.factor(df$ss)
df$ps<-as.factor(df$ps)
ld<-ggplot(df, aes(x=ss, y=ld, fill=ps))+geom_boxplot()+
scale_x_discrete(limits=c("1","2","3"), labels=c(" ", " ", " "))+
labs(y="LD",x=" ")+
theme(text=element_text(size=18))+
scale_fill_manual(values=c("white", "darkgrey"))+
theme(legend.position="none")

cp1 <- c(S5000$cpks, S2000$cpks, S500$cpks)
df<-data.frame(cp1, ss, ps)
df$ss<-as.factor(df$ss)
df$ps<-as.factor(df$ps)
cp1<-ggplot(df, aes(x=ss, y=cp1, fill=ps))+geom_boxplot()+
scale_x_discrete(limits=c("1","2","3"), labels=c("5000", "2000", "500"))+
labs(y="CP1",x="Sample Size")+
theme(text=element_text(size=18))+
scale_fill_manual(values=c("white", "darkgrey"))+
theme(legend.position="none")

cp2 <- c(S5000$km, S2000$km, S500$km)
df<-data.frame(cp2, ss, ps)
df$ss<-as.factor(df$ss)
df$ps<-as.factor(df$ps)
cp2<-ggplot(df, aes(x=ss, y=cp2, fill=ps))+geom_boxplot()+
scale_x_discrete(limits=c("1","2","3"), labels=c("5000", "2000", "500"))+
labs(y="CP2",x="Sample Size")+
theme(text=element_text(size=18))+
scale_fill_manual(values=c("white", "darkgrey"))+
theme(legend.position="none")

cp3 <- c(S5000$wkm, S2000$wkm, S500$wkm)
df<-data.frame(cp3, ss, ps)
df$ss<-as.factor(df$ss)
df$ps<-as.factor(df$ps)
cp3<-ggplot(df, aes(x=ss, y=cp3, fill=ps))+geom_boxplot()+
scale_x_discrete(limits=c("1","2","3"), labels=c("5000", "2000", "500"))+
labs(y="CP3",x="Sample Size")+
theme(text=element_text(size=18))+
scale_fill_manual(values=c("white", "darkgrey"))+
theme(legend.position="none")

cp3leg<-ggplot(df, aes(x=ss, y=cp3, fill=ps))+geom_boxplot()+
scale_x_discrete(limits=c("1","2","3"), labels=c("5000", "2000", "500"))+
labs(y="CP3",x="Sample Size")+
theme(text=element_text(size=18))+
scale_fill_manual(values=c("white", "darkgrey"),
name=" ",labels=c("Correctly specified\nPropensity Score",
"Misspecified\nPropensity Score"))+
theme(legend.key.size = unit(1.5, "cm"))


legend <- get_legend(cp3leg)
pgrid <- plot_grid(sd, t, pr, oc, ks, ld, cp1, cp2, cp3, align="h", nrow=3)
plot_grid(pgrid, legend, rel_widths = c(3, .8))

