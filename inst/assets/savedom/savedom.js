Shiny.addCustomMessageHandler("save_dom_element", function(data){

  save_domelement_dataurl(data.id, data.id_out);

});



/* save a dom element as a PNG, download immediately */
/* uses current size */
/* works with a leaflet */
/* RAD */
save_domelement_and_download = function(id, name = "map"){

  /*var domtoimage = require('dom-to-image');*/
  var node = document.getElementById(id);

  domtoimage.toPng(node).then(function (dataUrl) {
        var link = document.createElement('a');
        link.download = name + '.png';
        link.href = dataUrl;
        link.click();
    });

};

/* save a dom node to a shiny input as png, base64 encoded*/
/* for example, a leaflet */
/* module: shiny module from which this function is called */
/* id: bare id of the dom element to convert */
/* id_out: name of shiny input id to which the base64 url will be assigned (character) */
/* RAD */
save_domelement_dataurl = function(id, id_out){

  var node = document.getElementById(id);

  var elements = node.getElementsByClassName("leaflet-control");

  while (elements[0]) {
      elements[0].parentNode.removeChild(elements[0]);
  }

  domtoimage.toPng(node).then(function(dataUrl){

    Shiny.setInputValue(id_out, {dataUrl: dataUrl, nonce: Math.random()});

  });


};

