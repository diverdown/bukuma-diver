module.exports = class LocalStorable
  @all: ->
    @_collection

  @restore: ->
    JSON.parse(localStorage.getItem(@name))

  @save: ->
    localStorage.setItem(@name, JSON.stringify(@_collection))
