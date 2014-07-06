#各省份商家数量分布热图
library(maptools);
x=readShapePoly('bou2_4p.shp');#下文中会继续用到x这个变量，
                            #如果你用的是其它的名称，
                            #请在下文的程序中也进行相应的改动。

library("rmongodb");					
mongo <- mongo.create()
count <- mongo.count(mongo, "dface.s_count_shops")
cursor <- mongo.find(mongo, "dface.s_count_shops")
provname <- vector("character", count)
pop <- vector("numeric", count)
i <- 1
while (mongo.cursor.next(cursor)) {
	b <- mongo.cursor.value(cursor)
	provname[i] <- mongo.bson.value(b, "_id")
	pop[i] <- mongo.bson.value(b, "count")
	i <- i + 1
}
df <- as.data.frame(list(provname=provname, pop=pop))
df[order(df$pop),] #对df进行排序
mongo.cursor.destroy(cursor)

getColor=function(mapdata,provname,provcol,othercol)
{
	f=function(x,y) ifelse(x %in% y,which(y==x),0);
	colIndex=sapply(mapdata@data$NAME,f,provname);
	fg=c(othercol,provcol)[colIndex+1];
	return(fg);
}
x@data$NAME = iconv(x@data$NAME,"gbk","UTF-8");

as.character(na.omit(unique(x@data$NAME)));
provcol=heat.colors(count);
plot(x,col=getColor(x,df[order(df$pop),][["provname"]],rev(provcol),"white"),xlab="",ylab="");
