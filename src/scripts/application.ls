'use strict'

require! $: jquery
require! _: underscore
require! moment

# <http://stackoverflow.com/questions/10073699/pad-a-number-with-leading-zeros-in-javascript>
pad = (n, width, z = '0') ->
  n = n + ''
  if n.length >= width
    n
  else
    new Array(width - n.length + 1).join(z) + n

# <http://stackoverflow.com/a/5158301>
get-query-parameter = (name) ->
  pattern = RegExp('[?&]' + name + '=([^&]*)').exec(window.location.search)
  pattern && decodeURIComponent(pattern[1].replace(/\+/g, ' '))

module.exports = class Application

  number: 1

  max-slides: 5

  end: false

  animation-duration: 150

  update-url: ->
    query = if @end then '?end=true' else "?slide=#{@number}"
    url = "#{window.location.protocol}//#{window.location.host}#{window.location.pathname}#query"
    window.history.push-state {path: url}, '', url

  render-slide: ->
    id = pad @number, 4
    @end = false
    @$slide-container.remove-class 'no-more-slides'
    $.get "/slides/#id.html" .then (data) ~>
      @$slide-container.fade-out @animation-duration, ~>
        @update-url!
        @$slide.html data
        @$slide.attr \id, "slide_#id"
        @$slide-container.fade-in @animation-duration

  render-end: ->
    @$slide-container.fade-out @animation-duration, ~>
      @$slide.html ''
      @$slide.attr \id, 'slide'
      @$slide-container.add-class 'no-more-slides'
      @update-url!

  initialize: ->

    # Are we at the end?
    @end = get-query-parameter \end or false

    # Attempt to get saved slide number
    @number = get-query-parameter \slide
    @number = 1 unless @number
    @number = @max-slides if @number > @max-slides
    @number = Number @number
    if @end
      @number = @max-slides + 1

    @$slide = $ '#slide'
    @$slide-container = $ '#container'

    $ window .on \keydown, (event) ~>
      switch event.which
        case 37 # left
          return if @number is 1

          @number -= 1 unless @number is 1
          @render-slide!

        case 39, 32 # right or space
          return if @end

          if @number is @max-slides
            @end = true
            @number = @max-slides + 1
            @render-end!

          else
            @number += 1
            @render-slide!

    if @end
      @render-end!

    else
      @render-slide!
