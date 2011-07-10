;(function($,undefined) {

  var timeplot;

  $(document).ready(function () {

    $(".timeplot").each( function (n,el) {setup_graph($(el))} );

    function getUrlVars() {
      var vars = {}, hash;
      var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
      for(var i = 0; i < hashes.length; i++) {
        hash = hashes[i].split('=');
        vars[hash[0]] = hash[1];
      }
      return vars;
    }

    function setup_graph($el) {
      var plot, data = [], vars = getUrlVars();
//console.log(vars);
      var min = (new Date(2011, 2, 11)).getTime();
//console.log(min);
      if (vars["days"]) {
	min = (new Date()).getTime() - (vars["days"] * 24 * 60 * 60000);
      }
//console.log(min);
      var max = (new Date()).getTime();
      var url_base = $el.data('src');

      var options = { 
        xaxis:  { mode: "time" },
        yaxis:  { zoomRange: false, panRange: false },
        points: { show: true, radius: 1 },
        zoom:   { interactive: true },
        pan:    { interactive: true, frameRate: 30 },
        series: { color: "#3C1D8E" },
        grid:   { hoverable: true, clickable: true, backgroundColor: { colors: ["#FFDAD9","#FFECD7","#FEFCE0","#DFEDD6"] } }
      };

      if ($el.hasClass('intensity')) {
        options.yaxis.ticks = [[0,""], [1,"1"], [2,"2"],[3,"3"],[4,"4"],[5,"5-"],[6,"5+"],[7,"6-"],[8,"6+"],[9,"7"]];
        options.yaxis.max = 9;
        //options.yaxis.tickLength = 0;
        //options.points = {};
        //options.bars = { show: true, fill: true, color: 4 };
        //options.series = { color: "#3C1D8E" };
      } else if ($el.hasClass('magnitude')) {
        options.yaxis.max = 8;
      }

      plot = $.plot($el, [], options);

      // add zoom buttons
      $('<button class="zoomin">Zoom In</button>').button({
        text: false,
        icons: { primary: "ui-icon-zoomin" }
      }).appendTo($el).click(function (e) {
        e.preventDefault();
        plot.zoom();
      });

      $('<button class="zoomout">Zoom Out</button>').button({
        text: false,
        icons: { primary: "ui-icon-zoomout" }
      }).appendTo($el).click(function (e) {
        e.preventDefault();
        plot.zoomOut();
      });

      function get_data(min,max) {
	url = $el.data('src').replace(/\?.*/,'');
        $.get(url+"?min="+min+"&max="+max, function (new_data, textStatus, jqXHR) {
          data = data.concat(new_data)
          plot.setData([data]);
          plot.setupGrid();
          plot.draw();
        });
      }

      var $hover = $('<div class="hover">TEST</div>').appendTo($el).hide();;
      $el.bind("plothover", function (event, pos, item) {
        if (item) {
          var i = new Date(data[item.dataIndex][0]);
          $hover.fadeIn();
          $hover.html(data[item.dataIndex][3]);
          $hover.offset({ top: pos.pageY+5, left: pos.pageX+5})
        }
      }).bind("plotclick", function (event, pos, item) {
        if (item) {
          location.href = data[item.dataIndex][2]
        }
      });


      var new_min, new_max, timerId = null;
      function new_bounds(event, plot) {
        var axes = plot.getAxes();
  
        new_min = parseInt(axes.xaxis.min,10);
        new_max = parseInt(axes.xaxis.max,10);
  
        if (timerId == null) {
          timerId = window.setTimeout(function() {
            timerId = null;
            if (new_min < min) {
              get_data(new_min, min);
              min = new_min
            }
            if (new_max > max) {
              get_data(max, new_max);
              max = new_max
            }
          }, 1000);
        }
      }
      $el.bind('plotpan', new_bounds).bind('plotzoom', new_bounds);
  
      get_data(min,max);
    }

    $('#search').each( function (n,el) {
      var $el = $(el), cache = {}, lastXhr;

      $el.autocomplete({
        minLength: 2,
        source: function( request, response ) {
          var term = request.term;
          if ( term in cache ) {
            response( cache[ term ] );
            return;
          }
          lastXhr = $.getJSON($el.data('src'), request, function( data, status, xhr ) {
            cache[ term ] = data;
            if ( xhr === lastXhr ) { response( data ) }
          });
        },
        select: function(ev, $ui) {  
	  return window.location.href = '/cities/'+$ui.item.id;
/*
          var $plot = $('<div><h2>'+$ui.item.value+'</h2><div class="intensity timeplot" data-src="/cities/'+$ui.item.id+'/plot.json" class="intensity"></div></div>').appendTo($('body'));
          setup_graph($plot.find('.timeplot'));
          setTimeout(function () {
            $el.val('');
          }, 0);
*/
        }

      });

    });

  });


})(jQuery)
