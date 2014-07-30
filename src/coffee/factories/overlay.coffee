overlay = [ '$timeout', '$rootScope',  '$rootElement', '$compile','$window', ($timeout, $rootScope, $rootElement, $compile, $window) ->
  STATICS =
    SUCCESS_CLASS: 'fa fa-check fa-5x'
    ERROR_CLASS: 'fa fa-times fa-5x'

  defaultOpts =
    duration: 3000 #ms
    type: 'success' #success or error
    text: 'Success!' #default text
    $scope: $rootScope.$new();
  timeoutPromise = null
  #helper to insert and animate elements
  _insertElement = (duration, element) ->
    #if element already exists, remove first
    if t = document.querySelector('.toast')
      t.remove()
    #add animation class and append to DOM
    $rootElement.append(element)
    domElement = document.querySelector('.toast')
    #center element vertically
    margin = domElement.offsetHeight / 2
    domElement.style["margin-top"] = "-#{margin}px"
    #add show class (fade-in animation)
    element.addClass('toast-show')
    #cancel timeout promise if element existed
    $timeout.cancel(timeoutPromise) if timeoutPromise
    #create timeoutPromise, removing the element with animation
    timeoutPromise = $timeout ->
      #note that this preserves the toast DOM node, but it is overwritten
      #upon next invokation anyways (see line 15)
      element.removeClass('toast-show').addClass('toast-hide')
      $timeout ->
        document.querySelector('.toast').remove()
      , 750 #hack, we might as well just use ngAnimate
      timeoutPromise = null
    , duration

  #shows a toast with specified options
  showToast = (opts) ->
    iconClass = if opts.type == 'success' then STATICS.SUCCESS_CLASS else STATICS.ERROR_CLASS
    html = """
      <div class="toast">
        <i class="#{iconClass}"></i>
        <span>#{opts.text}</span>
      </div>
    """
    #new scope or inherited from opts
    $scope = opts.$scope
    #compile element with angular scope
    element = $compile(html)($scope)
    #append and remove after timeout
    _insertElement(opts.duration, element)

  {
    show: (opts) ->
      #shortcut for success messages
      opts = { text: opts } if typeof opts == 'string'
      opts = angular.extend defaultOpts, opts
      showToast(opts)
  }
]
module.exports = overlay
