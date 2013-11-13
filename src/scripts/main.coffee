'use strict'

require.config
  baseUrl: '/scripts'
  paths:
    # jQuery
    # <http://jquery.com/>
    jquery: '../components/jquery/jquery'

    # Lo-Dash
    # <http://lodash.com/>
    underscore: '../components/lodash/dist/lodash.compat'

    # Moment.js
    # <http://momentjs.com/>
    moment: '../components/moment/moment'

require ['application'], (Application) ->
  application = new Application()
  application.initialize()
