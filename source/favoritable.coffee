module.exports = class Favoritable
  toParams: (value)->
    params = {}
    params[@constructor.name] = value
    params
