'use strict'

require.config do
  base-url: '/scripts'
  paths:
    # jQuery
    # <http://jquery.com/>
    jquery: '../bower_components/jquery/jquery'

    # Lo-Dash
    # <http://lodash.com/>
    underscore: '../bower_components/lodash/dist/lodash.compat'

    # Moment.js
    # <http://momentjs.com/>
    moment: '../bower_components/moment/moment'

require <[ application ]>, (Application) ->
  application = new Application
  application.initialize!
