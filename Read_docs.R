#Shiny para encontrar
library(purrr)
library(assertthat)
library(readr)
library(textreadr)
Read_docs<-function(dir=getwd(),text_,deep=2,word_pdf_omit=T){
  
  if(missing(text_)){warning("text_ must have a value");return(invisible())}
  lt<-list.files(dir)
  SPL<-do.call(c,map(lt,~strsplit(.x,".",fixed = TRUE)))
  len<-map_int(SPL,~unlist(length(.x)))
  SPL<-SPL[len>1]
  
  Reed<-lt[len>1]
  Reed<-Reed[purrr::map_lgl(SPL,~"R" %in% .x[[2]] | "txt" %in% .x[[2]] | "pdf" %in% .x[[2]])]
  
  
  Repeat<-lt[len==1]
  
  Doovs<-data.frame(Doc=1,Loc=1,Text=1)[-1,]
  Doov<-data.frame(Doc=1,Loc=1,Text=1)[-1,]
  if(length(Repeat)>0 & deep>1){
    for(i in 1:length(Repeat)){
      Doov=rbind(Doov,Read_docs(dir = paste0(dir,"/",Repeat[i]),text_))
    }
  }
  if(length(Reed)>0){
    
    txt<-Reed[endsWith(Reed,".txt") | endsWith(Reed,"R") | endsWith(Reed,"pdf") | endsWith(Reed,"docx") ]
    
    dir_txt<-paste0(dir,"/",txt)
    readd<-function(tt,dir_,text_.=text_){
      i<-0
      if(length(tt)>0){
        for(t in 1:length(tt)){
          formato<-strsplit(tt,".",fixed = T)[[1]][2]
          if(!word_pdf_omit & (formato %in% c("docx","pdf"))){next()}
          if(formato=="docx"){
            Leer<-try(read_docx(dir_[t]),silent = T)
          }else if(formato=="pdf"){
            Leer<-try(read_pdf(dir_[t])$text,silent = T)
          }else{
            Leer<-try(readChar(dir_[t], file.info(dir_[t])$size),silent = T)
          }
          
          if(is.error(Leer)){
            Leer<-try(read_file(dir_[t]))
            if(is.error(Leer)){
              Leer<-""
            }
          }
          return(
            c(dir_,grepl(text_,Leer))
          )
        }
      }
    }
    
    for(i in 1:length(txt)){
      Info=readd(txt[i],dir_txt[i])
      Doovs<-rbind(Doovs,data.frame(Doc=txt[i],Loc=Info[1],Text=Info[2]))
    }
  }
  if(nrow(Doov)>0){
    return(rbind(Doov,Doovs))
  }else{
    return(Doovs)
  }
}

# getwd()
# Dwl<-Read_docs(dir = "C:/Users/cody8/Downloads",text_ = "Read_docs",deep = 1,word_pdf_omit = T)
# View(Dwl)
