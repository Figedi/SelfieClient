overlay = [ '$timeout', '$rootScope',  '$rootElement', '$compile','$window', ($timeout, $rootScope, $rootElement, $compile, $window) ->
  STATICS =
    SUCCESS_CLASS: 'fa fa-check fa-5x'
    ERROR_CLASS: 'fa fa-times fa-5x'

  defaultOpts =
    duration: 5000 #ms
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
    element.addClass('toast-show')
    $rootElement.append(element)
    #cancel timeout promise if element existed
    $timeout.cancel(timeoutPromise) if timeoutPromise
    #create timeoutPromise, removing the element with animation
    timeoutPromise = $timeout ->
      #note that this preserves the toast DOM node, but it is overwritten
      #upon next invokation anyways (see line 15)
      element.removeClass('toast-show').addClass('toast-hide')
      timeoutPromise = null
    , duration

  #shows a toast with specified options
  showToast = (opts) ->
    iconClass = if opts.type == 'success' then STATICS.SUCCESS_CLASS else STATICS.ERROR_CLASS
    html = """
      <div class="toast #{opts.type}">
        <i class="#{iconClass}">
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
      opts = angular.extend defaultOpts, opts
      showToast(opts)
  }
]
module.exports = overlay
