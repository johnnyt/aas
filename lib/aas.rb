require "rubygems"
require "tnt"
require "aas/version"

module Aas
  RecordNotFoundError = Tnt.boom do |klass, id|
    "Could not locate #{klass} with id #{id}"
  end

  QueryNotImplementedError = Tnt.boom do |selector|
    "Adapter does not support #{selector.class}!"
  end

  NoQueryResultError = Tnt.boom do |selector|
    "Query #{selector.class} must return results!"
  end
end

require_relative "aas/utils/array_utils"
require_relative "aas/utils/hash_utils"
require_relative "aas/utils/string_utils"
require_relative "aas/model"
require_relative "aas/repo"
require_relative "aas/memory_store"
