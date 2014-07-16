require "helpers"

module API
  class Root < Grape::API
    prefix 'api'
    format :json

    helpers APIHelpers
    
    mount API::V1::Root
    # mount API::V2::Root (next version)
  end
end