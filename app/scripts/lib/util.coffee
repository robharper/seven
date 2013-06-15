module.exports = Util =
  merge: (dest, src) ->
    for key,value of src
      dest[key] = value if src.hasOwnProperty(key)
    dest