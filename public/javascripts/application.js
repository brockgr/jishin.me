;(function($,undefined) {

  var timeplot;
  $(document).ready(function () {
    var $el = $("#timeplot"), plot, data = [];
    var min = (new Date(2011, 2, 11)).getTime();
    var max = (new Date(2012, 1, 1)).getTime();
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
      options.points = {};
      options.bars = { show: true, fill: true, color: 4 };
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
      $.get($el.data('src')+"?min="+min+"&max="+max, function (new_data, textStatus, jqXHR) {
        data = data.concat(new_data)
        plot.setData([data]);
        plot.setupGrid();
        plot.draw();
      });
    }

    $el.bind("plothover", function (event, pos, item) {
      //console.log(pos,item);
    }).bind("plotclick", function (event, pos, item) {
      if (item) {
        console.log(data[item.dataIndex][2]);
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
    console.log('done');
  });

  var resizeTimerID = null;
  $(window).resize(function () {
    if (resizeTimerID == null) {
        resizeTimerID = window.setTimeout(function() {
            resizeTimerID = null;
            //timeplot.repaint();
        }, 100);
    }

  });

})(jQuery)
