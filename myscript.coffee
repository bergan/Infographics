width = window.innerWidth
height = window.innerHeight


svg = d3.select('body').append('svg')
.attr('width', width)
.attr('height', height)

force = d3.layout.force()
.distance(20)
.charge(-100)
.linkStrength(0.5)
.size([ width, height])

d3.json 'graph.json', (error, graph) ->
  force.nodes(graph.nodes).links(graph.links).start()
  link = svg.selectAll('.link').data(graph.links).enter().append('line').attr('class', 'link')
  node = svg.selectAll('.node').data(graph.nodes).enter().append('g').attr('class', 'node')

  r = 15

  #create circles
  node
  .append('circle')
  .attr('class', (d) -> d.Class)
  .style('stroke', 'white')
  .style('stroke-width', 2)
  .attr('r', r)
  .call(force.drag)

  #create labels
  node.append('text')
  .attr('text-anchor', 'middle').attr('alignment-baseline', 'middle')
  .attr('word-break', 'break-all')
  .style('fill', 'black')
  .text (d) -> d.Name

  node.on('')

  #do force calculations
  force.on 'tick', ->
    link
    .attr('x1', (d) -> d.source.x)
    .attr('y1', (d) -> d.source.y)
    .attr('x2', (d) -> d.target.x)
    .attr('y2', (d) -> d.target.y)

    node
    .attr 'transform', (d) -> 'translate(' + d.x + ',' + d.y + ')'