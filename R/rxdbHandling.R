#' enumerate top level endpoint terms for bhklab PharmacoDB API
#' @examples 
#' topEndpoints_v1()
#' @export
topEndpoints_v1 = function() {
 c("cell_lines", "tissues", "compounds",
   "datasets", "experiments", "intersections", 
   "stats")
}

#' convert binary output of GET()$content to list 
#' @import httr
#' @import rjson
#' @param x string suitable for input to GET as GET(x)
#' @return output of fromJSON, typically a list
#' @examples
#' cl = basicDecoder("https://api.pharmacodb.com/v1/cell_lines")
#' unlist(cl)
#' @export
basicDecoder = function(x)
   fromJSON(readBin(GET(x)$content, what="character"))

#' very simple query formulation, build queries using endpoints of bhklab PharmacoDB API
#' @importFrom S4Vectors DataFrame
#' @param url of a PharmacoDB server API target
#' @param \dots typically a string representing an API endpoint, will be processed by unlist() and then to paste0 preceded by \code{url}
#' @param decoder a function of one argument that will be applied to API response (typically JSON)
#' @examples
#' qout = rxdbQuery_v1("cell_lines") # yields 30; append "?all=true" to retrieve all
#' sapply(qout, function(x) x[[2]])
#' @export
rxdbQuery_v1 = function(..., url="https://api.pharmacodb.com/v1/", 
                          decoder=basicDecoder) {
   parms = list(...)
   decoder(paste0(url, unlist(parms)))
}
 
compoundTable = function(postfix="?all=true") {
  comps = rxdbQuery_v1(paste0("compounds", postfix))
  ids = sapply(comps, "[[", "id")
  nms = sapply(comps, "[[", "name")
  DataFrame(compound_id=ids, compound=nms)
}

buildMap = function(endpoint="cell_lines", postfix="?all=true") {
  recs = rxdbQuery_v1(paste0(endpoint, postfix))
  ids = sapply(recs, "[[", "id")
  nms = sapply(recs, "[[", "name")
  DataFrame(id=ids, name=nms)
}
