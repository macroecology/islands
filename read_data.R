library (raster)
library (gdal)
library (maptools)

#read altitude data
alt<- raster ("ETOPO1_Bed_g_geotiff.tif")
crs (alt)<- "+proj=longlat +datum=WGS84 +no_defs"
alt_rough<- raster ("irregu_etopo.tif")
crs (alt_rough)<- "+proj=longlat +datum=WGS84 +no_defs"

#read island shapefiles
green<- readShapePoly ("greenland.shp")
crs (green)<- "+proj=longlat +datum=WGS84 +no_defs"
java<- readShapePoly ("java.shp")
crs (java)<- "+proj=longlat +datum=WGS84 +no_defs"
majorca<- readShapePoly ("majorca.shp")
crs (majorca)<- "+proj=longlat +datum=WGS84 +no_defs"
menorca<- readShapePoly ("menorca.shp")
crs (menorca)<- "+proj=longlat +datum=WGS84 +no_defs"
orca<- readShapePoly ("orca_island.shp")
orca$id<- c(1,1)
orca<- unionSpatialPolygons(orca, orca$id)
crs (orca)<- "+proj=longlat +datum=WGS84 +no_defs"
sicily<- readShapePoly ("sicily.shp")
crs (sicily)<- "+proj=longlat +datum=WGS84 +no_defs"
honshu<- readShapePoly ("honshu.shp")
crs (honshu)<- "+proj=longlat +datum=WGS84 +no_defs"
malta<- readShapePoly ("malta.shp")
malta$id<- c(1,1)
malta<- unionSpatialPolygons(malta, malta$id)
crs (malta)<- "+proj=longlat +datum=WGS84 +no_defs"
negros_panay<- readShapePoly ("negros_panay.shp")
negros_panay$id<- c(1,1,1,1)
negros_panay<- unionSpatialPolygons(negros_panay, negros_panay$id)
crs (negros_panay)<- "+proj=longlat +datum=WGS84 +no_defs"
mindoro<- readShapePoly ("mindoro.shp")
crs (mindoro)<- "+proj=longlat +datum=WGS84 +no_defs"
sulawesi<- readShapePoly ("sulawesi.shp")
crs (sulawesi)<- "+proj=longlat +datum=WGS84 +no_defs"
taiwan<- readShapePoly ("taiwan.shp")
crs (taiwan)<- "+proj=longlat +datum=WGS84 +no_defs"
sardinia<- readShapePoly ("sardinia.shp")
crs (sardinia)<- "+proj=longlat +datum=WGS84 +no_defs"
pianosa<- readShapePoly ("pianosa.shp")
crs (pianosa)<- "+proj=longlat +datum=WGS84 +no_defs"

islas<- green + java + honshu + sicily + menorca + majorca + pianosa + sardinia + 
  taiwan + mindoro + sulawesi + negros_panay + malta  + orca

#extract data for every island about altitude, roughness and percentage of roughness
alt_ext<- extract (alt, islas)
alt_rough_ext<- extract (alt_rough, islas)
rec_rough<- reclassify (alt_rough, c(-Inf, 100, 0, 100,+Inf, 1))
rec_rough_ext<- extract (rec_rough, islas)

#sd, mean, max values per island
sd_alt<- lapply (alt_ext, sd)
mean_alt<- lapply (alt_ext, mean)
max_alt<- lapply (alt_ext, max)
sd_rough<- lapply (alt_rough_ext, sd)
mean_rough<- lapply (alt_rough_ext, mean)
max_rough<- lapply (alt_rough_ext, max)
sum_p<- lapply (rec_rough_ext, sum)
area_p<- lapply (rec_rough_ext, length)

names_islands<- c("greenland","java", "honshu",
                  "sicily","menorca","majorca","pianosa",
                  "sardinia","taiwan","mindoro",
                  "sulawesi","negros_panay","malta", "orca_island")

res<- data.frame (names_islands, 
            perc_mountains= round ((unlist (sum_p)/unlist (area_p))*100, 2),
            area=(unlist (area_p)), sd_alt= (unlist (sd_alt)), mean_alt= (unlist (mean_alt)), 
            max_alt= (unlist (max_alt)), sd_rough= (unlist (sd_rough)), mean_rough=(unlist (mean_rough)), 
            max_rough= (unlist (max_rough)))

write.table (res, "results.csv", sep=",", row.names = F)
            
            
