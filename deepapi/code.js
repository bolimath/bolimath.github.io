var svg;
var Y;

var canvas_width;
var canvas_height = 600;
var zoomListener;

function filterdata(data) {
	try {
		regex = new RegExp($("#filterInput").val());		
		$("#filterInput").css("background","white");
		if ($("#filterInput").val().length == 0) {
			$("#filterMessage").text("Nothing filtered");
			return data;			
		}
		filtered = {"words": [], "points": [], "neighbours":[]};
		num_filtered = 0;
		for (i = 0; i < data.words.length; i++) {
			if (regex.test(data.words[i])) {
				filtered.words.push(data.words[i]);
				filtered.points.push(data.points[i]);
				filtered.neighbours.push(data.neighbours[i]);
			} else {
				num_filtered++;
			}
		}
		$("#filterMessage").text("Filtered " + num_filtered + " identifiers");
	} catch (exception) {
		filtered = data;
		$("#filterInput").css("background","red");
		$("#filterMessage").text(exception);
	}
	return filtered;
}

function drawEmbedding(data) {
	filterd_data = filterdata(data);
    $("#embed").empty();
    var div = d3.select("#embed");

    // get min and max in each column of Y

    svg = div.append("svg") // svg is global
    .attr("width", canvas_width)
    .attr("height", canvas_height)
    .attr("style", "border:solid 1px");

    var g = svg.selectAll(".b")
      .data(filterd_data.words)
      .enter().append("g")
      .attr("class", "u");

    g.append("circle")
        .attr("r", 3)
        .attr("fill", "orange")
        .on("mouseover", highlight_nearest_neighbours)
        .on("mouseout", reset_highlight);

    g.append("text")
      .attr("text-anchor", "top")
      .attr("font-size", 13)
      .attr("font-family","'Ubuntu Mono', monospace")
      .attr("fill", "#111")
      .on("mouseover", highlight_nearest_neighbours)
      .on("mouseout", reset_highlight)
      .text(function(d) { return d; });

    zoomListener = d3.behavior.zoom()
      .scaleExtent([0.001, 2000])
      .translate([canvas_width / 2, canvas_height / 2])
      .scale(ss)
      .on("zoom", zoomHandler);
    zoomListener(svg);

    Y = filterd_data.points;
    updateEmbedding();
}

var to_keep = {};
var idx_prefix = "idx:"
function highlight_nearest_neighbours(point) {
    if (!$("#showNNs").is(":checked")) return;
    to_keep = {};
    point_idx = filterd_data.words.indexOf(point);
    if (point_idx == -1) return;
    for (i=0; i < filterd_data.neighbours[point_idx].length; i++) {
		idx = filterd_data.neighbours[point_idx][i];
		wd = "idx:" + data.words[idx];
		to_keep[wd] = null;
	}
    updateEmbedding();
}

function reset_highlight(d) {
	to_keep = {};
	updateEmbedding();
}

function updateEmbedding() {
  svg.selectAll('.u')
    .data(filterd_data.words)
    .attr("transform", function(d, i) { return "translate(" +
                                          ((Y[i][0]*ss + tx)) + "," +
                                          ((Y[i][1]*ss + ty)) + ")"; });
                                          
  svg.selectAll("circle")
        .attr("fill", function (d) {
			if (Object.keys(to_keep).length > 0 && !((idx_prefix + d) in to_keep)) {
				return "#fff6aa";
			} else {
				return "orange";
			}});

    svg.selectAll("text")
      .attr("fill", function (d) {
			if (Object.keys(to_keep).length > 0 && !((idx_prefix + d) in to_keep)) return "#ccc";
			return "#111";
		  });
}

var tx;
var ty;
var ss=2;
function zoomHandler() {
  tx = d3.event.translate[0];
  ty = d3.event.translate[1];
  ss = d3.event.scale;
  updateEmbedding();
}

var filterd_data;

$(window).load(function() {
    canvas_width = $(document).width() - 30;
    tx = canvas_width / 2;
    ty = canvas_height / 2;
	drawEmbedding(data);
	$("#filterInput").keyup(function() {drawEmbedding(data)});
  });
